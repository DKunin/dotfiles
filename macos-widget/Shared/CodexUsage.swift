import Foundation
import Darwin

let CodexLimitWidgetKind = "CodexLimitWidget"

struct CodexUsage: Sendable {
    let remainingPercent: Int
    let mainWindows: [QuotaWindow]
    let additionalLimits: [AdditionalLimit]
    let plan: String?
    let creditBalance: Double?

    static let preview = CodexUsage(
        remainingPercent: 72,
        mainWindows: [
            QuotaWindow(label: "5 hours", remainingPercent: 72, resetAt: .now.addingTimeInterval(7_200)),
            QuotaWindow(label: "Weekly", remainingPercent: 84, resetAt: .now.addingTimeInterval(345_600))
        ],
        additionalLimits: [],
        plan: "pro",
        creditBalance: 132.29
    )
}

struct QuotaWindow: Identifiable, Sendable {
    let label: String
    let remainingPercent: Int
    let resetAt: Date

    var id: String { "\(label)-\(resetAt.timeIntervalSince1970)" }
}

struct AdditionalLimit: Sendable {
    let name: String
    let windows: [QuotaWindow]
}

struct CodexUsageClient: Sendable {
    private let homeDirectory: URL
    private let usageURL: URL

    init(
        homeDirectory: URL? = nil,
        usageURL: URL = URL(string: "https://chatgpt.com/backend-api/wham/usage")!
    ) {
        self.homeDirectory = homeDirectory ?? Self.accountHomeDirectory()
        self.usageURL = usageURL
    }

    private static func accountHomeDirectory() -> URL {
        guard let passwordEntry = getpwuid(getuid()) else {
            return FileManager.default.homeDirectoryForCurrentUser
        }
        return URL(fileURLWithPath: String(cString: passwordEntry.pointee.pw_dir), isDirectory: true)
    }

    func fetch() async throws -> CodexUsage {
        try await Task.detached(priority: .utility) {
            try fetchSynchronously()
        }.value
    }

    private func fetchSynchronously() throws -> CodexUsage {
        let proxy = try readProxyConfig()
        let auth = try readAuth()
        let proxyURL = makeProxyURL(proxy)
        let curlConfig = """
        proxy = "\(proxyURL)"
        header = "Authorization: Bearer \(auth.tokens.accessToken)"
        header = "ChatGPT-Account-Id: \(auth.tokens.accountID)"
        header = "Accept: application/json"
        """

        let process = Process()
        let standardInput = Pipe()
        let standardOutput = Pipe()
        let standardError = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/curl")
        process.arguments = [
            "--config", "-",
            "--silent",
            "--show-error",
            "--connect-timeout", "10",
            "--max-time", "25",
            "--write-out", "\\n%{http_code}",
            usageURL.absoluteString
        ]
        process.standardInput = standardInput
        process.standardOutput = standardOutput
        process.standardError = standardError

        try process.run()
        standardInput.fileHandleForWriting.write(Data(curlConfig.utf8))
        try standardInput.fileHandleForWriting.close()
        let output = try standardOutput.fileHandleForReading.readToEnd() ?? Data()
        let errorOutput = try standardError.fileHandleForReading.readToEnd() ?? Data()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            let message = String(decoding: errorOutput, as: UTF8.self)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            throw CodexUsageError.transport(message.isEmpty ? "curl failed" : message)
        }
        guard let separator = output.lastIndex(of: 0x0A) else {
            throw CodexUsageError.invalidResponse
        }
        let body = output[..<separator]
        let statusData = output[output.index(after: separator)...]
        let status = Int(String(decoding: statusData, as: UTF8.self))
        guard status == 200 else {
            if status == 401 {
                throw CodexUsageError.expiredLogin
            }
            throw CodexUsageError.http(status ?? 0)
        }

        return try Self.decode(Data(body))
    }

    static func decode(_ data: Data) throws -> CodexUsage {
        let response = try JSONDecoder().decode(UsageResponse.self, from: data)
        let mainWindows = response.rateLimit.windows.map(Self.makeWindow)
        guard !mainWindows.isEmpty else {
            throw CodexUsageError.missingQuota
        }
        let additionalLimits = response.additionalRateLimits.map { limit in
            AdditionalLimit(name: limit.limitName, windows: limit.rateLimit.windows.map(Self.makeWindow))
        }

        return CodexUsage(
            remainingPercent: mainWindows.map(\.remainingPercent).min() ?? 0,
            mainWindows: mainWindows,
            additionalLimits: additionalLimits,
            plan: response.planType,
            creditBalance: response.credits?.balance.flatMap(Double.init)
        )
    }

    private static func makeWindow(_ window: UsageWindow) -> QuotaWindow {
        QuotaWindow(
            label: label(for: window.limitWindowSeconds),
            remainingPercent: max(0, min(100, Int(floor(100 - window.usedPercent)))),
            resetAt: Date(timeIntervalSince1970: window.resetAt)
        )
    }

    static func label(for seconds: Int) -> String {
        switch seconds {
        case 18_000: "5 hours"
        case 86_400: "Daily"
        case 604_800: "Weekly"
        case 2_592_000, 2_678_400: "Monthly"
        case 3_600...: "\(seconds / 3_600) hours"
        default: "\(seconds / 60) minutes"
        }
    }

    private func readProxyConfig() throws -> ProxyConfig {
        let url = homeDirectory
            .appendingPathComponent("Library/Application Support/telegram-via-socks/proxy-config.json")
        let config = try decodeFile(ProxyConfig.self, at: url, missingError: .missingProxyConfig)
        guard config.protocolName == "socks5", (1...65_535).contains(config.port) else {
            throw CodexUsageError.invalidProxyConfig
        }
        return config
    }

    private func readAuth() throws -> AuthFile {
        let url = homeDirectory.appendingPathComponent(".codex/auth.json")
        return try decodeFile(AuthFile.self, at: url, missingError: .missingAuth)
    }

    private func makeProxyURL(_ proxy: ProxyConfig) -> String {
        let credentials: String
        if let username = proxy.username, let password = proxy.password {
            credentials = "\(percentEncode(username)):\(percentEncode(password))@"
        } else {
            credentials = ""
        }
        return "socks5h://\(credentials)\(proxy.host):\(proxy.port)"
    }

    private func percentEncode(_ value: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
    }

    private func decodeFile<T: Decodable>(
        _ type: T.Type,
        at url: URL,
        missingError: CodexUsageError
    ) throws -> T {
        guard FileManager.default.fileExists(atPath: url.path) else { throw missingError }
        return try JSONDecoder().decode(type, from: Data(contentsOf: url))
    }
}

enum CodexUsageError: LocalizedError {
    case missingProxyConfig
    case invalidProxyConfig
    case missingAuth
    case expiredLogin
    case invalidResponse
    case missingQuota
    case http(Int)
    case transport(String)

    var errorDescription: String? {
        switch self {
        case .missingProxyConfig: "SOCKS proxy config not found."
        case .invalidProxyConfig: "SOCKS proxy config is invalid."
        case .missingAuth: "Run codex login first."
        case .expiredLogin: "Codex login expired. Open Codex to refresh it."
        case .invalidResponse: "Codex returned an invalid response."
        case .missingQuota: "Codex returned no quota windows."
        case .http(let status): "Codex request failed (HTTP \(status))."
        case .transport(let message): "SOCKS request failed: \(message)"
        }
    }
}

private struct ProxyConfig: Decodable {
    let protocolName: String
    let host: String
    let port: Int
    let username: String?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case protocolName = "protocol"
        case host, port, username, password
    }
}

private struct AuthFile: Decodable {
    let tokens: Tokens

    struct Tokens: Decodable {
        let accessToken: String
        let accountID: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case accountID = "account_id"
        }
    }
}

private struct UsageResponse: Decodable {
    let planType: String?
    let rateLimit: RateLimit
    let additionalRateLimits: [NamedRateLimit]
    let credits: Credits?

    enum CodingKeys: String, CodingKey {
        case planType = "plan_type"
        case rateLimit = "rate_limit"
        case additionalRateLimits = "additional_rate_limits"
        case credits
    }
}

private struct RateLimit: Decodable {
    let primaryWindow: UsageWindow?
    let secondaryWindow: UsageWindow?

    var windows: [UsageWindow] { [primaryWindow, secondaryWindow].compactMap { $0 } }

    enum CodingKeys: String, CodingKey {
        case primaryWindow = "primary_window"
        case secondaryWindow = "secondary_window"
    }
}

private struct NamedRateLimit: Decodable {
    let limitName: String
    let rateLimit: RateLimit

    enum CodingKeys: String, CodingKey {
        case limitName = "limit_name"
        case rateLimit = "rate_limit"
    }
}

private struct UsageWindow: Decodable {
    let usedPercent: Double
    let limitWindowSeconds: Int
    let resetAt: TimeInterval

    enum CodingKeys: String, CodingKey {
        case usedPercent = "used_percent"
        case limitWindowSeconds = "limit_window_seconds"
        case resetAt = "reset_at"
    }
}

private struct Credits: Decodable {
    let balance: String?
}

import AppIntents

struct RefreshCodexLimitIntent: AppIntent {
    static let title: LocalizedStringResource = "Refresh Codex Limit"
    static let description = IntentDescription("Fetch the latest Codex quota usage.")
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        .result()
    }
}

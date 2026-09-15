import XCTest

final class CodexUsageTests: XCTestCase {
    func testDecodesMainAndAdditionalLimits() throws {
        let json = Data(
            """
            {
              "plan_type": "prolite",
              "rate_limit": {
                "primary_window": {"used_percent": 6.5, "limit_window_seconds": 604800, "reset_at": 1788154307},
                "secondary_window": null
              },
              "additional_rate_limits": [{
                "limit_name": "Spark",
                "rate_limit": {
                  "primary_window": {"used_percent": 25, "limit_window_seconds": 18000, "reset_at": 1787604491},
                  "secondary_window": null
                }
              }],
              "credits": {"balance": "132.2906420000"}
            }
            """.utf8
        )

        let usage = try CodexUsageClient.decode(json)

        XCTAssertEqual(usage.remainingPercent, 93)
        XCTAssertEqual(usage.mainWindows.first?.label, "Weekly")
        XCTAssertEqual(usage.additionalLimits.first?.windows.first?.remainingPercent, 75)
        XCTAssertEqual(usage.creditBalance, 132.290642)
    }

    func testWindowLabels() {
        XCTAssertEqual(CodexUsageClient.label(for: 18_000), "5 hours")
        XCTAssertEqual(CodexUsageClient.label(for: 604_800), "Weekly")
        XCTAssertEqual(CodexUsageClient.label(for: 7_200), "2 hours")
    }

    func testRefreshIntentRunsWithoutOpeningApp() async throws {
        XCTAssertFalse(RefreshCodexLimitIntent.openAppWhenRun)
        _ = try await RefreshCodexLimitIntent().perform()
    }

    func testLiveFetchWhenEnabled() async throws {
        guard ProcessInfo.processInfo.environment["CODEX_LIVE_TEST"] == "1" else {
            throw XCTSkip("Set CODEX_LIVE_TEST=1 to call the live Codex endpoint.")
        }

        let usage = try await CodexUsageClient().fetch()
        XCTAssertTrue((0...100).contains(usage.remainingPercent))
        XCTAssertFalse(usage.mainWindows.isEmpty)
    }
}

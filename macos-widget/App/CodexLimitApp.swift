import SwiftUI
import WidgetKit

@main
struct CodexLimitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(client: CodexUsageClient())
        }
        .windowResizability(.contentSize)
    }
}

private struct ContentView: View {
    let client: CodexUsageClient

    @State private var state: LoadState = .loading

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gauge.with.dots.needle.67percent")
                .font(.system(size: 42))
                .foregroundStyle(.blue)

            switch state {
            case .loading:
                ProgressView("Loading Codex usage…")
            case .loaded(let usage):
                VStack(spacing: 6) {
                    Text("\(usage.remainingPercent)%")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                    Text("Codex quota remaining")
                        .foregroundStyle(.secondary)
                    if let reset = usage.mainWindows.first?.resetAt {
                        Text("Resets \(reset.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            case .failed(let message):
                ContentUnavailableView(
                    "Usage unavailable",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }

            Button("Refresh widget") {
                Task { await refresh() }
            }
            .keyboardShortcut("r")

            Text("Add “Codex Limit” from Notification Center’s Edit Widgets screen.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(28)
        .frame(width: 380, height: 330)
        .task { await refresh() }
    }

    @MainActor
    private func refresh() async {
        state = .loading
        do {
            state = .loaded(try await client.fetch())
            WidgetCenter.shared.reloadTimelines(ofKind: CodexLimitWidgetKind)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

private enum LoadState {
    case loading
    case loaded(CodexUsage)
    case failed(String)
}

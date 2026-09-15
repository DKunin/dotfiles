import SwiftUI
import WidgetKit

@main
struct CodexLimitWidgetBundle: WidgetBundle {
    var body: some Widget {
        CodexLimitWidget()
    }
}

struct CodexLimitWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: CodexLimitWidgetKind, provider: CodexLimitProvider()) { entry in
            Button(intent: RefreshCodexLimitIntent()) {
                CodexLimitWidgetView(entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Refresh Codex usage")
            .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Codex Limit")
        .description("Remaining Codex quota and its next reset time.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CodexLimitEntry: TimelineEntry {
    let date: Date
    let state: EntryState
}

enum EntryState {
    case loaded(CodexUsage)
    case failed(String)
}

struct CodexLimitProvider: TimelineProvider {
    func placeholder(in context: Context) -> CodexLimitEntry {
        CodexLimitEntry(date: .now, state: .loaded(.preview))
    }

    func getSnapshot(in context: Context, completion: @escaping (CodexLimitEntry) -> Void) {
        if context.isPreview {
            completion(placeholder(in: context))
            return
        }
        load(completion: completion)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CodexLimitEntry>) -> Void) {
        load { entry in
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: .now) ?? .now.addingTimeInterval(300)
            completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
        }
    }

    private func load(completion: @escaping (CodexLimitEntry) -> Void) {
        let completionBox = EntryCompletion(completion)
        Task {
            let state: EntryState
            do {
                state = .loaded(try await CodexUsageClient().fetch())
            } catch {
                state = .failed(error.localizedDescription)
            }
            completionBox.call(CodexLimitEntry(date: .now, state: state))
        }
    }
}

private final class EntryCompletion: @unchecked Sendable {
    let call: (CodexLimitEntry) -> Void

    init(_ call: @escaping (CodexLimitEntry) -> Void) {
        self.call = call
    }
}

private struct CodexLimitWidgetView: View {
    let entry: CodexLimitEntry

    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch entry.state {
        case .loaded(let usage):
            loadedView(usage)
        case .failed(let message):
            errorView(message)
        }
    }

    @ViewBuilder
    private func loadedView(_ usage: CodexUsage) -> some View {
        if family == .systemMedium {
            HStack(spacing: 20) {
                quotaRing(usage)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading, spacing: 5) {
                    Label("Codex", systemImage: "terminal")
                        .font(.headline)
                    ForEach(usage.mainWindows.prefix(2)) { window in
                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(window.label): \(window.remainingPercent)% left")
                                .font(.subheadline.weight(.semibold))
                            Text("Resets \(window.resetAt, style: .relative)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if let credits = usage.creditBalance {
                        Text("\(credits.formatted(.number.precision(.fractionLength(2)))) credits")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("Updated \(entry.date.formatted(date: .omitted, time: .standard))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
            }
            .padding()
        } else {
            VStack(spacing: 8) {
                HStack {
                    Label("Codex", systemImage: "terminal")
                        .font(.headline)
                    Spacer()
                }
                quotaRing(usage)
                if let reset = usage.mainWindows.first?.resetAt {
                    Text("Resets \(reset, style: .relative)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }

    private func quotaRing(_ usage: CodexUsage) -> some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: 10)
            Circle()
                .trim(from: 0, to: Double(usage.remainingPercent) / 100)
                .stroke(
                    quotaColor(usage.remainingPercent),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("\(usage.remainingPercent)%")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .minimumScaleFactor(0.7)
                Text("left")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundStyle(.orange)
            Text("Codex unavailable")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }

    private func quotaColor(_ remaining: Int) -> Color {
        switch remaining {
        case ...10: .red
        case ...25: .orange
        default: .green
        }
    }
}

#Preview(as: .systemSmall) {
    CodexLimitWidget()
} timeline: {
    CodexLimitEntry(date: .now, state: .loaded(.preview))
}

#Preview(as: .systemMedium) {
    CodexLimitWidget()
} timeline: {
    CodexLimitEntry(date: .now, state: .loaded(.preview))
}

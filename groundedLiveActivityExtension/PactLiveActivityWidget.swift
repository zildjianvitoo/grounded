import ActivityKit
import SwiftUI
import WidgetKit

struct PactLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PactActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    statusDot(for: context)

                    Text(context.attributes.taskTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.88))
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    if isBreakActive(context) {
                        statusChip(for: context)
                    }
                }

                Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.white)
            }
            .padding(16)
            .activityBackgroundTint(Color.black.opacity(0.92))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        statusDot(for: context)

                        if isBreakActive(context) {
                            Text("Break")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.white.opacity(0.78))
                        }
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if isBreakActive(context) {
                        statusChip(for: context)
                    }
                }

                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.taskTitle)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .foregroundStyle(Color.white.opacity(0.9))
                }

                DynamicIslandExpandedRegion(.bottom) {
                    Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } compactLeading: {
                statusDot(for: context)
            } compactTrailing: {
                Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                    .font(.caption2.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            } minimal: {
                statusDot(for: context)
            }
            .keylineTint(keylineColor(for: context))
        }
    }

    private func isBreakActive(_ context: ActivityViewContext<PactActivityAttributes>) -> Bool {
        context.state.statusText.localizedCaseInsensitiveContains("break")
    }

    @ViewBuilder
    private func statusChip(for context: ActivityViewContext<PactActivityAttributes>) -> some View {
        Text(context.state.statusText)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Color.white.opacity(0.86))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.10))
            )
    }

    private func statusDot(for context: ActivityViewContext<PactActivityAttributes>) -> some View {
        Circle()
            .fill(keylineColor(for: context))
            .frame(width: 8, height: 8)
    }

    private func keylineColor(for context: ActivityViewContext<PactActivityAttributes>) -> Color {
        if isBreakActive(context) {
            return Color(red: 0.93, green: 0.45, blue: 0.24)
        }

        return Color(red: 0.92, green: 0.78, blue: 0.61)
    }
}

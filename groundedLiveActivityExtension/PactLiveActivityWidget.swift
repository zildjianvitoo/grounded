import ActivityKit
import SwiftUI
import WidgetKit

struct PactLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PactActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text("Pact")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 0)

                    Text(context.state.statusText)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.14))
                        )
                }

                Text(context.attributes.taskTitle)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.white)
                    .lineLimit(2)

                Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color(red: 0.53, green: 0.91, blue: 0.78))
            }
            .padding(16)
            .activityBackgroundTint(Color.black.opacity(0.92))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Pact", systemImage: "scope")
                        .font(.caption.weight(.semibold))
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.statusText)
                        .font(.caption2.weight(.semibold))
                        .multilineTextAlignment(.trailing)
                }

                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.taskTitle)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                            .foregroundStyle(Color.green)

                        Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                            .font(.title3.weight(.bold))
                            .monospacedDigit()

                        Spacer(minLength: 0)
                    }
                }
            } compactLeading: {
                Image(systemName: "scope")
            } compactTrailing: {
                Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                    .font(.caption2.weight(.semibold))
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "scope")
            }
            .keylineTint(Color(red: 0.53, green: 0.91, blue: 0.78))
        }
    }
}

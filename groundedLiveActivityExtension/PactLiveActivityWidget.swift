import ActivityKit
import SwiftUI
import WidgetKit

struct PactLiveActivityWidget: Widget {
    private let distractionThreshold: TimeInterval = 15

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PactActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    statusIndicator(for: context)

                    Text(context.attributes.taskTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.88))
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    if isBreakActive(context) && !shouldShowAwayDuration(for: context, at: .now) {
                        statusChip(for: context)
                    }
                }

                primaryTimer(for: context, fontSize: 38, alignment: .leading, isLeadingAligned: true)
            }
            .padding(16)
            .activityBackgroundTint(Color.black.opacity(0.92))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    statusIndicator(for: context)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if isBreakActive(context) && !shouldShowAwayDuration(for: context, at: .now) {
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
                    primaryTimer(for: context, fontSize: 30, alignment: .center, isLeadingAligned: false)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } compactLeading: {
                statusIndicator(for: context)
            } compactTrailing: {
                compactStatusText(for: context)
            } minimal: {
                statusIndicator(for: context)
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

    @ViewBuilder
    private func statusIndicator(for context: ActivityViewContext<PactActivityAttributes>) -> some View {
        TimelineView(.periodic(from: context.state.startedAt, by: 1)) { timeline in
            Image(systemName: "scope")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(indicatorColor(for: context, at: timeline.date))
                .frame(width: 17, height: 17)
        }
    }

    @ViewBuilder
    private func compactStatusText(for context: ActivityViewContext<PactActivityAttributes>) -> some View {
        TimelineView(.periodic(from: context.state.startedAt, by: 1)) { timeline in
            if shouldShowAwayDuration(for: context, at: timeline.date) {
                Text(formattedDuration(since: context.state.breakStartedAt ?? timeline.date, now: timeline.date))
                    .frame(maxWidth: 40)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.white.opacity(0.92))
                    .fixedSize(horizontal: true, vertical: false)
            } else {
                Text(context.state.targetEndAt, style: .timer)
                    .frame(maxWidth: 40)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.white.opacity(0.92))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.8)
            }
        }
    }

    @ViewBuilder
    private func primaryTimer(
        for context: ActivityViewContext<PactActivityAttributes>,
        fontSize: CGFloat,
        alignment: Alignment,
        isLeadingAligned: Bool
    ) -> some View {
        TimelineView(.periodic(from: context.state.startedAt, by: 1)) { timeline in
            if shouldShowAwayDuration(for: context, at: timeline.date) {
                VStack(alignment: isLeadingAligned ? .leading : .center, spacing: 4) {
                    Text("Away")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.68))

                    Text(formattedDuration(since: context.state.breakStartedAt ?? timeline.date, now: timeline.date))
                       
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: alignment)
            } else {
                Text(timerInterval: context.state.startedAt...context.state.targetEndAt, countsDown: true)
                   
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
    }

    private func indicatorColor(
        for context: ActivityViewContext<PactActivityAttributes>,
        at date: Date
    ) -> Color {
        if isBreakActive(context) {
            let awayProgress = min(max(activeBreakDuration(for: context, at: date) / 60, 0), 1)
            let start = (red: 0.89, green: 0.43, blue: 0.23)
            let end = (red: 0.83, green: 0.16, blue: 0.13)

            return Color(
                red: start.red + ((end.red - start.red) * awayProgress),
                green: start.green + ((end.green - start.green) * awayProgress),
                blue: start.blue + ((end.blue - start.blue) * awayProgress)
            )
        }

        let totalDuration = max(context.state.targetEndAt.timeIntervalSince(context.state.startedAt), 1)
        let elapsed = min(max(date.timeIntervalSince(context.state.startedAt), 0), totalDuration)
        let progress = elapsed / totalDuration

        let start = (red: 0.95, green: 0.56, blue: 0.29)
        let end = (red: 0.86, green: 0.20, blue: 0.16)

        return Color(
            red: start.red + ((end.red - start.red) * progress),
            green: start.green + ((end.green - start.green) * progress),
            blue: start.blue + ((end.blue - start.blue) * progress)
        )
    }

    private func keylineColor(for context: ActivityViewContext<PactActivityAttributes>) -> Color {
        if isBreakActive(context) {
            return Color(red: 0.89, green: 0.43, blue: 0.23)
        }

        return Color.white.opacity(0.82)
    }

    private func activeBreakDuration(
        for context: ActivityViewContext<PactActivityAttributes>,
        at date: Date
    ) -> TimeInterval {
        guard let breakStartedAt = context.state.breakStartedAt else {
            return 0
        }

        return max(date.timeIntervalSince(breakStartedAt), 0)
    }

    private func shouldShowAwayDuration(
        for context: ActivityViewContext<PactActivityAttributes>,
        at date: Date
    ) -> Bool {
        isBreakActive(context) && activeBreakDuration(for: context, at: date) >= distractionThreshold
    }

    private func formattedDuration(since start: Date, now: Date) -> String {
        let totalSeconds = max(Int(now.timeIntervalSince(start)), 0)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

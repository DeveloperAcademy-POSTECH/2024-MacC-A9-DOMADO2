//
//  SpeedDistributionView.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import SwiftUI

struct SpeedDistributionView: View {
    let segments: [(ratio: CGFloat, time: TimeInterval)]
    let speedColors: [Color] = [.electricBlue, .lavenderPurple, .sunsetOrange ]
    let speedLabels: [String] =  ["느림", "보통", "빠름"]
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let barSpacing: CGFloat = 4
    private let circleSize: CGFloat = 8
    private let minSegmentWidth: CGFloat = 60 // 최소 세그먼트 너비
    
    private func calculateWidths(for size: CGFloat) -> [CGFloat] {
        let totalWidth = size - (CGFloat(segments.count - 1) * barSpacing)
        let totalMinWidth = CGFloat(segments.count) * minSegmentWidth
        
        if totalWidth <= totalMinWidth {
            return Array(repeating: minSegmentWidth, count: segments.count)
        }
        
        let remainingWidth = totalWidth - totalMinWidth
        let totalRatio = segments.reduce(0) { $0 + $1.ratio }
        
        return segments.map { segment in
            minSegmentWidth + (remainingWidth * (segment.ratio / totalRatio))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let widths = calculateWidths(for: geometry.size.width)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: barSpacing) {
                        ForEach(0..<segments.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(speedColors[index])
                                .frame(width: widths[index], height: 30)
                        }
                    }
                    
                    HStack(spacing: barSpacing) {
                        ForEach(0..<segments.count, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text(speedLabels[index])
                                        .customFont(.subInfoTitle)
                                    Circle()
                                        .fill(speedColors[index])
                                        .frame(width: circleSize, height: circleSize)
                                }
                                Text(segments[index].time > 0 ? segments[index].time.formatTimeInMinutes() : "-")
                                    .customFont(.supplementaryTimeDistanceNumber)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                            .frame(width: widths[index])
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .frame(height: 90)
            .padding(.vertical)
        }
    }
}

struct SpeedDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpeedDistributionView(
                segments: [
                    (ratio: 0.3, time: 3600),
                    (ratio: 0.5, time: 7200),
                    (ratio: 0.2, time: 1800)
                ]
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Light Mode")

            SpeedDistributionView(
                segments: [
                    (ratio: 0, time: 0),
                    (ratio: 0.8, time: 3600),
                    (ratio: 0.2, time: 1800)
                ]
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode with Zero Time")
        }
    }
}

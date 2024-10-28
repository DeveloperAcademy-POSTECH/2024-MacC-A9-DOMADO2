//
//  SpeedDistributionView.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import SwiftUI

struct SpeedDistributionView: View {
    let segments: [(ratio: Double, time: TimeInterval)]
    let speedColors: [Color] = [.electricBlue, .lavenderPurple, .sunsetOrange]
    let speedLabels: [String] = [String(localized: "slow"), String(localized: "steady"), String(localized: "fast")]
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let barSpacing: CGFloat = 8
    private let circleSize: CGFloat = 7
    private let minSegmentWidth: CGFloat = 60 // 최소 세그먼트 너비
    
    private func calculateWidths(for size: CGFloat) -> [CGFloat] {
        let totalWidth = size - (CGFloat(segments.count - 1) * barSpacing)
        let totalMinWidth = CGFloat(segments.count) * minSegmentWidth
        
        if totalWidth <= totalMinWidth {
            return Array(repeating: minSegmentWidth, count: segments.count)
        }
        
        let remainingWidth = totalWidth - totalMinWidth
        let totalRatio = segments.reduce(0.0) { $0 + $1.ratio }
        
        return segments.map { segment in
            minSegmentWidth + (remainingWidth * CGFloat(segment.ratio / totalRatio))
        }
    }
    
    var body: some View {
        VStack {
            if segments.isEmpty {
                emptyStateView
            } else {
                contentView
            }
        }
        .frame(height: 90)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "speedometer")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("속도 분포 데이터가 없습니다")
                .customFont(.subInfoTitle)
        }
    }
    
    private var contentView: some View {
        GeometryReader { geometry in
            let widths = calculateWidths(for: geometry.size.width)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: barSpacing) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        VStack (spacing: 0) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(speedColors[index])
                                .frame(width: widths[index], height: 17)
                                .padding(.bottom, 17)
                            
                            VStack(alignment: .leading, spacing: 0){
                                HStack(spacing: 6) {
                                    Text(speedLabels[index])
                                        .customFont(.subInfoTitle)
                                        .foregroundStyle(.midnightCharcoal)
                                    Circle()
                                        .fill(speedColors[index])
                                        .frame(width: circleSize, height: circleSize)
                                }
                                .padding(.bottom, 10)
                                
                                Text(segments[index].time > 0 ? segments[index].time.formatTimeInMinutes() : "-")
                                    .customFont(.supplementaryTimeDistanceNumber)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                            }
                        }
                    }
                }
            }
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
                    (ratio: 0.0, time: 0),
                    (ratio: 0.8, time: 3600),
                    (ratio: 0.2, time: 1800)
                ]
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode with Zero Time")
            
            
            SpeedDistributionView(
                segments: []
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("No Distribution")
        }
    }
}

//
//  ArcRangeSlider.swift
//  DomadoV
//
//  Created by 이종선 on 10/21/24.
//

import SwiftUI

struct ArcRangeSlider: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var range: ClosedRange<Double>
    
    private let minimumGap: Double = 10
    private let numberOfMajorTicks: Int = 12 + 1
    private let numberOfMinorTicks: Int = 60
    private let sliderWidth: CGFloat = 50
    private let tickLength: CGFloat = 3.5
    private let majorTickLength: CGFloat = 10.5
    private let gapBetweenSliderAndTicks: CGFloat = 3
    private let handleSize: CGFloat = 39

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let radius = size.width / 2
            let centerX = size.width / 2
            let centerY = size.height

            ZStack {
                // Background arc
                Path { path in
                    path.addArc(center: CGPoint(x: centerX, y: centerY),
                                radius: radius,
                                startAngle: .degrees(0),
                                endAngle: .degrees(180),
                                clockwise: true)
                }
                .stroke(
                    (colorScheme == .dark ? Color.white.opacity(0.3) : Color.midnightCharcoal.opacity(0.1)),
                    style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round, lineJoin: .round)
                )

                // Selected range arc
                Path { path in
                    path.addArc(center: CGPoint(x: centerX, y: centerY),
                                radius: radius,
                                startAngle: Angle(degrees: 180 + ( range.lowerBound / 60 * 180)),
                                endAngle: Angle(degrees: 180 + (range.upperBound / 60 * 180)),
                                clockwise: false)
                }
                .stroke(.lavenderPurple ,style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round, lineJoin: .round))

                // Minor ticks
                ForEach(0..<numberOfMinorTicks) { index in
                    self.tickMark(at: index, in: size, isMajor: false)
                }

                // Major ticks and labels
                ForEach(0..<numberOfMajorTicks) { index in
                    Group {
                        self.tickMark(at: index * 5, in: size, isMajor: true)
                        if index % 6 == 0 {
                            self.label(for: index * 5, in: size)
                        }
                    }
                }

                // Start handle with bicycle symbol
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: handleSize, height: handleSize)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0)
                    Image(systemName: "bicycle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: handleSize * 0.6, height: handleSize * 0.6)
                        .foregroundColor(.lavenderPurple)
                }
                .position(self.position(for: range.lowerBound , in: size))
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            self.handleDrag(drag: drag, in: size, isStartHandle: true)
                        }
                )

                // End handle with bicycle symbol
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: handleSize, height: handleSize)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0)
                    Image(systemName: "bicycle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: handleSize * 0.6, height: handleSize * 0.6)
                        .foregroundColor(.lavenderPurple)
                }
                .position(self.position(for: range.upperBound, in: size))
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            self.handleDrag(drag: drag, in: size, isStartHandle: false)
                        }
                )
            }
        }
        .aspectRatio(2, contentMode: .fit)
        .padding()
    }

    private func tickMark(at index: Int, in size: CGSize, isMajor: Bool) -> some View {
        let angle = Double(index) / 60.0 * 180 + 180
        let outerRadius = size.width / 2 - sliderWidth / 2 - gapBetweenSliderAndTicks
        let innerRadius = outerRadius - (isMajor ? majorTickLength : tickLength)
        let centerX = size.width / 2
        let centerY = size.height

        let outerX = centerX + outerRadius * cos(CGFloat(angle) * .pi / 180)
        let outerY = centerY + outerRadius * sin(CGFloat(angle) * .pi / 180)
        let innerX = centerX + innerRadius * cos(CGFloat(angle) * .pi / 180)
        let innerY = centerY + innerRadius * sin(CGFloat(angle) * .pi / 180)

        return Path { path in
            path.move(to: CGPoint(x: innerX, y: innerY))
            path.addLine(to: CGPoint(x: outerX, y: outerY))
        }
        .stroke(isMajor ? .midnightCharcoal.opacity(0.3) : .midnightCharcoal.opacity(0.1), lineWidth: isMajor ? 2 : 1)
    }

    private func label(for value: Int, in size: CGSize) -> some View {
        let angle = Double(value) / 60.0 * 180 + 180
        let radius = size.width / 2 - sliderWidth / 2 - gapBetweenSliderAndTicks - majorTickLength - 10
        let centerX = size.width / 2
        let centerY = size.height

        let x = centerX + radius * cos(CGFloat(angle) * .pi / 180)
        let y = centerY + radius * sin(CGFloat(angle) * .pi / 180)

        return Text("\(value)")
            .customFont(.paceUnitNumber)
            .foregroundStyle(.midnightCharcoal)
            .position(x: x, y: y)
    }

    private func position(for value: Double, in size: CGSize) -> CGPoint {
        let angle = (value / 60 * 180) + 180
        let radius = size.width / 2
        let centerX = size.width / 2
        let centerY = size.height

        let x = centerX + radius * cos(CGFloat(angle) * .pi / 180)
        let y = centerY + radius * sin(CGFloat(angle) * .pi / 180)

        return CGPoint(x: x, y: y)
    }

    private func handleDrag(drag: DragGesture.Value, in size: CGSize, isStartHandle: Bool) {
         let centerX = size.width / 2
         let centerY = size.height
         let vector = CGVector(dx: drag.location.x - centerX,
                               dy: drag.location.y - centerY)
         var angle = atan2(vector.dy, vector.dx) * 180 / .pi

         angle = angle < 0 ? angle + 360 : angle
         
         let newValue: Double
         if angle <= 180 {
             newValue = 60  // Right side
         } else {
             newValue = (angle - 180) / 180 * 60
         }

         if isStartHandle {
             if newValue >= 59 {
                 range = 0...(range.upperBound)  // Cap at 0 when trying to go below
             } else {
                 range = min(max(0, newValue), range.upperBound - minimumGap)...range.upperBound
             }
         } else {
             if newValue <= 1 {
                 range = range.lowerBound...60  // Cap at 60 when trying to exceed
             } else {
                 range = range.lowerBound...min(max(range.lowerBound + minimumGap, newValue), 60)
             }
         }
     }
}


struct ArcRangeSlider_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var range: ClosedRange<Double> = 10...50
        
        var body: some View {
            VStack {
                ArcRangeSlider(range: $range)
//                Text("Selected range: \(Int(range.lowerBound)) - \(Int(range.upperBound))")
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .frame(width: 300)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Default ArcRangeSlider")
        
    }
}

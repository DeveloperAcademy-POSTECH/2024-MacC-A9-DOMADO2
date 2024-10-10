//
//  SpeedDistribution.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Foundation

/// 사용자가 설정한 속도구간별 각 시간을 구조화합니다. 
struct SpeedDistribution {
    var belowTarget: TimeInterval = 0
    var withinTarget: TimeInterval = 0
    var aboveTarget: TimeInterval = 0

    mutating func update(with speed: Double, targetRange: ClosedRange<Double>, deltaTime: TimeInterval) {
        if speed < targetRange.lowerBound {
            belowTarget += deltaTime
        } else if speed > targetRange.upperBound {
            aboveTarget += deltaTime
        } else {
            withinTarget += deltaTime
        }
    }
}

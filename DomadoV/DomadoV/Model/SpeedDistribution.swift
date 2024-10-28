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

extension SpeedDistribution {

    static func calculateSpeedDistribution(speedDistribution: SpeedDistribution, totalTime: TimeInterval) -> [(ratio: Double, time: TimeInterval)] {
        guard totalTime > 0 else {
            return []
        }
        
        let distribution = speedDistribution
        let totalTargetTime = distribution.belowTarget + distribution.withinTarget + distribution.aboveTarget
        
        guard totalTargetTime > 0 else {
            return []
        }
        
        let belowRatio = distribution.belowTarget / totalTargetTime
        let withinRatio = distribution.withinTarget / totalTargetTime
        let aboveRatio = distribution.aboveTarget / totalTargetTime
        
        // (주행구간 비율, 해당구간 시간 )
        return [
            (belowRatio, totalTime * belowRatio),
            (withinRatio, totalTime * withinRatio),
            (aboveRatio, totalTime * aboveRatio)
        ]
    }
}

//
//  RideSummary.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Foundation

/// 종료된 주행에 대한 요약정보를 구조화합니다. 
struct RideSummary {
    let totalDistance: Double
    let totalRideTime: TimeInterval
    let totalRestTime: TimeInterval
    var totalTime: TimeInterval {
        totalRideTime + totalRestTime
    }
    let averageSpeed: Double
    let speedDistribution: SpeedDistribution
}

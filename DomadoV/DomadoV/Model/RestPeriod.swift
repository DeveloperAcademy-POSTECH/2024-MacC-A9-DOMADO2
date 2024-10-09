//
//  RestPeriod.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Foundation

/// 휴식 정보를 구조화합니다. 
struct RestPeriod {
    let startTime: Date
    var endTime: Date?
    var duration: TimeInterval {
        return (endTime ?? Date()).timeIntervalSince(startTime)
    }
}

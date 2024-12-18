//
//  RideRecord.swift
//  DomadoV
//
//  Created by 이종선 on 10/17/24.
//

import Foundation
import CoreLocation

struct RideRecord: Identifiable, Hashable{
    let id: String
    let startTime: Date
    let endTime: Date
    let totalDistance: Double
    let totalRidingTime: Double
    let targetSpeedLower: Double
    let targetSpeedUpper: Double
    let timeInSlowZone: Double
    let timeInTargetZone: Double
    let timeInFastZone: Double
    let route: [CLLocationCoordinate2D]
    
    var averageSpeed: Double {
        guard totalRidingTime > 0 else { return 0 }
        return totalDistance / (Double(totalRidingTime) / 3600.0) // km/h
    }
    
    var totalDuration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    var totalRestTime: TimeInterval {
        return totalDuration - totalRidingTime
    }
    
    init(id: String = UUID().uuidString,
         startTime: Date,
         endTime: Date,
         totalDistance: Double,
         totalRidingTime: Double,
         targetSpeedLower: Double,
         targetSpeedUpper: Double,
         timeInSlowZone: Double,
         timeInTargetZone: Double,
         timeInFastZone: Double,
         route: [CLLocationCoordinate2D]) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.totalDistance = totalDistance
        self.totalRidingTime = totalRidingTime
        self.targetSpeedLower = targetSpeedLower
        self.targetSpeedUpper = targetSpeedUpper
        self.timeInSlowZone = timeInSlowZone
        self.timeInTargetZone = timeInTargetZone
        self.timeInFastZone = timeInFastZone
        self.route = route
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RideRecord, rhs: RideRecord) -> Bool {
        return lhs.id == rhs.id
    }
}

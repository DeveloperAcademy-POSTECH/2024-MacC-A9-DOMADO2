//
//  Ride+CoreDataProperties.swift
//  DomadoV
//
//  Created by 이종선 on 10/16/24.
//
//

import Foundation
import CoreData


extension Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ride> {
        return NSFetchRequest<Ride>(entityName: "Ride")
    }

    @NSManaged public var id: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var totalDistance: Double
    @NSManaged public var totalRidingTime: Double
    @NSManaged public var targetSpeedLower: Double
    @NSManaged public var targetSpeedUpper: Double
    @NSManaged public var timeInSlowZone: Double
    @NSManaged public var timeInTargetZone: Double
    @NSManaged public var timeInFastZone: Double
    @NSManaged public var routeData: Data?

}

extension Ride : Identifiable {

}

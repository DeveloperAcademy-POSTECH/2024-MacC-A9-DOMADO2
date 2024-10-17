//
//  RideHistoryManager.swift
//  DomadoV
//
//  Created by 이종선 on 10/17/24.
//

import Foundation
import CoreData
import CoreLocation

class RideHistoryManager {
    
    static let shared = RideHistoryManager()
    private let coreDataManager: CoreDataManager
    
    private init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    func saveRide(from session: RideSession) {
        let context = coreDataManager.mainContext
        let newRide = Ride(context: context)
        
        newRide.id = UUID().uuidString
        newRide.startTime = session.startTime
        newRide.endTime = session.endTime
        newRide.totalDistance = session.totalDistance
        newRide.totalRidingTime = session.totalRideTime
        newRide.targetSpeedLower = session.targetSpeedRange.lowerBound
        newRide.targetSpeedUpper = session.targetSpeedRange.upperBound
        
        let speedDistribution = session.generateRideSummary().speedDistribution
        newRide.timeInSlowZone = speedDistribution.belowTarget
        newRide.timeInTargetZone = speedDistribution.withinTarget
        newRide.timeInFastZone = speedDistribution.aboveTarget
        
        // Convert session locations to CLLocationCoordinate2D array
        let coordinates = session.locations.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
        newRide.route = coordinates
        
        coreDataManager.saveContext()
    }
    
    func deleteRide(id: String) {
        let context = coreDataManager.mainContext
        let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let rideToDelete = results.first {
                context.delete(rideToDelete)
                coreDataManager.saveContext()
            }
        } catch {
            print("Error deleting ride: \(error)")
        }
    }
    
    func fetchAllRides() -> [Ride] {
        let context = coreDataManager.mainContext
        let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching rides: \(error)")
            return []
        }
    }
}

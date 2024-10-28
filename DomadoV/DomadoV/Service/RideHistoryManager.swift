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
    
    func fetchAllRides() -> [RideRecord] {
        let context = coreDataManager.mainContext
        let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let rides = try context.fetch(fetchRequest)
            return rides.map { ride in
                RideRecord(
                    id: ride.id ?? UUID().uuidString,
                    startTime: ride.startTime ?? Date(),
                    endTime: ride.endTime ?? Date(),
                    totalDistance: ride.totalDistance,
                    totalRidingTime: ride.totalRidingTime,
                    targetSpeedLower: ride.targetSpeedLower,
                    targetSpeedUpper: ride.targetSpeedUpper,
                    timeInSlowZone: ride.timeInSlowZone,
                    timeInTargetZone: ride.timeInTargetZone,
                    timeInFastZone: ride.timeInFastZone,
                    route: ride.route ?? []
                )
            }
        } catch {
            print("Error fetching rides: \(error)")
            return []
        }
    }
}

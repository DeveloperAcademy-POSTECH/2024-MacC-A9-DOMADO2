//
//  Ride+CoreDataClass.swift
//  DomadoV
//
//  Created by 이종선 on 10/16/24.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Ride)
public class Ride: NSManagedObject {
    
    // route 데이터를 처리하기 위한 계산 속성
    public var route: [CLLocationCoordinate2D]? {
        get {
            guard let routeData = routeData else { return nil }
            return LocationCompressionUtility.decompressLocations(routeData)
        }
        set {
            routeData = newValue.flatMap { LocationCompressionUtility.compressLocations($0) }
        }
    }
}

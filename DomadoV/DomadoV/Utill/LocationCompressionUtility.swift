//
//  LocationCompressionUtility.swift
//  DomadoV
//
//  Created by 이종선 on 10/16/24.
//

import Foundation
import CoreLocation
import Compression

struct LocationCompressionUtility {
    static func compressLocations(_ locations: [CLLocationCoordinate2D]) -> Data? {
        guard let jsonData = try? JSONEncoder().encode(locations.map { [$0.latitude, $0.longitude] }) else {
            return nil
        }
        
        return compress(data: jsonData)
    }
    
    static func decompressLocations(_ compressedData: Data) -> [CLLocationCoordinate2D]? {
        guard let decompressedData = decompress(data: compressedData),
              let arrayOfCoordinates = try? JSONDecoder().decode([[Double]].self, from: decompressedData) else {
            return nil
        }
        
        return arrayOfCoordinates.compactMap { coord -> CLLocationCoordinate2D? in
            guard coord.count == 2 else { return nil }
            return CLLocationCoordinate2D(latitude: coord[0], longitude: coord[1])
        }
    }
    
    private static func compress(data: Data) -> Data? {
        let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        defer {
            destinationBuffer.deallocate()
        }
        
        let compressedSize = compression_encode_buffer(destinationBuffer, data.count,
                                                       (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count),
                                                       data.count, nil, COMPRESSION_ZLIB)
        
        guard compressedSize > 0 else { return nil }
        return Data(bytes: destinationBuffer, count: compressedSize)
    }
    
    private static func decompress(data: Data) -> Data? {
        let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count * 4)
        defer {
            destinationBuffer.deallocate()
        }
        
        let decompressedSize = compression_decode_buffer(destinationBuffer, data.count * 4,
                                                         (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count),
                                                         data.count, nil, COMPRESSION_ZLIB)
        
        guard decompressedSize > 0 else { return nil }
        return Data(bytes: destinationBuffer, count: decompressedSize)
    }
}

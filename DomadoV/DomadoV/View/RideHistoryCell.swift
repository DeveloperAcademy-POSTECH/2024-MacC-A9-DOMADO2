//
//  RideHistoryCell.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

struct RideHistoryCell: View {
    
    let ride: RideRecord
    
    var body: some View {
        HStack {
            workoutInfo
            Spacer()
            speedInfo
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 30)
    }
    
    // MARK: - Info
    
    private var workoutInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ride.startTime.formatAsKoreanDate(option: .dateOnly))
                .customFont(.supplementaryTimeDistanceNumber)
            Text(ride.startTime.formatAsKoreanDate(option: .dayOfWeekOnly))
                .customFont(.infoTitle)
                .foregroundColor(.midnightCharcoal)
            
            HStack(spacing: 13) {
                timeInfo
                distanceInfo
            }
        }
    }
    

    private var timeInfo: some View {
        HStack(spacing: 2) {
            Image(systemName: "clock")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
            Text("\(ride.startTime.formatAsKoreanTime(option: .hourMinute)) - \(ride.endTime.formatAsKoreanTime(option: .hourMinute))")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
        }
    }
    
    private var distanceInfo: some View {
        HStack(spacing: 2) {
            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
            Text("\(Int(ride.totalDistance)) km")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
        }
    }
    
    
    //MARK: - Speed
    
    private var speedInfo: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            Text("\(Int(ride.averageSpeed))")
                .customFont(.baseTimeDistanceNumber)
                .foregroundColor(speedColor(speed: ride.averageSpeed))
            VStack(alignment: .leading, spacing: 0) {
                Text("km/h")
                    .customFont(.listNumber)
                    .foregroundColor(.midnightCharcoal)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.midnightCharcoal)
                .opacity(0.5)
                .font(.system(size: 17))
                .padding(.leading, 20)
                .alignmentGuide(.lastTextBaseline) { d in
                    d[.bottom]
                }
        }
    }
    

    //MARK: - Speedcolor
    
    private func speedColor(speed: Double) -> Color {
        switch speed {
        case 0...20: return .electricBlue
        case 21...35: return .lavenderPurple
        default: return .sunsetOrange
        }
    }
}


struct RideHistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRide = RideRecord(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600), // 1 hour later
            totalDistance: 25.5,
            totalRidingTime: 3300, // 55 minutes
            targetSpeedLower: 15,
            targetSpeedUpper: 25,
            timeInSlowZone: 600,
            timeInTargetZone: 2400,
            timeInFastZone: 300,
            route: []
        )
        
        return VStack {
            RideHistoryCell(ride: sampleRide)
        }
        .previewLayout(.sizeThatFits)
    }
}


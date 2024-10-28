//
//  RideDetailView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI


struct RideDetailView: View {
    
    var ride: RideRecord
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 10) {
                headerView
                    .padding(.top, 10)
                mapPlaceholder
                    .padding(.top, 10)
                    .padding(.bottom, 22)
                
                AverageSpeedView(avgSpeed: ride.averageSpeed)
                    .padding(.vertical, 12)
                
                SpeedDistributionView(segments: SpeedDistribution.calculateSpeedDistribution(speedDistribution: SpeedDistribution(belowTarget: ride.timeInSlowZone, withinTarget: ride.timeInTargetZone, aboveTarget: ride.timeInSlowZone), totalTime: ride.totalRidingTime))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                InfoRow(label: String(localized: "totaldistance"), value: ride.totalDistance.formatToDecimal(1) + " km")
                    .padding(.vertical, 16)
                InfoRow(label: String(localized: "totaltime"), value: ride.totalDuration.formatTime())
                    .padding(.vertical, 19)
                timeInfoView
                
            }
            .padding(.horizontal, 30)
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("운동기록")
                    }
                    .foregroundColor(.midnightCharcoal) 
                }
            }
        }
    }
    
    
    private var customBackButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("운동기록")
                    .customFont(.pageTitle)
            }
            .foregroundColor(.midnightCharcoal)
        }
    }
    
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            Text(ride.startTime.formatAsKoreanDate(option: .dateAndDayOfWeek))
                .customFont(.listNumber)
            Spacer()
            Image(systemName: "clock")
                .customFont(.listNumber)
            Text("\(ride.startTime.formatAsLocalizedTime(option: .hourMinute)) - \(ride.endTime.formatAsLocalizedTime(option: .hourMinute))")
                .customFont(.listNumber)
        }
        .foregroundColor(.midnightCharcoal)
    }
    
    

    // MARK: - Map Placeholder
    
    private var mapPlaceholder: some View {
        
        RideRouteMapView(route: ride.route)
            .frame(maxHeight: 268)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Time Info View
    
    private var timeInfoView: some View {
        HStack(spacing: 50) {
            InfoColumn(label: String(localized: "ridetime"), value: ride.totalRidingTime.formatTime())
            InfoColumn(label: String(localized: "breaktime"), value: ride.totalRestTime.formatTime())
        }
        .padding(.vertical, -4)
    }
}

// MARK: - AverageSpeedView

struct AverageSpeedView: View {
    
    var avgSpeed: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("평균 속도")
                .customFont(.infoTitle)
            Text(avgSpeed.formatToDecimal(0) + " km/h")
                .customFont(.baseTimeDistanceNumber)
        }
    }
}

// MARK: - SpeedCategoryView

struct SpeedCategoryView: View {
    let label: String
    let time: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Text(label)
                    .customFont(.subInfoTitle)
                    .foregroundColor(.midnightCharcoal)
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
            }
            Text(time)
                .customFont(.supplementaryTimeDistanceNumber)
                .foregroundColor(.midnightCharcoal)
        }
    }
}
// MARK: - InfoRow

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .customFont(.infoTitle)
            Text(value)
                .customFont(.baseTimeDistanceNumber)
        }
        .foregroundColor(.midnightCharcoal)
    }
}

// MARK: - InfoColumn

struct InfoColumn: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .customFont(.subInfoTitle)
            Text(value)
                .customFont(.supplementaryTimeDistanceNumber)
        }
        .foregroundColor(.midnightCharcoal)
    }
}


#Preview("noPath") {
    RideDetailView(ride: RideRecord(
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600), // 1 hour later
        totalDistance: 25.5,
        totalRidingTime: 3300, // 55 minutes
        targetSpeedLower: 10,
        targetSpeedUpper: 25,
        timeInSlowZone: 600,
        timeInTargetZone: 2400,
        timeInFastZone: 300,
        route: []
    ))
    

}

#Preview("noDistribution"){
    RideDetailView(ride: RideRecord(
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600), // 1 hour later
        totalDistance: 25.5,
        totalRidingTime: 3300, // 55 minutes
        targetSpeedLower: 10,
        targetSpeedUpper: 25,
        timeInSlowZone: 0,
        timeInTargetZone: 0,
        timeInFastZone: 0,
        route: []
    ))
}

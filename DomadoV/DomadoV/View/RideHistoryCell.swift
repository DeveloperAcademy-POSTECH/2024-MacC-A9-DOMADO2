//
//  RideHistoryCell.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

struct RideHistoryCell: View {
    
    let workout: RideHistoryModel
    
    
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
            Text(workout.date)
                .customFont(.supplementaryTimeDistanceNumber)
            Text(workout.day)
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
            Text("\(workout.startTime) - \(workout.endTime)")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
        }
    }
    
    private var distanceInfo: some View {
        HStack(spacing: 2) {
            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
            Text("\(workout.distance) km")
                .customFont(.listNumber)
                .foregroundColor(.midnightCharcoal)
        }
    }
    
    
    //MARK: - Speed
    
    private var speedInfo: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            Text("\(workout.speed)")
                .customFont(.baseTimeDistanceNumber)
                .foregroundColor(speedColor(speed: workout.speed))
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
    
    private func speedColor(speed: Int) -> Color {
        switch speed {
        case 0...20: return .electricBlue
        case 21...35: return .lavenderPurple
        default: return .sunsetOrange
        }
    }
}


#Preview {
    RideHistoryCell(workout: RideHistoryModel(date: "2024. 10. 6", day: "금요일", startTime: "09:56", endTime: "14:37", distance: 452, speed: 21))
}

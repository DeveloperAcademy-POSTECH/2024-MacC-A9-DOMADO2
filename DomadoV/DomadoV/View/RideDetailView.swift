//
//  RideDetailView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI


struct RideDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                headerView
                mapPlaceholder
                AverageSpeedView()
                    .padding(.vertical, 12)
                InfoRow(label: "거리", value: "246 km")
                    .padding(.vertical, 16)
                InfoRow(label: "총 시간", value: "02:57:58")
                    .padding(.vertical, 19)
                timeInfoView
            }
            .padding(.horizontal, 30)
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            Text("2024. 10. 6 금요일")
                .customFont(.infoTitle)
            Spacer()
            Image(systemName: "clock")
                .customFont(.listNumber)
            Text("09:56 - 14:37")
                .customFont(.listNumber)
        }
        .foregroundColor(.midnightCharcoal)
    }
    
    // MARK: - Map Placeholder
    
    private var mapPlaceholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 333, height: 268)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Time Info View
    
    private var timeInfoView: some View {
        HStack(spacing: 50) {
            InfoColumn(label: "주행시간", value: "02:13:34")
            InfoColumn(label: "휴식시간", value: "00:44:26")
        }
        .padding(.vertical, -4)
    }
}

// MARK: - AverageSpeedView

struct AverageSpeedView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("평균 속도")
                .customFont(.infoTitle)
            Text("21 km/h")
                .customFont(.baseTimeDistanceNumber)
            SpeedBarView()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 7)
        }
    }
}

// MARK: - SpeedBarView

struct SpeedBarView: View {
    var body: some View {
        VStack(spacing: 10) {
            speedBar
            speedCategories
        }
    }
    
    
    //Speed Bar
    
    private var speedBar: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.electricBlue)
                .frame(width: 317 * 0.2)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.lavenderPurple)
                .frame(width: 317 * 0.6)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.sunsetOrange)
                .frame(width: 317 * 0.2)
        }
        .frame(width: 317, height: 17)
    }
    
    
    //Speed Categories
    
    private var speedCategories: some View {
        HStack(spacing: 8) {
            SpeedCategoryView(label: "느려", time: "22m", color: .electricBlue)
                .frame(width: 317 * 0.2)
            SpeedCategoryView(label: "적정", time: "1h 10m", color: .lavenderPurple)
                .frame(width: 317 * 0.6)
            SpeedCategoryView(label: "빨라", time: "32m", color: .sunsetOrange)
                .frame(width: 317 * 0.2)
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




#Preview {
    RideDetailView()
}

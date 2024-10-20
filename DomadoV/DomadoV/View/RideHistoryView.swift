//
//  RideHistoryView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI
import CoreLocation

/// 주행 기록 화면
///
/// 1. 현재까지의 주행기록을 리스트의 형태로 보여줍니다.
/// 2. 각 셀을 눌렀을 때 해당 기록에 대한 상세뷰로 이동합니다.

struct RideHistoryView: View {
    @ObservedObject var vm: RideHistoryViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                navigationBar
                Divider()
                
                if vm.records.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                vm.returnToPreparation()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.lavenderPurple)
            }
            .padding(.leading, 20)
            
            Spacer()
            
            Text("운동 기록")
                .font(.system(size: 20))
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.vertical, 10)
    }
    
    private var historyList: some View {
        List {
            ForEach(vm.records) { record in
                RideHistoryCell(ride: record)
                    .onTapGesture {
                        vm.selectedRide = record
                    }
                    .listRowInsets(EdgeInsets())
            }
            .onDelete(perform: deleteRecord)
        }
        .listStyle(PlainListStyle())
        .navigationDestination(item: $vm.selectedRide) { workout in
            RideDetailView(ride: workout)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bicycle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("아직 운동 기록이 없습니다")
                .customFont(.pageTitle)
            
            Text("새로운 운동을 시작해보세요!")
                .customFont(.subInfoTitle)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private func deleteRecord(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { vm.records[$0] }
        
        for record in recordsToDelete {
            vm.deleteRecord(record)
        }
    }
}

#Preview("Empty State") {
    
    RideHistoryView(vm: RideHistoryViewModel())
}

#Preview("Populated State") {
    RideHistoryView(vm: mockRideHistoryViewModel())
}


func mockRideHistoryViewModel() -> RideHistoryViewModel {
    let mockViewModel = RideHistoryViewModel()
    
    // 목 데이터 생성
    let calendar = Calendar.current
    let now = Date()
    
    // 경로 데이터 생성 헬퍼 함수
    func generateRoute(startLat: Double, startLon: Double, pointCount: Int) -> [CLLocationCoordinate2D] {
        var route: [CLLocationCoordinate2D] = []
        let latVariation = 0.01
        let lonVariation = 0.01
        
        for i in 0..<pointCount {
            let progress = Double(i) / Double(pointCount - 1)
            let lat = startLat + latVariation * sin(progress * .pi * 2)
            let lon = startLon + lonVariation * cos(progress * .pi * 2)
            route.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        return route
    }
    
    mockViewModel.records = [
        RideRecord(id: "1",
                   startTime: calendar.date(byAdding: .hour, value: -2, to: now)!,
                   endTime: now,
                   totalDistance: 15.5,
                   totalRidingTime: 7200,
                   targetSpeedLower: 15,
                   targetSpeedUpper: 20,
                   timeInSlowZone: 1800,
                   timeInTargetZone: 3600,
                   timeInFastZone: 1800,
                   route: generateRoute(startLat: 37.5665, startLon: 126.9780, pointCount: 100)),
        RideRecord(id: "2",
                   startTime: calendar.date(byAdding: .day, value: -1, to: now)!,
                   endTime: calendar.date(byAdding: .hour, value: -22, to: now)!,
                   totalDistance: 20.3,
                   totalRidingTime: 8100,
                   targetSpeedLower: 18,
                   targetSpeedUpper: 25,
                   timeInSlowZone: 2000,
                   timeInTargetZone: 4100,
                   timeInFastZone: 2000,
                   route: generateRoute(startLat: 37.5635, startLon: 126.9800, pointCount: 150)),
        RideRecord(id: "3",
                   startTime: calendar.date(byAdding: .day, value: -3, to: now)!,
                   endTime: calendar.date(byAdding: .day, value: -3, to: now)!,
                   totalDistance: 12.8,
                   totalRidingTime: 5400,
                   targetSpeedLower: 12,
                   targetSpeedUpper: 18,
                   timeInSlowZone: 1500,
                   timeInTargetZone: 2900,
                   timeInFastZone: 1000,
                   route: generateRoute(startLat: 37.5715, startLon: 126.9760, pointCount: 80))
    ]
    
    return mockViewModel
}

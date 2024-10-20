//
//  RideSummaryView.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import SwiftUI

/// 주행종료 화면
///
/// 1. 총시간 (주행시간 + 휴식시간)을 보여줍니다.
/// 2. 주행거리을 보여줍니다.
/// 3. 평균속도을 보여줍니다.
/// 4. 속도 구간별 시간을 보여줍니다.
/// 5. 닫기 버튼을 눌러 주행준비 화면으로 돌아갑니다.
struct RideSummaryView: View {
    @ObservedObject var vm: RideSummaryViewModel
    
    private let speedLabels = ["느려", "적정", "빨라"]
    private let speedColors: [Color] = [.blue, .green, .red]
    private let barSpacing: CGFloat = 8
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    ZStack {
                        Text("라이딩 종료")
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                vm.dismissSummary()
                            } label: {
                                Image(systemName: "multiply")
                            }
                        }
                    }
                }
                .frame(height: 42)
                .padding(.bottom, 22)
                
                if let summary = vm.rideSummary {
                    HStack {
                        Text("평균 속도")
                        Spacer()
                    }
                    .padding(.bottom, 22)
                    
                    HStack {
                        Spacer()
                        Text("\(summary.averageSpeed, specifier: "%.1f")")
                        Text("km/h")
                        
                    }
                    .padding(.bottom, 45)
                    
                    // 속도 구간별 주행 시간
                    let segments = vm.calculateSpeedDistribution()
                    
                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: barSpacing) {
                                ForEach(0..<segments.count, id: \.self) { index in
                                    VStack(spacing: 0) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(speedColors[index])
                                            .frame(width: (geometry.size.width - CGFloat(segments.count - 1) * barSpacing) * segments[index].ratio, height: 17)
                                            .padding(.bottom, 17)
                                        
                                        VStack(alignment: .leading, spacing: 0){
                                            HStack(spacing: 6) {
                                                Text("\(speedLabels[index])")
                                                    .customFont(.subInfoTitle)
                                                Circle()
                                                    .fill(speedColors[index])
                                                    .frame(width: 7, height: 7)
                                            }
                                            .padding(.bottom, 10)
                                            
                                            
                                            Text("\(vm.formatTime(segments[index].time))")
                                            //                                            Text("(\(Int(segments[index].ratio * 100))%)")
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    .frame(height: 80)
                    .padding(.vertical)
                    
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("총 시간")
                            .padding(.bottom, 10)
                        Text("\(vm.formatTime(summary.totalTime))")
                            .padding(.bottom, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0){
                                Text("총 주행시간")
                                    .padding(.bottom, 8)
                                Text("\(vm.formatTime(summary.totalRideTime)) ")
                            }
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("총 휴식 시간")
                                    .padding(.bottom, 8)
                                Text("\(vm.formatTime(summary.totalRestTime))")
                            }
                            .padding(.horizontal, 40)
                        }
                        
                    }
                    .padding(.vertical, 70)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("총 거리")
                                .padding(.bottom, 10)
                            Text("\(summary.totalDistance, specifier: "%.2f") km")
                        }
                        
                        Spacer()
                    }
                    
                } else {
                    Text("주행 요약 정보를 불러오는 중...")
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .padding([.horizontal, .bottom], 30)
        .onAppear {
            vm.getSummary()
        }
    }
}

struct RideSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RideSummaryView(vm: RideSummaryViewModel(rideSession: MockRideSession(scenario: .normal)))
                .previewDisplayName("Normal Ride")
            
            RideSummaryView(vm: RideSummaryViewModel(rideSession: MockRideSession(scenario: .mostlyBelowTarget)))
                .previewDisplayName("Mostly Below Target")
            
            RideSummaryView(vm: RideSummaryViewModel(rideSession: MockRideSession(scenario: .mostlyAboveTarget)))
                .previewDisplayName("Mostly Above Target")
        }
    }
}

// MARK: - Mock Data for Previews

enum RideScenario {
    case normal, mostlyBelowTarget, mostlyAboveTarget
}

class MockRideSession: RideSession {
    let scenario: RideScenario
    
    init(scenario: RideScenario) {
        self.scenario = scenario
    }
    
    override func generateRideSummary() -> RideSummary {
        switch scenario {
        case .normal:
            return RideSummary(
                totalDistance: 30.5,
                totalRideTime: 5400,  // 1.5 hours
                totalRestTime: 600,   // 10 minutes
                averageSpeed: 20.3,
                speedDistribution: SpeedDistribution(belowTarget: 1800, withinTarget: 2700, aboveTarget: 900)
            )
        case .mostlyBelowTarget:
            return RideSummary(
                totalDistance: 25.0,
                totalRideTime: 7200,  // 2 hours
                totalRestTime: 900,   // 15 minutes
                averageSpeed: 15.0,
                speedDistribution: SpeedDistribution(belowTarget: 5400, withinTarget: 1440, aboveTarget: 360)
            )
        case .mostlyAboveTarget:
            return RideSummary(
                totalDistance: 40.0,
                totalRideTime: 3600,  // 1 hour
                totalRestTime: 300,   // 5 minutes
                averageSpeed: 30.0,
                speedDistribution: SpeedDistribution(belowTarget: 360, withinTarget: 1080, aboveTarget: 2160)
            )
        }
    }
}

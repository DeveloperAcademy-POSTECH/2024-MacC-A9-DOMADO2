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
        
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    Text("라이딩 종료")
                        .customFont(.pageTitle)
                        .foregroundColor(.midnightCharcoal)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            vm.dismissSummary()
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.midnightCharcoal)
                                .opacity(0.3)
                        }
                    }
                }
                .frame(height: 42)
            }
            .padding([.bottom,.top], 22)
            
            VStack(spacing: 0) {
                if let summary = vm.rideSummary {
                    VStack(spacing: 0) {
                        HStack {
                            Text("평균 속도")
                                .customFont(.infoTitle)
                                .foregroundColor(.midnightCharcoal)
                            Spacer()
                        }
                        .padding(.bottom, 22)
                        
                        HStack (alignment: .bottom, spacing: 0){
                            Spacer()
                            Text("\(summary.averageSpeed, specifier: "%.f")")
                                .customFont(.mainNumber)
                                .offset(y: 37)
                                .foregroundStyle(.lavenderPurple)
                            
                            Text("km/h")
                                .customFont(.supplementaryTimeDistanceNumber)
                                .foregroundStyle(.midnightCharcoal)
                                .opacity(0.5)
                            
                        }
                        .padding(.bottom, -29)
                        .offset(y: -74)
                        
                    }
                    
                    // MARK: 속도분포
                    SpeedDistributionView(segments: vm.getSpeedDistribution())
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("총 시간")
                            .customFont(.infoTitle)
                            .foregroundStyle(.midnightCharcoal)
                            .padding(.bottom, 10)
                        
                        Text("\(summary.totalTime.formatTime())")
                            .customFont(.baseTimeDistanceNumber)
                            .foregroundStyle(.midnightCharcoal)
                            .padding(.bottom, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0){
                                Text("주행시간")
                                    .customFont(.subInfoTitle)
                                    .foregroundStyle(.midnightCharcoal)
                                    .padding(.bottom, 8)
                                Text("\(summary.totalRideTime.formatTime()) ")
                                    .customFont(.supplementaryTimeDistanceNumber)
                                    .foregroundStyle(.midnightCharcoal)
                            }
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("휴식시간")
                                    .customFont(.subInfoTitle)
                                    .foregroundStyle(.midnightCharcoal)
                                    .padding(.bottom, 8)
                                Text("\(summary.totalRestTime.formatTime())")
                                    .customFont(.supplementaryTimeDistanceNumber)
                                    .foregroundStyle(.midnightCharcoal)
                            }
                            .padding(.horizontal, 40)
                        }
                        
                    }
                    .padding(.vertical, 70)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("거리")
                                .customFont(.infoTitle)
                                .foregroundStyle(.midnightCharcoal)
                                .padding(.bottom, 10)
                            Text("\(summary.totalDistance, specifier: "%.2f") km")
                                .customFont(.baseTimeDistanceNumber)
                                .foregroundStyle(.midnightCharcoal)
                        }
                        
                        Spacer()
                    }
                    
                } else {
                    Text("주행 요약 정보를 불러오는 중...")
                }
                
            }
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

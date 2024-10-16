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
    
    private let speedLabels = ["목표 속도 미만", "목표 속도 내", "목표 속도 초과"]
    private let speedColors: [Color] = [.blue, .green, .red]
    private let barSpacing: CGFloat = 4
    
    var body: some View {
        VStack(spacing: 20) {
            Text("주행 요약")
                .font(.largeTitle)
            
            if let summary = vm.rideSummary {
                VStack(alignment: .leading, spacing: 10) {
                    Text("총 거리: \(summary.totalDistance, specifier: "%.2f") km")
                    Text("총 시간: \(vm.formatTime(summary.totalTime))")
                    
                    
                    Text("총 주행시간: \(vm.formatTime(summary.totalRideTime)) ")
                    Text("총 휴식 시간: \(vm.formatTime(summary.totalRestTime))")
                    
                    
                    Text("평균 속도: \(summary.averageSpeed, specifier: "%.1f") km/h")
                    
                }
                
                Text("속도 구간별 주행 시간")
                    .font(.headline)
                    .padding(.top)
                
                let segments = vm.calculateSpeedDistribution()
                
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: barSpacing) {
                            ForEach(0..<segments.count, id: \.self) { index in
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(speedColors[index])
                                        .frame(width: (geometry.size.width - CGFloat(segments.count - 1) * barSpacing) * segments[index].ratio, height: 30)
                                    
                                    Text(vm.formatTime(segments[index].time))
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                        HStack(spacing: 0) {
                            ForEach(0..<segments.count, id: \.self) { index in
                                Text(speedLabels[index])
                                    .font(.caption)
                                    .frame(width: (geometry.size.width - CGFloat(segments.count - 1) * barSpacing) * segments[index].ratio)
                                    .multilineTextAlignment(.center)
                                
                                if index < segments.count - 1 {
                                    Spacer().frame(width: barSpacing)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .frame(height: 80)
                .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(speedColors[index])
                                .frame(width: 10, height: 10)
                            Text("\(speedLabels[index]): \(vm.formatTime(segments[index].time)) (\(Int(segments[index].ratio * 100))%)")
                        }
                    }
                }
                .padding(.top)
            } else {
                Text("주행 요약 정보를 불러오는 중...")
            }
            
            Button("완료") {
                vm.dismissSummary()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
        }
        .padding()
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

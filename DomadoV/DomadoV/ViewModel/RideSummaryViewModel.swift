//
//  RideSummaryViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import Foundation

/// 주행종료화면에 대한 정보와 동작을 관리합니다.
class RideSummaryViewModel: ObservableObject, RideEventPublishable {
    
    @Published private(set) var rideSummary: RideSummary?
    
    let rideSession: RideSession
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    
    init(rideSession: RideSession) {
        self.rideSession = rideSession
    }
    
    /// 준비화면으로 돌아가기 
    func dismissSummary() {
        rideEventSubject.send(.didReturnToPreparation)
    }
    
    /// RideSession으로부터 주행 요약 정보 가져오기
    func getSummary() {
        rideSummary = rideSession.generateRideSummary()
     }
    
    func calculateSpeedDistribution() -> [(ratio: Double, time: TimeInterval)] {
        guard let summary = rideSummary, summary.totalTime > 0 else {
            return []
        }
        
        let distribution = summary.speedDistribution
        let totalTargetTime = distribution.belowTarget + distribution.withinTarget + distribution.aboveTarget
        
        guard totalTargetTime > 0 else {
            return []
        }
        
        let belowRatio = distribution.belowTarget / totalTargetTime
        let withinRatio = distribution.withinTarget / totalTargetTime
        let aboveRatio = distribution.aboveTarget / totalTargetTime
        
        return [
            (belowRatio, summary.totalTime * belowRatio),
            (withinRatio, summary.totalTime * withinRatio),
            (aboveRatio, summary.totalTime * aboveRatio)
        ]
    }
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
}

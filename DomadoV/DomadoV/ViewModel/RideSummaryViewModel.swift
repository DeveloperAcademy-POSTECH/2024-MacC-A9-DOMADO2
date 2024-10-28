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
    
    /// SpeedDistribution을 이용해 각 속도 구간별 비율과 시간을 계산해서 반환합니다.
    func getSpeedDistribution() -> [(ratio: Double, time: TimeInterval)] {
        
        guard let summary = self.rideSummary else { return [] }
        
        return SpeedDistribution.calculateSpeedDistribution(speedDistribution: summary.speedDistribution, totalTime: summary.totalRideTime)
    }
    
}

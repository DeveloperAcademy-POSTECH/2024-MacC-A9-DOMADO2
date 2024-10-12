//
//  RideSummaryViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine

/// 주행종료화면에 대한 정보와 동작을 관리합니다.
class RideSummaryViewModel: ObservableObject, RideEventPublishable {
    
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
}

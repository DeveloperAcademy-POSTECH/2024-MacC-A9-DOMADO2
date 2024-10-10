//
//  RideHistoryViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import Combine

class RideHistoryViewModel: ObservableObject, RideEventPublishable {
    
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    
    /// 주행준비화면으로 돌아가기
    func returnToPreparation() {
        rideEventSubject.send(.didReturnToPreparation)
    }

}

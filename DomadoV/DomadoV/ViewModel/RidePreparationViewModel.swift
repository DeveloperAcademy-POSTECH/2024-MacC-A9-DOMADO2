//
//  RidePreparationViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine

/// 주행시작화면에 대한 정보 및 동작을 관리합니다.
class RidePreparationViewModel: ObservableObject, RideEventPublishable {
    
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다. 
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    
    /// 주행을 시작합니다.
    func startRide() {
        rideEventSubject.send(.didStartRide)
    }
    
    /// 주행기록을 보여줍니다.
    func showHistory() {
        rideEventSubject.send(.didRequestHistory)
    }
}

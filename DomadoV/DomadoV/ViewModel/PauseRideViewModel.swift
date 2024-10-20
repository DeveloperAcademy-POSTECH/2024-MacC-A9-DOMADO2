//
//  PauseRideViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import Foundation

/// 주행정지 화면에 대한 정보와 동작을 관리합니다. 
class PauseRideViewModel: ObservableObject, RideEventPublishable {
    
    let currentDistance: Double
    let currentRidingTime: TimeInterval
    
    let rideSession: RideSession
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    
    init(rideSession: RideSession) {
        self.rideSession = rideSession
        self.currentDistance = rideSession.totalDistance
        self.currentRidingTime = rideSession.totalRideTime
    }
    
    func resumeRide(){
        rideEventSubject.send(.didResumeRide)
        rideSession.resume()
    }
    
    func finishRide(){
        rideEventSubject.send(.didFinishRide)
        rideSession.stop()
    }
}

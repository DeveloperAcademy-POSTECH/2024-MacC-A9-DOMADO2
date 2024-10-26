//
//  ActiveRideViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import Foundation
import SwiftUI

/// 주행화면에 대한 정보와 동작을 관리합니다. 
class ActiveRideViewModel: ObservableObject, RideEventPublishable {
    
    @Published var totalRideTime: TimeInterval = 0
    @Published var totalDistance: Double = 0
    @Published var currentSpeed: Double = 0
        
    @Published var backgroundColor: Color = .lavenderPurple
    @Published var backgroundColorDark: Color = .lavenderPurpleDark
    
    var targetSpeedRange: ClosedRange<Double> = 0...15
    
    var rideSession: RideSession
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(rideSession: RideSession) {
        self.rideSession = rideSession
        setupSubscriptions()
        
        self.targetSpeedRange = rideSession.targetSpeedRange
//        changeBackground()
    }
    
    private func setupSubscriptions() {
        // 주행 시간 구독
        rideSession.$totalRideTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTime in
                self?.totalRideTime = newTime
            }
            .store(in: &cancellables)
        
        // 주행 거리 구독
        rideSession.$totalDistance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDistance in
                self?.totalDistance = newDistance
            }
            .store(in: &cancellables)
        
        // 현재 속도 구독
        rideSession.$currentSpeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSpeed in
                self?.currentSpeed = newSpeed
                //  이곳에서 해당 메서드를 호출해야합니다. 🦖
                self?.changeBackground()
            }
            .store(in: &cancellables)
    }
    
    func pauseRide() {
        rideEventSubject.send(.didPauseRide)
        rideSession.pause()
    }
    
    func formattedTotalRideTime() -> String {
        let hours = Int(totalRideTime) / 3600
        let minutes = Int(totalRideTime) / 60 % 60
        let seconds = Int(totalRideTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formattedTotalDistance() -> String {
        return String(format: "%.2f km", totalDistance)
    }
    
    func formattedCurrentSpeed() -> String {
        return String(format: "%.f", currentSpeed)
    }
    

    func changeBackground() {
        if currentSpeed < targetSpeedRange.lowerBound {
            backgroundColor = .electricBlue
            backgroundColorDark = .electricBlueDark
        } else if currentSpeed > targetSpeedRange.upperBound {
            backgroundColor = .sunsetOrange
            backgroundColorDark = .sunsetOrangeDark
        } else {
            backgroundColor = .lavenderPurple
            backgroundColorDark = .lavenderPurpleDark
        }
    }
}

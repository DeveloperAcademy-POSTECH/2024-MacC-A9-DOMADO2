//
//  CountdonwViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/20/24.
//

import Combine
import Foundation

class CountdownViewModel: ObservableObject, RideEventPublishable {
    @Published var countdownTime: Int = 3
    var rideEventSubject = PassthroughSubject<RideEvent, Never>()
    private var timer: Timer?
    private let rideSession: RideSession
    
    init(rideSession: RideSession) {
        self.rideSession = rideSession
    }
    
    func startCountdown() {
        countdownTime = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.countdownTime > 0 {
                self.countdownTime -= 1
            } else {
                self.stopCountdown()
                self.startRide()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startRide() {
        rideSession.start()
        rideEventSubject.send(.didStartRide)
    }
    
    deinit {
        stopCountdown()
    }
}

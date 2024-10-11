//
//  AppCoordinator .swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import SwiftUI

/// View의 계층구조를 관리합니다. 
class AppCoordinator: ObservableObject{
    
    /// 현재 보여줄 화면을 결정합니다.
    @Published var currentView: AppView = .preparation
    /// 현재 구독을 관리합니다.
    private var currentSubscription: AnyCancellable?
    var rideSession: RideSession!
    
    /// 현재 view에 대한 viewModel의 publisher를 구독합니다.
    func bind(to viewModel: RideEventPublishable) {
        // 이전 구독 취소
        currentSubscription?.cancel()
        
        currentSubscription = viewModel.rideEventSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                self?.handleRideEvent(event)
            }
    }
    
    /// viewModel로부터 Event를 받아 화면을 전환합니다.
    private func handleRideEvent(_ event: RideEvent) {
        switch event {
        case .didStartRide:
            currentView = .active
        case .didPauseRide:
            currentView = .pause
        case .didResumeRide:
            currentView = .active
        case .didFinishRide:
            currentView = .summary
        case .didRequestHistory:
            currentView = .history
        case .didReturnToPreparation:
            currentView = .preparation
        }
    }
    
    
}

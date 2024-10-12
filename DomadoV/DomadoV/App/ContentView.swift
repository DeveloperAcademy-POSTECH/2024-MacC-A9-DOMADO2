//
//  ContentView.swift
//  DomadoV
//
//  Created by 이종선 on 10/7/24.
//

import SwiftUI

/// Coordinator를 활용해 현재 화면을 선택합니다. 
struct ContentView: View {
    
    @StateObject var coordinator = AppCoordinator()
    
    var body: some View {
        
        switch coordinator.currentView {
        case .preparation:
            let rideSession = RideSession()
            let vm = RidePreparationViewModel(rideSession: rideSession)
            RidePreparationView(vm: vm)
                .onAppear{
                    coordinator.rideSession = rideSession
                    coordinator.bind(to: vm)}
        case .active:
            if let rideSession = coordinator.rideSession {
                let vm = ActiveRideViewModel(rideSession: rideSession)
                ActiveRideView(vm: vm)
                    .onAppear{coordinator.bind(to: vm)}
            }
        case .pause:
            if let rideSession = coordinator.rideSession{
                let vm = PauseRideViewModel(rideSession: rideSession)
                PauseRideView(vm: vm)
                    .onAppear{coordinator.bind(to: vm)}
            }
        case .summary:
            if let rideSession = coordinator.rideSession{
                let vm = RideSummaryViewModel(rideSession: rideSession)
                RideSummaryView(vm: vm)
                    .onAppear{coordinator.bind(to: vm)}
            }
        case .history:
            let vm = RideHistoryViewModel()
            RideHistoryView(vm: vm)
                .onAppear{coordinator.bind(to: vm)}
        }
    }
}

#Preview {
    ContentView()
}

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
            let vm = RidePreparationViewModel()
            RidePreparationView(vm: vm)
                .onAppear{coordinator.bind(to: vm)}
        case .active:
            let vm = ActiveRideViewModel()
            ActiveRideView(vm: vm)
                .onAppear{coordinator.bind(to: vm)}
        case .pause:
            let vm = PauseRideViewModel()
            PauseRideView(vm: vm)
                .onAppear{coordinator.bind(to: vm)}
        case .summary:
            let vm = RideSummaryViewModel()
            RideSummaryView(vm: vm)
                .onAppear{coordinator.bind(to: vm)}
            
        }
    }
}

#Preview {
    ContentView()
}

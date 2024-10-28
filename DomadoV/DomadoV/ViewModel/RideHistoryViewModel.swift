//
//  RideHistoryViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import Combine

class RideHistoryViewModel: ObservableObject, RideEventPublishable {
    
    @Published var records: [RideRecord] = []
    @Published var selectedRide: RideRecord?

    private let rideHistoryManager: RideHistoryManager
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    
    init(rideHistoryManager: RideHistoryManager = .shared) {
        self.rideHistoryManager = rideHistoryManager
        records = rideHistoryManager.fetchAllRides()
    }
    
    /// 주행준비화면으로 돌아가기
    func returnToPreparation() {
        rideEventSubject.send(.didReturnToPreparation)
    }
    
    func deleteRecord(_ record: RideRecord) {
        rideHistoryManager.deleteRide(id: record.id)
        
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records.remove(at: index)
        }
    }
    
    
}

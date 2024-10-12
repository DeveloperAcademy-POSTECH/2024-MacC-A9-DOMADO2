//
//  RidePreparationViewModel.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import CoreLocation
import SwiftUI
import MapKit

/// 주행시작화면에 대한 정보 및 동작을 관리합니다.
class RidePreparationViewModel: ObservableObject, RideEventPublishable {
    
    /// 시스템 설정에서의 위치 권한에 대한 Alert 제어
    @Published var showLocationPermissionAlert = false
    /// 사용자 위치 권한 상태
    @Published var isLocationPermissionGranted = false
    /// 사용자 현재 위치
    @Published var mapRegion: MKCoordinateRegion?
    
    private let rideSession: RideSession
    /// AppCoordinator에게 RideEvent를 발행하여 화면을 전환합니다.
    let rideEventSubject = PassthroughSubject<RideEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(rideSession: RideSession) {
        self.rideSession = rideSession
        setupSubscriptions()
    }
    
    func prepareRide() {
        rideSession.prepare()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthorized in
                if !isAuthorized {
                    self?.showLocationPermissionAlert = true
                }
                // 권한이 허용된 경우의 추가 로직
            }
            .store(in: &cancellables)
    }

    private func setupSubscriptions() {
        rideSession.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isLocationPermissionGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
                self?.handleAuthorizationStatusChange(status)
            }
            .store(in: &cancellables)
        
        rideSession.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationData in
                if let currentLocation = locationData?.coordinate{
                    self?.updateMapRegion(with: currentLocation)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateMapRegion(with coordinate: CLLocationCoordinate2D) {
        mapRegion = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    private func handleAuthorizationStatusChange(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            showLocationPermissionAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            showLocationPermissionAlert = false
        @unknown default:
            break
        }
    }
    
    // 시스템 설정으로 이동하는 메서드
    func openSystemSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    /// 주행을 시작합니다.
    /// 지정한 속도 범위 보내기
    func startRide() {
        if !isLocationPermissionGranted {
            showLocationPermissionAlert = true
            return
        }
        rideEventSubject.send(.didStartRide)
    }
    
    /// 주행기록을 보여줍니다.
    func showHistory() {
        rideEventSubject.send(.didRequestHistory)
    }
}

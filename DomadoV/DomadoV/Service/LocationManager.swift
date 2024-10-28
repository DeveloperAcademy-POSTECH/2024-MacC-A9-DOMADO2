//
//  LocationManager.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import CoreLocation
import Combine
import Foundation

/// CoreLocation 프레임워크를 활용해서 사용자 속도, 위치 정보등을 가져옵니다.
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    /// 싱글톤을 통해 앱내의 하나의 위치 매니저만 사용합니다.
    static let shared = LocationManager()
    /// CLLocationManager를 통해 사용자의 위치 정보를 얻습니다.
    private let locationManager = CLLocationManager()
    /// LocationManager는 CLLocationMananger로부터 받아온 위치정보를 다시 발행합니다.
    let locationSubject = PassthroughSubject<CLLocation, Never>()
    // 권한 상태 변경사항을 발행합니다.
    let authorizationPublisher = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    
    
    /// private 생성자를 이용해 외부에서의 초기화를 막아 싱글톤을 유지합니다.
    /// locationManager의 delegate 지정 및 위치 정보 정확도를 설정합니다.
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 2.0
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = true
        authorizationPublisher.send(checkLocationAuthorization())
    }
    
    /// 현재 사용자 위치 정보 권한을 확인합니다.
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    /// 사용자 위치 정보 권한을 요청합니다.
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 위치정보 수집을 시작합니다.
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// 위치정보 수집을 중지합니다.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    /// 기기의 위치변경이 감지될때마다 새로운 위치를 subject를 통해 발행합니다. 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.horizontalAccuracy <= 20 else { return }
        locationSubject.send(location)
    }
    
    /// 위치 권한 변경사항이 감지될때 새로운 권한 상태를 subject를 통해 발행합니다. 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationPublisher.send(manager.authorizationStatus)
    }

}


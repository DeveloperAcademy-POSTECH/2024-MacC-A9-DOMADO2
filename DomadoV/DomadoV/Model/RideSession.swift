//
//  RideSession.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import Combine
import CoreLocation
import Foundation

/// 현재 진행중인 주행 세션을 관리합니다.
class RideSession {
    
    @Published private(set) var currentSpeed: Double = 0
    @Published private(set) var totalDistance: Double = 0
    @Published private(set) var totalRideTime: TimeInterval = 0
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var locationPermissionDenied: Bool = false
    
    private(set) var state: AppView = .preparation
    private(set) var startTime: Date?
    private(set) var endTime: Date?
    private(set) var locations: [LocationData] = []
    private(set) var restPeriods: [RestPeriod] = []
    private(set) var totalRestTime: TimeInterval = 0
    private(set) var averageSpeed: Double = 0
    
    private var currentRestPeriod: RestPeriod?
    private var targetSpeedRange: ClosedRange<Double> = 0...15
    private var speedDistribution = SpeedDistribution()
    private var previousLocation: LocationData?
    private var cancellables = Set<AnyCancellable>()
    private let processingQueue = DispatchQueue(label: "com.domadoV.rideProcessing", qos: .userInitiated)
    private var timer: Timer?
    private var filteredSpeed: Double = 0.0
    private let filterFactor: Double = 0.3
    
    init() {
        setupLocationSubscription()
        setupAuthorizationSubscription()
    }
    
    private func setupAuthorizationSubscription() {
        LocationManager.shared.authorizationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                self?.locationPermissionDenied = (status == .denied || status == .restricted)
            }
            .store(in: &cancellables)
    }
    
    private func setupLocationSubscription() {
        LocationManager.shared.locationSubject
            .receive(on: processingQueue)
            .sink { [weak self] locationData in
                self?.handleNewLocation(LocationData(location: locationData))
            }
            .store(in: &cancellables)
    }
    
    /// 주행준비
    func prepare() -> AnyPublisher<Bool, Never> {
        state = .preparation
        return Future<Bool, Never> { promise in
                    switch self.authorizationStatus {
                    case .notDetermined:
                        LocationManager.shared.requestLocationAuthorization()
                        self.waitForAuthorizationStatus()
                            .sink { status in
                                let isAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
                                self.locationPermissionDenied = !isAuthorized
                                promise(.success(isAuthorized))
                            }
                            .store(in: &self.cancellables)
                    case .restricted, .denied:
                        self.locationPermissionDenied = true
                        promise(.success(false))
                    case .authorizedWhenInUse, .authorizedAlways:
                        LocationManager.shared.startUpdatingLocation()
                        promise(.success(true))
                    @unknown default:
                        promise(.success(false))
                    }
                }.eraseToAnyPublisher()
    }
    
    private func waitForAuthorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never> {
        LocationManager.shared.authorizationPublisher
            .filter { $0 != .notDetermined }
            .first()
            .eraseToAnyPublisher()
    }
    
    /// 주행시작
    func start(settedtargetSpeedRange: ClosedRange<Double>) {
        guard state == .preparation else { return }
        targetSpeedRange = settedtargetSpeedRange
        startTime = Date()
        state = .active
        startTimer()
        LocationManager.shared.startUpdatingLocation()
    }

    /// 주행 정지
    func pause() {
        guard state == .active else { return }
        state = .pause
        currentSpeed = 0
        currentRestPeriod = RestPeriod(startTime: Date())
        LocationManager.shared.stopUpdatingLocation()
        stopTimer()
    }

    /// 주행 재개
    func resume() {
        guard state == .pause else { return }
        if var restPeriod = currentRestPeriod {
            restPeriod.endTime = Date()
            restPeriods.append(restPeriod)
            totalRestTime += restPeriod.duration
            currentRestPeriod = nil
        }
        state = .active
        LocationManager.shared.startUpdatingLocation()
        startTimer()
    }

    /// 주행 종료
    func stop() {
        guard state == .pause else { return }
        endTime = Date()
        state = .summary
        LocationManager.shared.stopUpdatingLocation()
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTotalRideTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTotalRideTime() {
        guard let startTime = startTime else { return }
        let currentTime = Date()
        totalRideTime = currentTime.timeIntervalSince(startTime) - totalRestTime
    }
    
    /// 주행중일 때 주행 정보 업데이트
    private func handleNewLocation(_ locationData: LocationData) {
        locations.append(locationData)
        
        // 거리 및 속도 계산
        var newTotalDistance = totalDistance
        var newCurrentSpeed = locationData.speed * 3.6 // m/s -> km/h (단위변환)
        
        if let previousLocation = previousLocation {
            let distance = calculateDistance(from: previousLocation, to: locationData)
            newTotalDistance += distance
            
            // locationData.speed가 유효하지 않은 경우 (-1.0), 계산된 속도 사용
            if newCurrentSpeed < 0 {
                let timeDifference = locationData.timestamp.timeIntervalSince(previousLocation.timestamp)
                if timeDifference > 0 {
                    newCurrentSpeed = (distance / timeDifference) * 3600 // km/s -> km/h 변환
                } else {
                    newCurrentSpeed = 0
                }
            }
            
            // 저역 통과 필터 적용
            filteredSpeed = (filterFactor * newCurrentSpeed) + ((1 - filterFactor) * filteredSpeed)
            
            // 속도 분포 업데이트 (필터링된 속도 사용)
            let deltaTime = locationData.timestamp.timeIntervalSince(previousLocation.timestamp)
            speedDistribution.update(with: filteredSpeed, targetRange: targetSpeedRange, deltaTime: deltaTime)
        } else {
            // 첫 위치 데이터의 경우, 필터링된 속도를 현재 속도로 초기화
            filteredSpeed = newCurrentSpeed
        }
        
        // 메인 스레드에서 UI 업데이트
        DispatchQueue.main.async {
            self.totalDistance = newTotalDistance
            self.currentSpeed = max(newCurrentSpeed, 0)
        }
        
        // 현재 위치를 이전 위치로 저장
        previousLocation = locationData
        
    }

    private func calculateDistance(from: LocationData, to: LocationData) -> Double {
        let fromLocation = CLLocation(latitude: from.coordinate.latitude, longitude: from.coordinate.longitude)
        let toLocation = CLLocation(latitude: to.coordinate.latitude, longitude: to.coordinate.longitude)
        return toLocation.distance(from: fromLocation) / 1000 // km로 변환
    }

    /// 주행종료후 주행 요약 생성
    func generateRideSummary(){
      
    }
}

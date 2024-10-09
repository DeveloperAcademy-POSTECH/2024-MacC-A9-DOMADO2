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
    
    private(set) var startTime: Date?
    private(set) var endTime: Date?
    private(set) var locations: [LocationData] = []
    private(set) var restPeriods: [RestPeriod] = []
    private(set) var totalRestTime: TimeInterval = 0
    private(set) var averageSpeed: Double = 0
    
    private var currentRestPeriod: RestPeriod?
    private var targetSpeedRange: ClosedRange<Double>
    private var speedDistribution = SpeedDistribution()
    private var previousLocation: LocationData?
    private var cancellables = Set<AnyCancellable>()
    
    init(targetSpeedRange: ClosedRange<Double>) {
        self.targetSpeedRange = targetSpeedRange
    }
    
    /// 주행시작
    func start() {
        startTime = Date()
        // TODO: LocationManager 위치정보 업데이트 시작
        // TODO: 업데이트되는 위치정보 구독하기
    }

    /// 주행 정지
    func pause() {
        currentRestPeriod = RestPeriod(startTime: Date())
        // TODO: LocationManagaer 위치정보 업데이트 중지

    }

    /// 주행 재개
    func resume() {
        if var restPeriod = currentRestPeriod {
            restPeriod.endTime = Date()
            restPeriods.append(restPeriod)
            totalRestTime += restPeriod.duration
            currentRestPeriod = nil
        }
        // TODO: LocationManager 위치정보 업데이트 시작
    }

    /// 주행 종료
    func stop() {
        endTime = Date()
        // TODO: LocationManagaer 위치정보 업데이트 중지
        cancellables.removeAll()
    }

    /// 구독한  LocationData를 사용해 RideSession의 각 프로퍼티 값 업데이트
    private func handleNewLocation(_ locationData: LocationData) {

    }

    private func calculateDistance(from: LocationData, to: LocationData) -> Double {
        let fromLocation = CLLocation(latitude: from.coordinate.latitude, longitude: from.coordinate.longitude)
        let toLocation = CLLocation(latitude: to.coordinate.latitude, longitude: from.coordinate.longitude)
        return toLocation.distance(from: fromLocation) / 1000 // km로 변환
    }

    /// 주행종료후 주행 요약 생성
    func generateRideSummary(){
      
    }
}

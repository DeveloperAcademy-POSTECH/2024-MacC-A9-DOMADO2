//
//  RideEvent.swift
//  DomadoV
//
//  Created by 이종선 on 10/9/24.
//

/// 각 View에 대응하는 ViewModel 동작에 대한 event를 정의합니다.
///
/// AppCoordinator는 다음 event들을 구독하여 뷰를 교체합니다.
enum RideEvent {
    /// 준비화면 -> 주행화면
    case didStartRide
    /// 주행화면 -> 정지화면
    case didPauseRide
    /// 정지화면 -> 주행화면
    case didResumeRide
    /// 정지화면 -> 주행완료
    case didFinishRide
    /// 준비화면 -> 기록화면
    case didRequestHistory
    /// 기록화면 -> 준비화면
    case didReturnToPreparation
}

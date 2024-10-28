//
//  RideEventPublishable.swift
//  DomadoV
//
//  Created by 이종선 on 10/9/24.
//

import Combine

/// 각 ViewModel이 화면전환을 위한 RideEvent를 발행하여
/// AppCoordinator를 통해 화면 전환을 할 수 있도록 프로토콜을 정의합니다.
protocol RideEventPublishable {
    var rideEventSubject: PassthroughSubject<RideEvent, Never> { get }
}

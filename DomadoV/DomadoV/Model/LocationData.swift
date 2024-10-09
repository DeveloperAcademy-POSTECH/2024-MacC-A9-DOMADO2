//
//  LocationData.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import CoreLocation

/// 특정 시점의 위치 데이터 스냅샷을 나타냅니다.
///
/// 이 구조체는 지리적 좌표, 고도, 속도, 이동 방향 등
/// 위치의 다양한 측면을 포함합니다.
struct LocationData {
    /// 이 위치 데이터가 기록된 날짜와 시간입니다.
    let timestamp: Date

    /// 위치의 지리적 좌표(위도와 경도)입니다.
    let coordinate: CLLocationCoordinate2D

    /// 위치의 고도(미터 단위)입니다.
    ///
    /// 양수 값은 해수면 위의 높이를, 음수 값은 해수면 아래의 깊이를 나타냅니다.
    let altitude: Double

    /// 이 위치에서의 기기의 순간 속도(초당 미터)입니다.
    ///
    /// 이 값은 항상 0 이상입니다.
    /// 속도를 알 수 없는 경우, speed 값은 -1.0입니다.
    let speed: Double

    /// 이동 방향(도 단위)으로, 0°는 진북을 가리킵니다.
    ///
    /// 이 값의 범위는 0에서 360도이며:
    /// - 0°는 진북을 나타냅니다
    /// - 90°는 동쪽을 나타냅니다
    /// - 180°는 남쪽을 나타냅니다
    /// - 270°는 서쪽을 나타냅니다
    let course: Double

    /// CLLocation 객체로부터 새로운 LocationData 인스턴스를 초기화합니다.
    ///
    /// - 매개변수 location: 원시 위치 데이터를 포함하는 CLLocation 객체입니다.
    init(location: CLLocation) {
        self.timestamp = location.timestamp
        self.coordinate = location.coordinate
        self.altitude = location.altitude
        self.speed = location.speed
        self.course = location.course
    }
}

//
//  AppView.swift
//  DomadoV
//
//  Created by 이종선 on 10/9/24.
//

/// AppCoordinator 가 관리하는 화면 종류를 나타냅니다.
enum AppView {
    /// 주행 시작
    case preparation
    /// 주행 중
    case active
    /// 주행 정지
    case pause
    /// 주행 종료
    case summary
}

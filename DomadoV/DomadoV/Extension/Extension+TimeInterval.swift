//
//  extension+TimeInterval.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import Foundation

/// 초단위 시간을 받아 시간 : 분 : 초 형태로 변환합니다. 
extension TimeInterval {
    func formatTime() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let remainingSeconds = totalSeconds % 60
        
        let hoursString = String(format: "%02d", hours)
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", remainingSeconds)
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    func formatTimeInMinutes() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        
        if hours > 0 {
            return String(format: "%dh %02dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
}

//
//  Extension+Date.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import Foundation

enum DateFormatOption {
    case dateOnly
    case dayOfWeekOnly
    case dateAndDayOfWeek
}

enum TimeFormatOption {
    case hourMinute
    case hourMinuteSecond
}

extension Date {
    func formatAsKoreanDate(option: DateFormatOption = .dateAndDayOfWeek) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        switch option {
        case .dateOnly:
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        case .dayOfWeekOnly:
            dateFormatter.dateFormat = "EEEE"
        case .dateAndDayOfWeek:
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        }
        
        return dateFormatter.string(from: self)
    }
    
    func formatAsKoreanTime(option: TimeFormatOption = .hourMinute) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        switch option {
        case .hourMinute:
            dateFormatter.dateFormat = "HH시 mm분"
        case .hourMinuteSecond:
            dateFormatter.dateFormat = "HH시 mm분 ss초"
        }
        
        return dateFormatter.string(from: self)
    }
}

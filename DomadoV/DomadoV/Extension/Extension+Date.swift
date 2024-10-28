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
        dateFormatter.locale = Locale.current
//        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        switch option {
        case .dateOnly:
            dateFormatter.dateFormat = dateFormatter.locale.identifier == "ko_KR" ? "yyyy년 MM월 dd일" : "yyyy-MM-dd"
//            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        case .dayOfWeekOnly:
            dateFormatter.dateFormat = "EEEE"
        case .dateAndDayOfWeek:
            dateFormatter.dateFormat = dateFormatter.locale.identifier == "ko_KR" ? "yyyy년 MM월 dd일 EEEE" : "yyyy-MM-dd EEEE"
//            dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        }
        
        return dateFormatter.string(from: self)
    }
    
    func formatAsLocalizedTime(option: TimeFormatOption = .hourMinute) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current // 시스템의 현재 locale을 사용
            
            switch option {
            case .hourMinute:
                dateFormatter.dateFormat = dateFormatter.locale.identifier == "ko_KR" ? "HH시 mm분" : "hh:mm a"
            case .hourMinuteSecond:
                dateFormatter.dateFormat = dateFormatter.locale.identifier == "ko_KR" ? "HH시 mm분 ss초" : "hh:mm:ss a"
            }
            
            return dateFormatter.string(from: self)
        }
//    func formatAsKoreanTime(option: TimeFormatOption = .hourMinute) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        
//        switch option {
//        case .hourMinute:
//            dateFormatter.dateFormat = "HH시 mm분"
//        case .hourMinuteSecond:
//            dateFormatter.dateFormat = "HH시 mm분 ss초"
//        }
//        
//        return dateFormatter.string(from: self)
//    }
}

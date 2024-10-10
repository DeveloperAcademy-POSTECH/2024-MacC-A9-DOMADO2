//
//  CustomFont.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

struct CustomFont: ViewModifier {
    
    var textStyle: TextStyle
    
    var name: String {
        switch textStyle {
        case .mainNumber:
            return "RobotoCondensed-Black"
        case .paceSettingNumber:
            return "RobotoCondensed-Bold"
        case .baseTimeDistanceNumber:
            return "RobotoCondensed-SemiBold"
        case .supplementaryTimeDistanceNumber:
            return "RobotoCondensed-Regular"
        case .listNumber:
            return "RobotoCondensed-Regular"
        case .paceUnitNumber:
            return "RobotoCondensed-Regular"
        case .pageTitle:
            return "Pretendard-Regular"
        case .infoTitle:
            return "Pretendard-Regular"
        case .subInfoTitle:
            return "Pretendard-ExtraLight"
        }
    }
    
    var size: CGFloat {
        switch textStyle {
        case .mainNumber:
            return 180
        case .paceSettingNumber:
            return 62
        case .baseTimeDistanceNumber:
            return 32
        case .supplementaryTimeDistanceNumber:
            return 24
        case .listNumber:
            return 12
        case .paceUnitNumber:
            return 13
        case .pageTitle:
            return 20
        case .infoTitle:
            return 17
        case .subInfoTitle:
            return 15
        }
    }
    
    var opacity: Double {
        switch textStyle {
        case .mainNumber:
            return 1.0
        case .paceSettingNumber:
            return 1.0
        case .baseTimeDistanceNumber:
            return 0.87
        case .supplementaryTimeDistanceNumber:
            return 0.87
        case .listNumber:
            return 0.5
        case .paceUnitNumber:
            return 0.5
        case .pageTitle:
            return 0.87
        case .infoTitle:
            return 0.5
        case .subInfoTitle:
            return 0.5
        }
    }
    
    func body(content: Content) -> some View {
        content.font(.custom(name, size: size)).opacity(opacity)
    }
}

extension View {
    func customFont(_ textStyle: TextStyle) -> some View {
        modifier(CustomFont(textStyle: textStyle))
    }
}

enum TextStyle {
    case mainNumber
    case paceSettingNumber
    case baseTimeDistanceNumber
    case supplementaryTimeDistanceNumber
    case listNumber
    case paceUnitNumber
    case pageTitle
    case infoTitle
    case subInfoTitle
}

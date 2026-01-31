//
//  HapticManager.swift
//  DomadoV
//
//  Created by Codex.
//

import UIKit

final class HapticManager {
    static let shared = HapticManager()

    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)

    private init() {}

    func prepare() {
        selectionGenerator.prepare()
        notificationGenerator.prepare()
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }

    func selectionChanged() {
        selectionGenerator.selectionChanged()
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            lightImpact.impactOccurred()
        case .medium:
            mediumImpact.impactOccurred()
        case .heavy:
            heavyImpact.impactOccurred()
        default:
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
    }

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(type)
    }
}

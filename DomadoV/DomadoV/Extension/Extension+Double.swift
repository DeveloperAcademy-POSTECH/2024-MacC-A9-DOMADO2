//
//  Extension+Double.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//
import Foundation

extension Double {
    func formatToDecimal(_ fractionDigits: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

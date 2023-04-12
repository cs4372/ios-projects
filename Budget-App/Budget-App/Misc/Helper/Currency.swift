//
//  Currency.swift
//  Budget-App
//
//  Created by Catherine Shing on 4/11/23.
//

import Foundation

class Currency {
    static func formatCurrency(amount: Decimal) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: amount))
    }
}

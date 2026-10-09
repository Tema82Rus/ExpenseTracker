//
//  Formatters.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 05.10.2026.
//

import Foundation

extension NumberFormatter {
    // Форматер для красивого вывода валюты (например: 12 500 ₽)
    static let expenseCurrency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "RUB"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.maximumFractionDigits = 2 // Допускаем копейки, если они есть
        return formatter
    }()
}

extension DateFormatter {
    // Форматер для секций таблицы (например: "11 сентября 2026 г.")
    static let expenseSectionDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}


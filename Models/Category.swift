//
//  Category.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 11.09.2026.
//

import Foundation

/// Категории расходов приложения.
/// Протокол CaseIterable позволяет получить массив всех категорий через Category.allCases.
enum Category: String, CaseIterable {
    case food = "🍔 Еда"
    case transport = "🚕 Транспорт"
    case leisure = "🎬 Отдых"
}


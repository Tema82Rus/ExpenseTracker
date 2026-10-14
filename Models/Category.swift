//
//  Category.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 11.09.2026.
//

import UIKit

/// Категории расходов приложения.
/// Протокол CaseIterable позволяет получить массив всех категорий через Category.allCases.
enum Category: String, CaseIterable {
    case food = "Еда"
    case transport = "Транспорт"
    case leisure = "Отдых"
    case other = "Другое"
    
    // Вычисляемое свойство, которое возвращает иконку для каждой категории
    var icon: String {
        switch self {
        case .food: return "🍔"
        case .transport: return "🚕"
        case .leisure: return "🎬"
        case .other: return "🎲"
        }
    }
    
    var color: UIColor {
        switch self {
        case .food: return .systemOrange      // Оранжевый для еды
        case .transport: return .systemCyan    // Голубой для транспорта
        case .leisure: return .systemPurple    // Фиолетовый для отдыха
        case .other: return .systemGray        // Серый для остальных трат
        }
    }
}



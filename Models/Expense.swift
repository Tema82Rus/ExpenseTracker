//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 11.09.2026.
//

import Foundation

/// Чистая модель расхода для использования в логике приложения и интерфейсе.
struct Expense {
    /// Уникальный идентификатор для точного поиска и удаления записи
    let id: UUID
    
    /// Сумма траты
    let amount: Double
    
    /// Строгая категория из нашего перечисления
    let category: Category
    
    /// Дата совершения покупки
    let date: Date
    
    /// Необязательный комментарий или заметка к трате
    let comment: String?
}

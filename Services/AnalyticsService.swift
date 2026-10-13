//
//  AnalyticsService.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 13.10.2026.
//

import Foundation

// Структура для передачи готовых расчетов в UI-слой
struct CategoryAnalytics {
    let category: Category
    let totalAmount: Double
    let percentage: Double // Значение от 0.0 до 1.0 для графиков
}

final class AnalyticsService {
    
    // Паттерн Singleton для удобного доступа
    static let shared = AnalyticsService()
    
    private init() {}
    
    /// Метод группирует массив расходов по категориям и рассчитывает их процентное соотношение.
    /// - Parameter expenses: Массив чистых моделей Expense из базы данных.
    /// - Returns: Массив просчитанных моделей для отображения на графиках.
    func calculateAnalytics(from expenses: [Expense]) -> [CategoryAnalytics] {
        
        // 1. Считаем общую сумму всех трат приложения через функцию высшего порядка 'reduce'
        let totalExpensesAmount = expenses.reduce(0.0) { $0 + $1.amount }
        
        // 🛡️ ЗАЩИТА ОТ ДЕЛЕНИЯ НА НОЛЬ: Если трат нет, сразу возвращаем пустой массив
        guard totalExpensesAmount > 0 else { return [] }
        
        // 2. Проходимся по всем доступным категориям из нашего строгого Enum
        let analytics: [CategoryAnalytics] = Category.allCases.compactMap { category in
            
            // Фильтруем расходы, оставляя только текущую категорию
            let categoryExpenses = expenses.filter { $0.category == category }
            
            // Считаем сумму трат конкретно по этой категории
            let categoryTotal = categoryExpenses.reduce(0.0) { $0 + $1.amount }
            
            // Если трат по категории нет, мы не выводим её на экран графиков
            guard categoryTotal > 0 else { return nil }
            
            // Рассчитываем долю категории в общих расходах (значение от 0.0 до 1.0)
            let percentage = categoryTotal / totalExpensesAmount
            
            return CategoryAnalytics(
                category: category,
                totalAmount: categoryTotal,
                percentage: percentage
            )
        }
        
        // Сортируем категории так, чтобы самые затратные всегда были вверху списка
        return analytics.sorted { $0.totalAmount > $1.totalAmount }
    }
}


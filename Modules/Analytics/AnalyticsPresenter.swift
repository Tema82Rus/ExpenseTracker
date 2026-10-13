//
//  AnalyticsPresenter.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 13.10.2026.
//

import Foundation

// Протокол для управления отображением экрана аналитики
protocol AnalyticsViewProtocol: AnyObject {
    func showAnalytics(totalAmount: Double, data: [CategoryAnalytics])
    func showEmptyState()
}

// Протокол для обработки жизненного цикла экрана аналитики
protocol AnalyticsPresenterProtocol: AnyObject {
    func viewWillAppear()
}

final class AnalyticsPresenter: AnalyticsPresenterProtocol {
    
    // 🛡️ Защита от утечек памяти: ссылка на View обязательно weak
    private weak var view: AnalyticsViewProtocol?
    
    init(view: AnalyticsViewProtocol) {
        self.view = view
    }
    
    func viewWillAppear() {
        loadAnalyticsData()
    }
    
    private func loadAnalyticsData() {
        // 1. Считываем все расходы из базы данных Core Data
        let expenses = StorageManager.shared.fetchExpenses()
        
        // 2. Если расходов вообще нет — отдаем команду показать Empty State заглушку
        guard !expenses.isEmpty else {
            view?.showEmptyState()
            return
        }
        
        // 3. Считаем общую сумму всех трат
        let totalSum = expenses.reduce(0.0) { $0 + $1.amount }
        
        // 4. Пропускаем массив расходов через наш математический сервис из Дня 16
        let analyticsData = AnalyticsService.shared.calculateAnalytics(from: expenses)
        
        // 5. Передаем готовые расчеты во View для отрисовки интерфейса
        view?.showAnalytics(totalAmount: totalSum, data: analyticsData)
    }
}


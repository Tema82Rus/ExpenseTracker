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
    
    private weak var view: AnalyticsViewProtocol?
    
    init(view: AnalyticsViewProtocol) {
        self.view = view
        // 🌟 Подписываемся на уведомление об изменении базы данных Core Data
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdate), name: .didUpdateCoreData, object: nil)
    }
    
    // Обязательно отписываемся от уведомлений при уничтожении презентера, чтобы не было утечек памяти
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillAppear() {
        loadAnalyticsData()
    }
    
    @objc private func handleDataUpdate() {
        // Когда прилетает уведомление, заново пересчитываем математику аналитики
        loadAnalyticsData()
    }
    
    private func loadAnalyticsData() {
        let expenses = StorageManager.shared.fetchExpenses()
        
        guard !expenses.isEmpty else {
            view?.showEmptyState()
            return
        }
        
        let totalSum = expenses.reduce(0.0) { $0 + $1.amount }
        let analyticsData = AnalyticsService.shared.calculateAnalytics(from: expenses)
        
        view?.showAnalytics(totalAmount: totalSum, data: analyticsData)
    }
}

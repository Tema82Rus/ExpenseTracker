//
//  AddExpensePresenter.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 06.10.2026.
//

import Foundation

// Протокол для управления отображением экрана добавления трат
protocol AddExpenseViewProtocol: AnyObject {
    func showError(_ message: String)
}

// Протокол для обработки действий пользователя на экране добавления
protocol AddExpensePresenterProtocol: AnyObject {
    func saveExpense(amount: Double, category: Category, date: Date, note: String?)
    func cancelButtonTapped()
}

final class AddExpensePresenter: AddExpensePresenterProtocol {
    
    // 🛡️ Защита от утечек памяти: ссылка на View обязательно weak
    private weak var view: AddExpenseViewProtocol?
    
    // 🛡️ Нюанс Дня 13: Слабая ссылка на делегат (главный экран) для защиты от Retain Cycle
    private weak var delegate: AddExpenseDelegate?
    
    // Передаем вью и делегат через инициализатор
    init(view: AddExpenseViewProtocol, delegate: AddExpenseDelegate?) {
        self.view = view
        self.delegate = delegate
    }
    
    // Изменение Дня 13: Логика валидации, сохранения в Core Data и оповещения главного экрана
    func saveExpense(amount: Double, category: Category, date: Date, note: String?) {
        // 1. Валидация данных: сумма должна быть строго больше нуля
        guard amount > 0 else {
            view?.showError("Сумма расхода должна быть больше 0")
            return
        }
        
        // 2. Создаем чистую структуру расхода
        let newExpense = Expense(
            id: UUID(),
            amount: amount,
            category: category,
            date: date,
            note: note
        )
        
        // 3. Сохраняем в Core Data через синглтон из Спринта 1
        StorageManager.shared.saveExpense(newExpense)
        
        // 4. Оповещаем главный экран через делегат, что данные обновились
        delegate?.didSaveNewExpense()
    }
    
    func cancelButtonTapped() {
        // Логика закрытия контроллера вызывается прямо из ViewController через dismiss
    }
}

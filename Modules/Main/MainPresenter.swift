//
//  MainPresenter.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 05.10.2026.
//

import Foundation

/// Протокол, который описывает, что должен уметь делать Экран (View) по команде от Презентера
protocol MainViewProtocol: AnyObject {
    func reloadData()
}

/// Протокол, который описывает логику Презентера
protocol MainPresenterProtocol: AnyObject {
    var numberOfExpenses: Int { get }
    func viewDidLoad()
    func getExpense(at index: Int) -> Expense
}

final class MainPresenter: MainPresenterProtocol {
    
    // 🛡️ Нюанс: Слабая ссылка на View для защиты от утечек памяти (Retain Cycles)
    private weak var view: MainViewProtocol?
    
    // Источник данных для экрана — массив чистых моделей
    private var expenses: [Expense] = []
    
    var numberOfExpenses: Int {
        return expenses.count
    }
    
    // Внедряем зависимость через инициализатор
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadExpenses()
    }
    
    func getExpense(at index: Int) -> Expense {
        return expenses[index]
    }
    
    private func loadExpenses() {
        // Загружаем данные из нашего StorageManager, созданного в Спринте 1
        self.expenses = StorageManager.shared.fetchExpenses()
        // Говорим экрану обновиться
        self.view?.reloadData()
    }
}

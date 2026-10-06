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
    func viewDidLoad()
    func cancelButtonTapped()
}

final class AddExpensePresenter: AddExpensePresenterProtocol {
    
    // 🛡️ Защита от утечек памяти: ссылка на View обязательно weak
    private weak var view: AddExpenseViewProtocol?
    
    init(view: AddExpenseViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        // Логика при загрузке экрана (если понадобится в будущем)
    }
    
    func cancelButtonTapped() {
        // Здесь позже будет логика закрытия экрана, пока оставляем пустой
    }
}

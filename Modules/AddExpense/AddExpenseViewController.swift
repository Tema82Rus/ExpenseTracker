//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 06.10.2026.
//

import UIKit

final class AddExpenseViewController: UIViewController {
    
    var presenter: AddExpensePresenterProtocol?
    
    // 1. Создаем UI-элементы кодом
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите сумму:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0 ₽"
        textField.font = .systemFont(ofSize: 36, weight: .bold)
        textField.textAlignment = .left
        // 🛡️ Нюанс: Выставляем цифровую клавиатуру с разделителем для удобства ввода финансов
        textField.keyboardType = .decimalPad
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Линия-разделитель под текстовым полем для красоты
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // 2. Настройка UI и привязка к Safe Area
    private func setupUI() {
        title = "Новый расход"
        view.backgroundColor = .systemBackground
        
        // Добавляем элементы на экран
        view.addSubview(titleLabel)
        view.addSubview(amountTextField)
        view.addSubview(dividerView)
        
        // Активируем Auto Layout констрейнты
        NSLayoutConstraint.activate([
            // 🛡️ Привязываем заголовок к safeAreaLayoutGuide, защищая от перекрытия "челкой"
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Поле ввода суммы под заголовком
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Линия подчеркивания под полем ввода
            dividerView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 4),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - AddExpenseViewProtocol
extension AddExpenseViewController: AddExpenseViewProtocol {
    func showError(_ message: String) {
        // Сюда мы позже добавим вывод UIAlertController при ошибках валидации
    }
}

#if DEBUG
import SwiftUI

#Preview {
    // Создаем цепочку MVP прямо внутри превью
    let addExpenseVC = AddExpenseViewController()
    let presenter = AddExpensePresenter(view: addExpenseVC)
    addExpenseVC.presenter = presenter
    
    // Заворачиваем в NavigationController, чтобы видеть верхний бар
    return UINavigationController(rootViewController: addExpenseVC)
}
#endif



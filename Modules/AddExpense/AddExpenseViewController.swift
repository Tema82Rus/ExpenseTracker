//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 06.10.2026.
//

import UIKit

final class AddExpenseViewController: UIViewController {
    
    var presenter: AddExpensePresenterProtocol?
    
    // Выбранная категория (по умолчанию первая)
    private var selectedCategory: Category = Category.allCases.first ?? .food
    
    // Массив кнопок для управления их состоянием (подсветкой)
    private var categoryButtons: [UIButton] = []
    
    // --- UI ЭЛЕМЕНТЫ ДНЯ 11 ---
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите сумму:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0 ₽"
        textField.font = .systemFont(ofSize: 36, weight: .bold)
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // --- НОВЫЕ UI ЭЛЕМЕНТЫ ДНЯ 12 ---
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Горизонтальный стек для кнопок категорий
    private lazy var categoriesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // 🌟 Динамически генерируем кнопки на основе Category.allCases
        Category.allCases.forEach { category in
            let button = UIButton(type: .system)
            // Выводим иконку и чистый текст (зависит от твоей реализации enum)
            let title = "\(category.icon) \(category.rawValue)"
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.tintColor = .label
            
            // Настраиваем тег или таргет для определения нажатой кнопки
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            stack.addArrangedSubview(button)
            categoryButtons.append(button)
        }
        return stack
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Компактный нативный календарь
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Комментарий (необязательно)"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("СОХРАНИТЬ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCategoryButtonsUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountTextField.becomeFirstResponder()
    }
    
    // 2. Полная верстка экрана Auto Layout констрейнтами
    private func setupUI() {
        title = "Новый расход"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        view.addSubview(titleLabel)
        view.addSubview(amountTextField)
        view.addSubview(dividerView)
        view.addSubview(categoryTitleLabel)
        view.addSubview(categoriesStackView)
        view.addSubview(dateTitleLabel)
        view.addSubview(datePicker)
        view.addSubview(noteTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dividerView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 4),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            categoryTitleLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 24),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            categoriesStackView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 10),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesStackView.heightAnchor.constraint(equalToConstant: 40),
            
            dateTitleLabel.topAnchor.constraint(equalTo: categoriesStackView.bottomAnchor, constant: 24),
            dateTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTitleLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            noteTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 24),
            noteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Действия (Actions)
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        // Определяем, на какую категорию нажал пользователь
        guard let buttonIndex = categoryButtons.firstIndex(of: sender) else { return }
        selectedCategory = Category.allCases[buttonIndex]
        updateCategoryButtonsUI()
    }
    
    @objc private func cancelButtonTapped() {
        // Закрываем модальный экран
        dismiss(animated: true, completion: nil)
    }
    
    // Визуальное обновление кнопок: выбранная подсвечивается, остальные тусклые
    private func updateCategoryButtonsUI() {
        for (index, button) in categoryButtons.enumerated() {
            let isSelected = (Category.allCases[index] == selectedCategory)
            if isSelected {
                button.backgroundColor = .label
                button.setTitleColor(.systemBackground, for: .normal)
                button.layer.borderColor = UIColor.label.cgColor
            } else {
                button.backgroundColor = .systemBackground
                button.setTitleColor(.label, for: .normal)
                button.layer.borderColor = UIColor.separator.cgColor
            }
        }
    }
    
    @objc private func saveButtonTapped() {
        // Считываем текст суммы
        guard let text = amountTextField.text, !text.isEmpty else { return }
        
        // 🛡️ Безопасная конвертация текста в Double через наш NumberFormatter.
        // Метод .number(from:) автоматически поймет и точку, и запятую в зависимости от региона юзера.
        guard let number = NumberFormatter.expenseCurrency.number(from: text) else {
            // Если напрямую валютный форматер не распарсил (потому что нет знака ₽ при вводе),
            // используем обычную замену запятой на точку на всякий случай.
            let cleanText = text.replacingOccurrences(of: ",", with: ".")
            guard let doubleValue = Double(cleanText) else { return }
            proceedWithSave(amount: doubleValue)
            return
        }
        
        proceedWithSave(amount: number.doubleValue)
    }
    
    private func proceedWithSave(amount: Double) {
        let note = noteTextField.text
        let date = datePicker.date
        
        // Передаем данные в презентер
        presenter?.saveExpense(amount: amount, category: selectedCategory, date: date, note: note)
        
        // Закрываем экран после успешного сохранения
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AddExpenseViewProtocol
extension AddExpenseViewController: AddExpenseViewProtocol {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - SwiftUI Preview
#if DEBUG
import SwiftUI

#Preview {
    // Создаем цепочку MVP прямо внутри превью
    let addExpenseVC = AddExpenseViewController()
    let presenter = AddExpensePresenter(view: addExpenseVC, delegate: nil)
    addExpenseVC.presenter = presenter
    
    // Заворачиваем в NavigationController, чтобы видеть верхний бар
    return UINavigationController(rootViewController: addExpenseVC)
}
#endif


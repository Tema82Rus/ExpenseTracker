//
//  ExpenseTableViewCell.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 05.10.2026.
//

import UIKit

final class ExpenseTableViewCell: UITableViewCell {
    
    // 1. Создаем UI-элементы кодом
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Вертикальный стек для текстов (категория + комментарий)
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 2. Инициализаторы ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 3. Добавление субвью на contentView
    private func setupViews() {
        contentView.addSubview(iconLabel)
        contentView.addSubview(textStackView)
        contentView.addSubview(amountLabel)
        
        textStackView.addArrangedSubview(categoryLabel)
        textStackView.addArrangedSubview(noteLabel)
    }
    
    // 4. Привязка Auto Layout констрейнтов к contentView
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Иконка эмодзи слева
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 32),
            
            // Вертикальный стек в центре
            textStackView.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textStackView.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -12),
            
            // Лейбл суммы справа
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120)
        ])
    }
    
    // 5. Конфигурация ячейки данными
    func configure(with expense: Expense, amountText: String) {
        // Просто берем текст и иконку напрямую из enum!
        iconLabel.text = expense.category.icon
        categoryLabel.text = expense.category.rawValue
        
        noteLabel.text = expense.note ?? ""
        noteLabel.isHidden = (expense.note == nil || expense.note!.isEmpty)
        
        amountLabel.text = "-\(amountText)"
        amountLabel.textColor = .systemRed
    }
}

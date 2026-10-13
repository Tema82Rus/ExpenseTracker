//
//  ProgressIndicatorView.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 13.10.2026.
//

import UIKit

final class ProgressIndicatorView: UIView {
    
    // 1. Создаем UI-элементы кодом
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Серый фон полосы прогресса
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Цветная линия прогресса, которая будет заполняться
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue // Системный синий цвет по умолчанию
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Храним констрейнт ширины полосы прогресса для будущей анимации
    private var progressWidthConstraint: NSLayoutConstraint?
    
    // 2. Инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(trackView)
        trackView.addSubview(progressView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Верхний ряд: Название категории слева
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -12),
            
            // Верхний ряд: Сумма справа
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            // Нижний ряд: Серая полоса-трек под текстом
            trackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.heightAnchor.constraint(equalToConstant: 8),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Заполнение полосы: привязываем к левому краю, верх и низ трека
            progressView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: trackView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor)
        ])
        
        // Инициализируем констрейнт ширины полосы с нулевым значением (для последующего изменения)
        progressWidthConstraint = progressView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: 0.0)
        progressWidthConstraint?.isActive = true
    }
    
    // 3. Конфигурация данными с анимацией заполнения
    func configure(with model: CategoryAnalytics) {
        titleLabel.text = "\(model.category.icon) \(model.category.rawValue)"
        
        let amountNumber = NSNumber(value: model.totalAmount)
        amountLabel.text = NumberFormatter.expenseCurrency.string(from: amountNumber) ?? "\(model.totalAmount) ₽"
        
        // Подбираем цвет индикатора под категорию (для красоты)
        switch model.category {
        case .food: progressView.backgroundColor = .systemOrange
        case .transport: progressView.backgroundColor = .systemCyan
        case .leisure: progressView.backgroundColor = .systemPurple
        case .other: progressView.backgroundColor = .systemGray
        }
        
        // Деактивируем старую ширину, задаем новый коэффициент заполнения (от 0.0 до 1.0)
        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: CGFloat(model.percentage))
        progressWidthConstraint?.isActive = true
        
        // Плавная анимация проявления полоски
        setNeedsLayout()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}


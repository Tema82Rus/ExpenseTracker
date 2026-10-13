//
//  AnalyticsViewController.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 13.10.2026.
//

import UIKit

final class AnalyticsViewController: UIViewController {
    
    var presenter: AnalyticsPresenterProtocol?
    
    // 1. Создаем UI-элементы кодом
    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ВСЕГО ПОТРАЧЕНО:"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ₽"
        label.font = .systemFont(ofSize: 34, weight: .black)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Скролл-вью, чтобы графики не вылезали за пределы маленьких экранов (например, iPhone SE)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // Вертикальный стек, куда мы будем динамически добавлять графики категорий
    private let chartsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Каждый раз при открытии вкладки просим презентер пересчитать данные
        presenter?.viewWillAppear()
    }
    
    // 2. Добавление элементов на экран и Auto Layout верстка кодом
    private func setupUI() {
        title = "Аналитика"
        view.backgroundColor = .systemBackground
        
        view.addSubview(totalTitleLabel)
        view.addSubview(totalAmountLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(chartsStackView)
        
        NSLayoutConstraint.activate([
            // Заголовок "Всего потрачено" вверху с отступом от Safe Area
            totalTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            totalTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Крупный лейбл суммы под ним
            totalAmountLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: 4),
            totalAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Скролл-контейнер занимает всё оставшееся пространство снизу
            scrollView.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Привязка вертикального стэка к внутренним границам скролл-вью (Content Guide)
            chartsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            chartsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            chartsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            chartsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            
            // Жестко фиксируем ширину стэка по ширине экрана (Frame Guide), чтобы скролл шел только по вертикали
            chartsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
}

// MARK: - AnalyticsViewProtocol
extension AnalyticsViewController: AnalyticsViewProtocol {
    
    func showAnalytics(totalAmount: Double, data: [CategoryAnalytics]) {
        // Форматируем общую сумму расходов красивой валютной строкой
        let amountNumber = NSNumber(value: totalAmount)
        totalAmountLabel.text = NumberFormatter.expenseCurrency.string(from: amountNumber) ?? "\(totalAmount) ₽"
        
        // Очищаем старые графики перед новой отрисовкой (напишем логику графиков в День 18)
        chartsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func showEmptyState() {
        totalAmountLabel.text = "0 ₽"
        chartsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - SwiftUI #Preview
#if DEBUG
import SwiftUI

#Preview {
    let analyticsVC = AnalyticsViewController()
    let presenter = AnalyticsPresenter(view: analyticsVC)
    analyticsVC.presenter = presenter
    return UINavigationController(rootViewController: analyticsVC)
}
#endif


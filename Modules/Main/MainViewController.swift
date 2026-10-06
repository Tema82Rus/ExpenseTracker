//
//  MainViewController.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 05.10.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    // Презентер, соответствующий протоколу
    var presenter: MainPresenterProtocol?
    
    // Инициализируем таблицу через lazy var кодом
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension // Автоматическая высота ячейки под контент
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Связываем жизненный цикл контроллера с презентером
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Мои Расходы"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpenseButtonTapped))
        
        // Добавляем таблицу на экран
        view.addSubview(tableView)
        
        // Активируем констрейнты
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    /// Действие по нажатию на кнопку "+"
    @objc private func addExpenseButtonTapped() {
        let addExpenseVC = AddExpenseViewController()
        
        // Инициализируем презентер и передаем self (MainViewController) в качестве делегата!
        let addPresenter = AddExpensePresenter(view: addExpenseVC, delegate: self)
        addExpenseVC.presenter = addPresenter
        
        // Оборачиваем в NavigationController для красивого отображения бара
        let navigationController = UINavigationController(rootViewController: addExpenseVC)
        
        // Открываем модально
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

extension MainViewController: AddExpenseDelegate {
    func didSaveNewExpense() {
        // Когда экран добавления сохраняет расход, мы просим наш презентер обновить данные из базы
        presenter?.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfExpenses ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        
        // Получаем чистую модель расхода от презентера
        if let expense = presenter?.getExpense(at: indexPath.row) {
            
            // Форматируем сумму с помощью созданного NumberFormatter расширения
            let amountNumber = NSNumber(value: expense.amount)
            // Если форматер по какой-то причине вернет nil, подстрахуемся простой строкой
            let formattedAmount = NumberFormatter.expenseCurrency.string(from: amountNumber) ?? "\(expense.amount) ₽"
            
            // Настраиваем ячейку данными
            cell.configure(with: expense, amountText: formattedAmount)
        }
        
        return cell
    }
}


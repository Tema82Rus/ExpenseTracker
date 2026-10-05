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
        // Регистрируем дефолтную ячейку (кастомную сделаем в День 9)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.dataSource = self
        tableView.delegate = self
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
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfExpenses ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        if let expense = presenter?.getExpense(at: indexPath.row) {
            // Временное простое отображение данных (в День 9 заменим на красивую верстку)
            cell.textLabel?.text = "\(expense.amount) ₽ — \(expense.category.rawValue)"
        }
        
        return cell
    }
}


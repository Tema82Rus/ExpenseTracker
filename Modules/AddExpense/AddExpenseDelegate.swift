//
//  AddExpenseDelegate.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 06.10.2026.
//

import Foundation

/// Протокол-делегат обязательно наследует AnyObject,
/// чтобы мы могли удерживать на него слабую ссылку (weak)
protocol AddExpenseDelegate: AnyObject {
    func didSaveNewExpense()
}


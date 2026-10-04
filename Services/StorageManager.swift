//
//  StorageManager.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 05.10.2026.
//

import Foundation
import CoreData

final class StorageManager {
    
    // 1. Паттерн Singleton для единой точки доступа к базе данных
    static let shared = StorageManager()
    
    // Закрываем инициализатор, чтобы нельзя было создать второй экземпляр класса снаружи
    private init() {}
    
    // 2. Инициализация стека Core Data
    // Название контейнера должно строго совпадать с именем файла .xcdatamodeld
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpenseModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // В реальном приложении здесь должна быть более мягкая обработка ошибок,
                // но для MVP на этапе инициализации базы данных crash оправдан.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Удобный доступ к контексту главного потока для работы с UI-слоем
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 3. Сохранение изменений контекста на диск
    func saveContext() {
        let context = persistentContainer.viewContext
        // Проверяем, есть ли вообще изменения в оперативной памяти, чтобы не дёргать диск вхолостую
        if context.hasChanges {
            do {
                try context.save()
                print("📋 Core Data: Данные успешно сохранены на диск.")
            } catch {
                let nserror = error as NSError
                print("❌ Core Data: Ошибка сохранения контекста: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD: Create (Сохранение расхода)
    
    /// Метод конвертирует чистую структуру Expense в сущность базы данных ExpenseEntity и сохраняет её.
    /// - Parameter expense: Чистая модель расхода из бизнес-логики.
    func saveExpense(_ expense: Expense) {
        // Создаем объект ExpenseEntity внутри нашего контекста
        let expenseEntity = ExpenseEntity(context: context)
        
        // Data Mapping: Вручную перекладываем данные из структуры в Core Data объект
        expenseEntity.id = expense.id
        expenseEntity.amount = expense.amount
        expenseEntity.date = expense.date
        expenseEntity.note = expense.note
        
        // Так как Core Data не умеет напрямую хранить enum, сохраняем его rawValue (String).
        expenseEntity.category = expense.category.rawValue
        
        // Фиксируем изменения на жестком диске
        saveContext()
    }
    
    // MARK: - CRUD: Read (Чтение расходов)
    
    /// Метод извлекает все расходы из базы данных и трансформирует их в чистые структуры Expense.
    /// - Returns: Массив чистых моделей Expense для UI-слоя.
    func fetchExpenses() -> [Expense] {
        // Создаем запрос на выборку данных из таблицы ExpenseEntity
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        
        // (Опционально) Можно добавить сортировку по дате, чтобы новые расходы были сверху
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // Запрашиваем данные из контекста
            let managedExpenses = try context.fetch(fetchRequest)
            
            // Data Mapping: Трансформируем массив [ExpenseEntity] в чистый [Expense] через .map
            return managedExpenses.map { entity in
                
                // Безопасно восстанавливаем enum категории из строки.
                // Если в базе вдруг окажется некорректная строка, сработает дефолтное значение .other
                let categoryRawValue = entity.category ?? ""
                let category = Category(rawValue: categoryRawValue) ?? .other
                
                return Expense(
                    id: entity.id ?? UUID(),
                    amount: entity.amount,
                    category: category,
                    date: entity.date ?? Date(),
                    note: entity.note
                )
            }
        } catch {
            print("❌ Core Data: Ошибка при чтении данных: \(error.localizedDescription)")
            return [] // В случае ошибки возвращаем пустой массив, чтобы приложение не падало
        }
    }

}

//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Artem Yaroshenko on 11.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 1. Инициализируем и собираем первый модуль: Главный экран (Список расходов)
        let mainVC = MainViewController()
        let mainPresenter = MainPresenter(view: mainVC)
        mainVC.presenter = mainPresenter
        
        // Оборачиваем главный экран в NavigationController для верхнего бара с кнопкой "+"
        let mainNavController = UINavigationController(rootViewController: mainVC)
        // Задаем заголовки для вкладки таб-бара
        mainNavController.tabBarItem = UITabBarItem(
            title: "Расходы",
            image: UIImage(systemName: "creditcard"), // В День 20 заменим на SF Symbols красиво
            tag: 0
        )
        
        // 2. Инициализируем и собираем второй модуль: Экран аналитики
        let analyticsVC = AnalyticsViewController()
        let analyticsPresenter = AnalyticsPresenter(view: analyticsVC)
        analyticsVC.presenter = analyticsPresenter
        
        // Оборачиваем аналитику в собственный NavigationController для красивого верхнего бара
        let analyticsNavController = UINavigationController(rootViewController: analyticsVC)
        analyticsNavController.tabBarItem = UITabBarItem(
            title: "Аналитика",
            image: UIImage(systemName: "chart.pie.fill"),
            tag: 1
        )
        
        // 3. Создаем корневой UITabBarController и передаем ему оба наших модуля
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNavController, analyticsNavController]
        
        // Настраиваем внешний вид таб-бара под современные стандарты iOS
        tabBarController.tabBar.tintColor = .systemBlue // Цвет активной вкладки
        tabBarController.tabBar.backgroundColor = .systemBackground // Непрозрачный адаптивный фон
        
        // 4. Устанавливаем таб-бар в качестве корневого контроллера окна приложения
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


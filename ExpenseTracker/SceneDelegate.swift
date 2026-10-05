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
        
        // 1. Проверяем, что пришедшая сцена — это UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Создаем окно размером во весь экран
        let window = UIWindow(windowScene: windowScene)
        
        // 3. Создаем пустой экран и красим его в системный белый/черный цвет
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemBackground
        mainVC.title = "Мои Расходы" // Добавим заголовок для наглядности
        
        // 4. Оборачиваем экран в UINavigationController
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        // 5. Устанавливаем его как главный экран приложения
        window.rootViewController = navigationController
        
        // 6. Показываем окно на экране
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


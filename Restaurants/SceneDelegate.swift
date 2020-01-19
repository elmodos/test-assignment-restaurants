//
//  SceneDelegate.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        do {
            self.window?.rootViewController = try self.createRootVc()
        } catch {
            print("Error: \(error)")
        }
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    
    func createRootVc() throws -> UIViewController {
        
        enum MyError: Error { case fileNotFound }
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            throw MyError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let restaurants = try RestaurantListLoader.load(from: data)
        print("\(restaurants.restaurants.map { $0.name })")
        
        let bookmarkStore = UserDefaultsBookmarkStore<String>(suiteName: "conm.github.elmodos.Restaurants.bookmarks")
        let dependencies = RestaurantListViewModel.Dependencies(
            model: restaurants,
            bookmarkStore: bookmarkStore
        )
        let viewModel = RestaurantListViewModel(dependencies: dependencies)
        
        let viewController = RestaurantListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

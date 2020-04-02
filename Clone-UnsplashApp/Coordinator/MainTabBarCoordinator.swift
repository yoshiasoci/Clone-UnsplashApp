//
//  MainTabBarCoordinator.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarCoordinator: Coordinator {
    var viewController: UIViewController = .init()
    
    var customView = CustomView()
    
    private let photoCollectionCoordinator = PhotoCollectionCoordinator()
    private let photoCoordinator = PhotoCoordinator()
    
    weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        
        photoCoordinator.start()
        photoCollectionCoordinator.start()
        
        let viewControllers = [photoCoordinator.navigationController, photoCollectionCoordinator.navigationController]
        
        let tabBarItems: [UITabBarItem] = [
            UITabBarItem(title: "Photos", image: customView.resizeImage(image: UIImage(named: "photo")!, targetSize: CGSize(width: 30, height: 30)), tag: 1),
            UITabBarItem(title: "Collections", image: customView.resizeImage(image: UIImage(named: "collection")!, targetSize: CGSize(width: 30, height: 30)), tag: 2)
        ]
        
        let viewModel = MainTabBarViewModel(
            viewControllers: viewControllers,
            tabBarItems: tabBarItems
        )
        
        self.viewController = MainTabBarController(viewModel: viewModel)
        window?.rootViewController = self.viewController
    }
    
    //MARK: - Private Method
    
    //resize image
    
}

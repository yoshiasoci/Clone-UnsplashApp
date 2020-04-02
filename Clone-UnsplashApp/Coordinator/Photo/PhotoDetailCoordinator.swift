//
//  PhotoDetailCoordinator.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/25/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailCoordinator: NavigationCoordinator {
    var viewController: UIViewController = .init()
    
    var parentCoordinator: PhotoCoordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start(photoID: String) {
        let viewModel = PhotoDetailViewModel(photoID: photoID)
        let viewController = PhotoDetailViewController(viewModel: viewModel)
        
        self.viewController = viewController
        navigationController.pushViewController(self.viewController, animated: false)
    }
    
}

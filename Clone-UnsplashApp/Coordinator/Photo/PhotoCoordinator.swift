//
//  PhotoCoordinator.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class PhotoCoordinator: NSObject, ParentCoordinator, UINavigationControllerDelegate {
    var viewController: UIViewController = .init()
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        
        let viewModel = PhotoViewModel()
        let viewController = PhotoViewController(viewModel: viewModel)
        
        viewModel.detailPhotoSubscription = { [weak self] photoID in
            self?.detailPhotoSubscription(photoID: photoID)
        }
        
        self.viewController = viewController
        navigationController.pushViewController(self.viewController, animated: false)
    }
    
    func detailPhotoSubscription(photoID: String) {
        let child = PhotoDetailCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(photoID: photoID)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if fromViewController is PhotoDetailViewController {
            childCoordinators.enumerated().forEach {
                if $0.element.viewController === fromViewController {
                    childCoordinators.remove(at: $0.offset)
                }
            }
        }

    }
}

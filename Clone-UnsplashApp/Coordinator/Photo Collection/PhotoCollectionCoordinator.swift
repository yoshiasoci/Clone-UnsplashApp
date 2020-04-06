//
//  CollectionCoordinator.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionCoordinator: NSObject, ParentCoordinator, UINavigationControllerDelegate {
    var viewController: UIViewController = .init()
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        
        let viewModel = PhotoCollectionViewModel()
        let viewController = PhotoCollectionViewController(viewModel: viewModel)
        
        viewModel.detailpPhotoCollectionSubscription = { [weak self] collectionID in
            self?.detailPhotoCollectionSubscription(collectionID: collectionID)
        }
        
        self.viewController = viewController
        navigationController.pushViewController(self.viewController, animated: false)
    }
    
    func detailPhotoCollectionSubscription(collectionID: Int) {
        let child = PhotoCollectionDetailCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(collectionID: collectionID)
    }
    
}

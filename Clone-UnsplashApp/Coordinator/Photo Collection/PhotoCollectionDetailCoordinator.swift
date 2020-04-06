//
//  PhotoCollectionDetailCoordinator.swift
//  Clone-UnsplashApp
//
//  Created by admin on 4/6/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionDetailCoordinator: NavigationCoordinator {
    var viewController: UIViewController = .init()
    
    var parentCoordinator: PhotoCollectionCoordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start(collectionID: Int) {
        
        let viewModel = PhotoViewModel(listPhotoColection: true, collectionID: collectionID)
        let viewController = PhotoViewController(viewModel: viewModel)
        
        viewModel.detailPhotoSubscription = { [weak self] photoID in
            self?.detailPhotoSubscription(photoID: photoID)
        }
        
        self.viewController = viewController
        navigationController.pushViewController(self.viewController, animated: false)
    }
    
    func detailPhotoSubscription(photoID: String) {
        let child = PhotoDetailCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start(photoID: photoID)
    }
    
}

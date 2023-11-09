//
//  MainCoordinator.swift
//  CoordinatorTest
//
//  Created by Allan Evans on 11/8/23.
//

import UIKit

class MainCoordinator : NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LibraryTableViewController.instantiate()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
                if coordinator === child {
                    childCoordinators.remove(at: index)
                    break
                }
            }
    }
}

extension MainCoordinator: LibraryTableViewControllerDelegate {
    func libraryTableViewControllerDidSelectLibrary(_ selectedLibrary: Library) {
        let vc = LibraryDetailViewController.instantiate()
        vc.detailLibrary = selectedLibrary
        navigationController.pushViewController(vc, animated: true)
    }
}

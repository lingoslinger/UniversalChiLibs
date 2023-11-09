//
//  Coordinator.swift
//  CoordinatorTest
//
//  Created by Allan Evans on 11/8/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

//
//  CustomNavigationController.swift
//  Weather2App
//
//  Created by 2lup on 06.11.2022.
//

import UIKit

// Когда аниматоры готовы, нужно создать UINavigationControllerDelegate и добавить их в метод анимации. В качестве делегата будет выступать сам UINavigationController, для которого создадим новый класс:
class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return CustomPushAnimator()
        } else if operation == .pop {
            return CustomPopAnimator()
        }
        return nil
    }
}

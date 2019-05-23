//
//  TabbarInteractable.swift
//  TabBarInteraction
//
//  Created by potato04 on 2019/4/3.
//  Copyright © 2019 potato04. All rights reserved.
//

import UIKit

protocol TabbarInteractable {
    func replaceSwappableImageViews(with newView: UIView, and viewSize: CGSize)
}

extension TabbarInteractable where Self: UIViewController {
    func replaceSwappableImageViews(with newView: UIView, and viewSize: CGSize) {
        newView.isUserInteractionEnabled = false
        
        //find ViewController's nearest UITabBarController
        var parentController = self.parent
        while !(parentController is UITabBarController) {
            if parentController?.parent == nil { return }
            parentController = parentController?.parent
        }
        let tabbarController = parentController as! UITabBarController
        
        // using bfs to find ViewController's index in UITabBarController
        var controllerIndex = -1
        findControllerIndexLoop: for (i, child) in tabbarController.children.enumerated() {
            var queue = [child]
            while queue.count > 0 {
                let controller = queue.removeFirst()
                if controller is Self {
                    controllerIndex = i
                    break findControllerIndexLoop
                }
                for vc in controller.children {
                    queue.append(vc)
                }
            }
        }
        if controllerIndex == -1 { return }
        
        var tabBarButtons = tabbarController.tabBar.subviews.filter({
            type(of: $0).description().isEqual("UITabBarButton")
        })
        
        guard !tabBarButtons.isEmpty else { return }
        
        let tabBarButton = tabBarButtons[controllerIndex]
        let swappableImageViews = tabBarButton.subviews.filter({
            type(of: $0).description().isEqual("UITabBarSwappableImageView")
        })
        guard !swappableImageViews.isEmpty else { return }
        let swappableImageView = swappableImageViews.first!
        tabBarButton.addSubview(newView)
        swappableImageView.isHidden = true
        NSLayoutConstraint.activate([
            newView.widthAnchor.constraint(equalToConstant: viewSize.width),
            newView.heightAnchor.constraint(equalToConstant: viewSize.height),
            newView.centerXAnchor.constraint(equalTo: swappableImageView.centerXAnchor),
            newView.centerYAnchor.constraint(equalTo: swappableImageView.centerYAnchor)
        ])
    }
}

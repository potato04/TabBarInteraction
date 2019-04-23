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
        let tabbarControlelr = parentController as! UITabBarController
        
        // using bfs to find ViewController's index in UITabBarController
        var controllerIndex = -1
        findControllerIndexLoop: for (i, child) in tabbarControlelr.children.enumerated() {
            var stack = [child]
            while stack.count > 0 {
                let count = stack.count
                for j in stride(from: 0, to: count, by: 1) {
                    if stack[j] is Self {
                        controllerIndex = i
                        break findControllerIndexLoop
                    }
                    for vc in stack[j].children {
                        stack.append(vc)
                    }
                }
                for _ in 1...count {
                    stack.remove(at: 0)
                }
            }
        }
        if controllerIndex == -1 { return }
        
        var tabBarButtons = tabbarControlelr.tabBar.subviews.filter({
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

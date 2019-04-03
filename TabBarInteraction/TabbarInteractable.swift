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
        guard let parentController = self.parent as? UITabBarController else { return }
        let controllerIndex =  parentController.children.firstIndex(of: self)!
        var tabBarButtons = parentController.tabBar.subviews.filter({
            type(of: $0).description().isEqual("UITabBarButton")
        })
        guard !tabBarButtons.isEmpty else {
            return
        }
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

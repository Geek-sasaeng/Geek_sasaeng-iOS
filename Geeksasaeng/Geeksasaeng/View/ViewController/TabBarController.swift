//
//  PartyViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .mainColor
        tabBar.backgroundColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hex: 0xF2F2F2).cgColor
        setupVCs()
    }
    
    // MARK: - Functions
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: DeliveryViewController(), title: "홈", image: UIImage(named: "Home")!),
            createNavController(for: DeliveryViewController(), title: "커뮤니티", image: UIImage(named: "Community")!),
            createNavController(for: DeliveryViewController(), title: "채팅", image: UIImage.init(named: "Chat")!),
            createNavController(for: DeliveryViewController(), title: "프로필", image: UIImage.init(named: "Profile")!),
        ]
        
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        let unSelectedColor = UIColor(hex: 0x29ABE2, alpha: 0.3)
        tabBar.unselectedItemTintColor = unSelectedColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.customFont(.neoBold, size: 20)]
        
        return navController
    }
    
}

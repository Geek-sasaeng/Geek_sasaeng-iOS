//
//  PartyViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .mainColor
        setupVCs()
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: PartyViewController(), title: "홈", image: UIImage(named: "Home")!),
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
        rootViewController.navigationItem.title = "파티 보기"
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.customFont(.neoBold, size: 20)]
        
        // MARK: - 백버튼 안 보임.
        let doneItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = doneItem
        
        return navController
    }
    
}

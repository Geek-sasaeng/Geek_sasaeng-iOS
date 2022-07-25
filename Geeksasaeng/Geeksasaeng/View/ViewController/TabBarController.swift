//
//  PartyViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    // TabBarItem의 title로 쓸 데이터들을 모아둔 리스트
    let titleArray = ["홈", "커뮤니티", "채팅", "프로필"]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setupVCs()
    }
    
    /* TabBar의 Item이 선택되면 실행되는 함수!!! */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 탭바에 아이템이 있고, 선택된 아이템이 있을 때에만 { } 안을 실행
        if let items = self.tabBar.items,
           let selectedItem = self.tabBar.selectedItem {
            
            // 선택된 아이템의 인덱스를 찾아내고, 해당 인덱스에 있는 title 값을 가져온다
            let selectedTitle = titleArray[items.firstIndex(of: selectedItem)!]
            // 가져온 title 값을 선택된 아이템의 title로 설정해준다
            selectedItem.title = selectedTitle
            
            // 선택된 아이템이 아니면 title 값을 제거해준다
            items.forEach {
                if $0 != selectedItem {
                    $0.title = ""
                }
            }
        }
    }
    
    // MARK: - Functions
    
    /* TabBar의 속성 설정 */
    private func setAttributes() {
        tabBar.backgroundColor = .init(hex: 0xF8F8F8)
        tabBar.tintColor = .mainColor
        tabBar.barTintColor = .white
        
        tabBar.layer.borderWidth = 2
        tabBar.layer.borderColor = UIColor(hex: 0xF2F2F2).cgColor
    }
    
    /* TabBar에 들어갈 VC들을 구성하는 함수 */
    private func setupVCs() {
        viewControllers = [
            createNavController(for: DeliveryViewController(), title: titleArray[0], image: UIImage(named: "Home")!),
            createNavController(for: DeliveryViewController(), title: "", image: UIImage(named: "Community")!),
            createNavController(for: DeliveryViewController(), title: "", image: UIImage.init(named: "Chat")!),
            createNavController(for: DeliveryViewController(), title: "", image: UIImage.init(named: "Profile")!),
        ]
    }
    
    /* navigation controller의 rootVC 설정, TabBarItem의 이미지와 title을 구성하는 함수 */
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        // 스와이프 제스쳐로 VC를 pop할 수 있게 delegate 설정
        navController.interactivePopGestureRecognizer?.delegate = self
        
        tabBar.backgroundColor = .white
        navController.navigationBar.barTintColor = .white
        
        navController.tabBarItem.title = title
        // 네비게이션 타이틀 속성 설정.
        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.neoBold, size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x2F2F2F)
        ]
        
        navController.tabBarItem.image = image
        
        // 선택되지 않은 tabbar item의 색상도 mainColor로 설정 -> 설정 안 해주면 default가 회색이라서
        tabBar.unselectedItemTintColor = UIColor.mainColor
        
        // TabBarItem의 title 속성을 설정 - 색상, 폰트
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x636363),
            NSAttributedString.Key.font : UIFont.customFont(.neoBold, size: 20)], for: .selected)
        
        return navController
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UIViewController: UIGestureRecognizerDelegate {
    
    /* 스와이프 제스쳐로 VC를 pop할 수 있게 설정 */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

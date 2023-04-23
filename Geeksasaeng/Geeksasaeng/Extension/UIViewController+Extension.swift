//
//  UIViewController+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIViewController {
    public func showToast(viewController: UIViewController, message: String, font: UIFont, color: UIColor, width: Int = 209, height: Int = 59, top: Int? = nil) {
        let toastLabel = UILabel().then {
            $0.backgroundColor = color.withAlphaComponent(0.5)
            $0.text = message
            $0.textColor = UIColor.white
            $0.textAlignment = .center;
            $0.font = font
            $0.numberOfLines = 0
            $0.alpha = 1.0
            $0.layer.cornerRadius = 5;
            $0.clipsToBounds  =  true
        }
        
        viewController.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
            if let top = top {
                make.top.equalTo(view.safeAreaLayoutGuide).offset(top)
            } else {
                make.top.equalTo(UIScreen.main.bounds.size.height * 0.15)
            }
        }
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /* 밑에 작은 토스트 메세지 띄워주는 함수 */
    public func showBottomToast(viewController: UIViewController, message: String, font: UIFont, color: UIColor) {
        let toastView = UIView().then {
            $0.backgroundColor = color
            $0.layer.cornerRadius = 15
        }
        let toastLabel = UILabel().then {
            $0.text = message
            $0.font = font
            $0.textColor = UIColor.white
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
            let newSize = $0.sizeThatFits(view.frame.size)
            $0.frame.size = newSize
        }
        
        toastView.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        viewController.view.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.centerX.equalTo(viewController.view.center)
            make.width.equalTo(toastLabel.bounds.width + 20)
            make.height.equalTo(toastLabel.bounds.height + 20)
            make.bottom.equalTo(viewController.view.safeAreaLayoutGuide).offset(-40)
        }
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
    
    /* 배경에 어두운 블러뷰 만드는 함수 */
    public func setDarkBlurView() -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        return visualEffectView
    }
    
    /* 네이게이션 바에 어두운 블러뷰 만드는 함수 */
    public func setDarkBlurViewOnNav() -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        visualEffectView.frame = (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -((self.navigationController?.navigationBar.frame.size.height)!)).offsetBy(dx: 0, dy: -((self.navigationController?.navigationBar.frame.size.height)!)))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        
        return visualEffectView
    }
    
    /* 더 어두운 배경 */
    public func setMoreDarkBlurView() -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.9
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        return visualEffectView
    }
    
    /* 왼쪽에서 오른쪽으로 Swipe Gesture Recognizer를 추가하는 함수 */
    public func addRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    // 네비게이션 바 배경색, 폰트 설정
    public func setCustomNavigationBar(_ backgroundColor: UIColor = .white) {
        // navigation bar 배경색 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowImage = nil
        appearance.shadowColor = nil    // 하단에 1px 선 생기는 거 제거
        
        // title 폰트 설정
        let titleAttribute = [NSAttributedString.Key.font: UIFont.customFont(.neoBold, size: 18), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x2F2F2F)]
        appearance.titleTextAttributes = titleAttribute

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - @objc Functions
    
    /* 스와이프 감지했을 때, 이전 화면으로 돌아가는 동작 실행 */
    @objc
    public func swipeAction(swipe: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    // 이전 화면으로 돌아가기
    @objc
    public func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 메인 화면으로 돌아가기
    @objc
    public func tapGoMainButton() {
        // tabBarController 안의 deliveryVC에 데이터를 전달하는 방법!
        let mainVC = TabBarController()
        let navController = mainVC.viewControllers![0] as! UINavigationController
        let deliveryVC = navController.topViewController as! DeliveryViewController
        deliveryVC.dormitoryInfo = DormitoryNameResult(id: LoginModel.dormitoryId, name: LoginModel.dormitoryName)
        
        UIApplication.shared.windows.first?.rootViewController = mainVC
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}

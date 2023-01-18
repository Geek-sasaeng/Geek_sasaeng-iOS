//
//  UIViewController+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIViewController {
    public func showToast(viewController: UIViewController, message: String, font: UIFont, color: UIColor, width: Int = 209, height: Int = 40) {
        let toastLabel = UILabel().then {
            $0.backgroundColor = color.withAlphaComponent(0.6)
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
//            make.top.equalTo(viewController.view.safeAreaInsets.top).offset(75)
            make.top.equalTo(UIScreen.main.bounds.size.height * 0.15)
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
    
    /* 왼쪽에서 오른쪽으로 Swipe Gesture Recognizer를 추가하는 함수 */
    public func addRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
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
}

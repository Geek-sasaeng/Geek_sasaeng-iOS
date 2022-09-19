//
//  UIViewController+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIViewController {
    public func showToast(viewController: UIViewController, message: String, font: UIFont, color: UIColor) {
        let toastLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = color.withAlphaComponent(0.6)
            label.text = message
            label.textColor = UIColor.white
            label.textAlignment = .center;
            label.font = font
            label.numberOfLines = 0
            label.alpha = 1.0
            label.layer.cornerRadius = 5;
            label.clipsToBounds  =  true
            return label
        }()
        
        viewController.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(viewController.view.center)
            make.width.equalTo(209)
            make.height.equalTo(40)
            make.top.equalTo(viewController.view.safeAreaInsets.top).offset(75)
        }
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /* 밑에 작은 토스트 메세지 띄워주는 함수 */
    public func showBottomToast(viewController: UIViewController, message: String, font: UIFont, color: UIColor) {
        let toastView: UIView = {
            let view = UIView()
            view.backgroundColor = color
            view.layer.cornerRadius = 15
            return view
        }()
        let toastLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.font = font
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.lineBreakMode = .byCharWrapping
            let newSize = label.sizeThatFits(view.frame.size)
            label.frame.size = newSize
            return label
        }()
        
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
    
    /* 스와이프 감지했을 때, 이전 화면으로 돌아가는 동작 실행 */
    @objc public func swipeAction(swipe: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}

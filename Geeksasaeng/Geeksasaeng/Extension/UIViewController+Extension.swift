//
//  UIViewController+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIViewController {
    func showToast(viewController: UIViewController, message : String, font: UIFont) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor(hex: 0x003C56).withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        viewController.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(viewController.view.center)
            make.width.equalTo(226)
            make.height.equalTo(61)
            make.top.equalTo(viewController.view.safeAreaInsets.top).offset(75)
        }
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

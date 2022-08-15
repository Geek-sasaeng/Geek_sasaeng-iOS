//
//  ProfileVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/16.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributes()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 정보"
        self.navigationItem.setLeftBarButton(
            UIBarButtonItem(image: UIImage(named: "Bell"), style: .plain, target: self, action: #selector(tapBellButton)
                           ), animated: true)
        self.navigationItem.leftBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "Pencil"), style: .plain, target: self, action: #selector(tapPencilButton)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapBellButton() {
        print("DEBUG: 종 버튼 클릭")
    }
    
    @objc
    private func tapPencilButton() {
        print("DEBUG: 연필 버튼 클릭")
    }
}

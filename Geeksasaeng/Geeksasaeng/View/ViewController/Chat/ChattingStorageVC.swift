//
//  ChattingStorageViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/09/28.
//

import UIKit

import SnapKit

/* 채팅 보관함 메인 화면 */
class ChattingStorageViewController: UIViewController {

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributes()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "보관함"
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "Pencil"), style: .plain, target: self, action: #selector(tapStorageEdit)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13)
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
        
        view.backgroundColor = .white
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapStorageEdit() {
        print("DEBUG: 채팅 보관함 수정 버튼 클릭")
    }

}

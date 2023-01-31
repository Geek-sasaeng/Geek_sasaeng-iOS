//
//  ForcedExitTableViewCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/09/28.
//

import UIKit

import SnapKit
import Then

class ForcedExitTableViewCell: UITableViewCell {
    
    // MARK: - SubViews
    
    let checkBox = UIImageView().then {
        $0.image = UIImage(named: "UncheckedSquare")
    }
    
    let userProfileImage = UIImageView().then {
        $0.image = UIImage(named: "ForcedExit_unSelectedProfile")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    let userName = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
    }
    
    // MARK: - Properties
    
    static let identifier = "ForcedExitTableViewCell"
    var cellIsSelected = false
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [checkBox, userProfileImage, userName].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        checkBox.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(27)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.width.equalTo(39)
            make.height.equalTo(41)
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBox.snp.right).offset(19)
        }
        
        userName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(userProfileImage.snp.right).offset(12)
            make.right.equalToSuperview().inset(24)
        }
    }
}

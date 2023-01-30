//
//  MyActivityListTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/17.
//

import UIKit

import SnapKit
import Then

/* 나의 활동 목록 tableview의 cell */
class MyActivityListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyActivityListCell"
    
    // MARK: - SubViews
    
    let categoryImageView = UIImageView(image: UIImage(named: "PartyChatImage")).then {
        $0.layer.cornerRadius = 26 / 2
    }
    let partyTitleLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 15)
        $0.textColor = .black
        $0.lineBreakMode = .byCharWrapping
    }
    
    let peopleImageView = UIImageView().then {
        $0.image = UIImage(named: "PeopleMark")
    }
    let peopleLabel = UILabel().then {
        $0.text = "4"
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    let foodCategoryLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 13)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    let dateLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 13)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        contentView.backgroundColor = .white
        
        setAttributes()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        // 셀 간격 설정
        let margins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        
        // 셀 테두리 그림자 생성
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.position = contentView.center
    }
    
    private func addSubViews() {
        [
            categoryImageView,
            partyTitleLabel,
            peopleImageView,
            peopleLabel,
            foodCategoryLabel,
            dateLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        categoryImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(37)
            make.top.equalToSuperview().inset(11)
            make.width.height.equalTo(32)
        }
        partyTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryImageView.snp.centerY)
            make.left.equalTo(categoryImageView.snp.right).offset(11)
            make.width.equalTo(176 + 69)
        }
        peopleImageView.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.bottom).offset(13)
            make.left.equalToSuperview().inset(41)
            make.width.equalTo(14)
            make.height.equalTo(12)
        }
        peopleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleImageView.snp.centerY)
            make.left.equalTo(peopleImageView.snp.right).offset(10)
        }
        foodCategoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel.snp.centerY)
            make.left.equalTo(peopleLabel.snp.right).offset(24)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(foodCategoryLabel.snp.centerY)
            make.right.equalToSuperview().inset(41)
        }
    }
    
}

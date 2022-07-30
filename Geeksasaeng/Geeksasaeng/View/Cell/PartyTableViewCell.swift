//
//  PartyTableViewCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/02.
//

import UIKit
import SnapKit

class PartyTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PartyCell"
    
    // MARK: - SubViews
    
    var peopleImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "PeopleMark")
        return imageView
    }()
    
    var peopleLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 14)
        return label
    }()
    
    var timeLabel: UILabel = {
        var label = UILabel()
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 14)
        return label
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .customFont(.neoBold, size: 18)
        return label
    }()
    
    var categoryLabel: UILabel = {
        var label = UILabel()
        // TODO: - 서버 수정되면 카테고리 데이터 받아오기
        label.text = "중식"
        label.textColor = UIColor(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 12)
        return label
    }()
    
    var hashtagLabel: UILabel = {
        var label = UILabel()
        label.text = "같이 먹고 싶어요"
        label.textColor = UIColor(hex: 0xEFEFEF)
        label.font = .customFont(.neoMedium, size: 12)
        return label
    }()
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Set Functions
    
    func addSubViews() {
        [
            peopleImageView,
            peopleLabel,
            timeLabel,
            titleLabel,
            categoryLabel,
            hashtagLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    func setLayouts() {
        peopleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().inset(24)
            make.width.equalTo(14)
            make.height.equalTo(12)
        }
        
        peopleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleImageView)
            make.left.equalTo(peopleImageView.snp.right).offset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.left.equalTo(peopleLabel.snp.right).offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(22)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(29)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.left.equalToSuperview().inset(101)
        }
        
//        badgeImageView.snp.makeConstraints { make in
//            make.top.equalTo(hashtagLabel).offset(-3)
//            make.left.equalTo(hashtagLabel.snp.right).offset(30)
//            make.width.height.equalTo(18)
//        }
//
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalTo(badgeImageView).offset(1)
//            make.left.equalTo(badgeImageView.snp.right).offset(7)
//        }
    }
}

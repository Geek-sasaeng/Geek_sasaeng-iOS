//
//  PartyTableViewCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/02.
//

import UIKit
import SnapKit

class PartyTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
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
    
    var optionLabel: UILabel = {
        var label = UILabel()
        label.text = "매칭 시 바로 주문"
        label.textColor = UIColor(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 12)
        return label
    }()
    
    var hashtagLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 12)
        return label
    }()
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        
        addSubViews()
        configLayouts()
    }
    
    // MARK: - Set Functions
    
    func addSubViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(hashtagLabel)
//        contentView.addSubview(nameLabel)
        contentView.addSubview(peopleLabel)
        contentView.addSubview(peopleImageView)
//        contentView.addSubview(badgeImageView)
    }
    
    func configLayouts() {
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
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(29)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.top)
            make.left.equalTo(optionLabel.snp.right).offset(45)
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

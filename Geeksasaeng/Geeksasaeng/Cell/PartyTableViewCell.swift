//
//  PartyTableViewCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/02.
//

import UIKit
import SnapKit

class PartyTableViewCell: UITableViewCell {
    // MARK: Variables
    var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "3시간 48분 남았어요"
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 14)
        
        return label
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "중식 같이 먹어요"
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
        label.text = "#만나서 먹을 수 있어요"
        label.textColor = UIColor(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 12)
        
        return label
    }()
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "네오"
        label.textColor = UIColor(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 12)
        
        return label
    }()
    
    var peopleLabel: UILabel = {
        var label = UILabel()
        label.text = "2/4"
        label.textColor = UIColor(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        
        return label
    }()
    
    var peopleImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "PeopleMark")
        
        return imageView
    }()
    
    var badgeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        
        return imageView
    }()
    
    
    // MARK: layoutSubviews()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        configLayouts()
    }
    
    
    // MARK: Config Methods
    func addSubViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(hashtagLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(peopleLabel)
        contentView.addSubview(peopleImageView)
        contentView.addSubview(badgeImageView)
    }
    
    func configLayouts() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.top)
            make.left.equalTo(optionLabel.snp.right).offset(50)
        }
        
        peopleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).offset(5)
            make.left.equalTo(titleLabel.snp.right).offset(160)
            make.width.equalTo(13)
            make.height.equalTo(11)
        }
        
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleImageView).offset(-2)
            make.left.equalTo(peopleImageView.snp.right).offset(10)
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalTo(hashtagLabel).offset(-3)
            make.left.equalTo(hashtagLabel.snp.right).offset(30)
            make.width.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(badgeImageView).offset(1)
            make.left.equalTo(badgeImageView.snp.right).offset(7)
        }
    }
}

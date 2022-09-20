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
    let peopleLabel = UILabel()
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let hashtagLabel = UILabel()
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        setLayouts()
        setAttributes()
    }
    
    // MARK: - Set Functions
    
    private func addSubViews() {
        [
            peopleImageView,
            peopleLabel,
            timeLabel,
            titleLabel,
            categoryLabel,
            hashtagLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
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
            make.left.equalToSuperview().offset(23)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.left.equalToSuperview().inset(101)
        }
    }
    
    private func setAttributes() {
        peopleLabel.setTextColorAndFont(textColor: UIColor(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 14))
        timeLabel.setTextColorAndFont(textColor: .mainColor, font: .customFont(.neoMedium, size: 14))
        titleLabel.setTextColorAndFont(textColor: .black, font: .customFont(.neoBold, size: 18))
        categoryLabel.setTextColorAndFont(textColor: UIColor(hex: 0x636363), font: .customFont(.neoMedium, size: 12))
        hashtagLabel.setTextColorAndFont(textColor: UIColor(hex: 0xEFEFEF), font: .customFont(.neoMedium, size: 12))
        hashtagLabel.text = "같이 먹고 싶어요"
        
        self.selectionStyle = .gray
    }
}

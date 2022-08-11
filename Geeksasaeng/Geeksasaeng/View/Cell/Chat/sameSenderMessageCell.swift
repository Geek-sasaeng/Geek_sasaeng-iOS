//
//  sameSenderMessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/11.
//

import UIKit
import SnapKit

class SameSenderMessageCell: UICollectionViewCell {
    // MARK: - SubViews
//    var leftImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "person")
//        imageView.layer.cornerRadius = 16
//        imageView.tintColor = .black
//        return imageView
//    }()
//
//    var rightImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "person.fill")
//        imageView.layer.cornerRadius = 16
//        imageView.tintColor = .black
//        return imageView
//    }()
    
    var rightTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var leftTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var rightUnReadCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .mainColor
        return label
    }()
    
    var leftUnReadCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .mainColor
        return label
    }()
    
    var leftMessageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.backgroundColor = .init(hex: 0xEFEFEF)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 200
        
        label.paddingTop = 10
        label.paddingBottom = 10
        label.paddingLeft = 18
        label.paddingRight = 18
        return label
    }()
    
    var rightMessageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.backgroundColor = .init(hex: 0xEFEFEF)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 200
        
        label.paddingTop = 10
        label.paddingBottom = 10
        label.paddingLeft = 18
        label.paddingRight = 18
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        contentView.backgroundColor = .red
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func addSubViews() {
        [leftMessageLabel, rightMessageLabel,
         rightTimeLabel, rightUnReadCountLabel, leftTimeLabel, leftUnReadCountLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        leftMessageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(65)
        }
        
        rightMessageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(65)
        }
        
        leftTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftMessageLabel.snp.bottom)
            make.left.equalTo(leftMessageLabel.snp.right).offset(3)
        }
        
        leftUnReadCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftMessageLabel.snp.bottom)
            make.left.equalTo(leftTimeLabel.snp.right).offset(6)
        }
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightMessageLabel.snp.bottom)
            make.right.equalTo(rightMessageLabel.snp.left).offset(-3)
        }
        
        rightUnReadCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightMessageLabel.snp.bottom)
            make.right.equalTo(rightTimeLabel.snp.left).offset(-6)
        }
    }
}

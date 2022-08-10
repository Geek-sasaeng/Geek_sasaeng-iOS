//
//  MessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit

class MessageCell: UICollectionViewCell {
    // MARK: - SubViews
    var nicknameLabel : UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoBold, size: 11)
        label.textColor = .black
        return label
    }()
    
    var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 16
        imageView.tintColor = .black
        return imageView
    }()
    
    var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.cornerRadius = 16
        imageView.tintColor = .black
        return imageView
    }()
    
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
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func addSubViews() {
        [nicknameLabel, leftMessageLabel, rightMessageLabel,
         rightTimeLabel, rightUnReadCountLabel, leftTimeLabel, leftUnReadCountLabel,
         leftImageView, rightImageView,].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        leftMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.left.equalTo(leftImageView.snp.right).offset(10)
//            make.height.equalTo(39)
        }
        
        rightMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
//            make.height.equalTo(39)
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
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(23)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(23)
        }
    }
}

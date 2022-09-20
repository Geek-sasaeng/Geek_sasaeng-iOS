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
    
    let leftImageView = UIImageView()
    let rightImageView = UIImageView()
    let nicknameLabel = UILabel()
    let rightTimeLabel = UILabel()
    let leftTimeLabel = UILabel()
    let leftMessageLabel = PaddingLabel()
    let rightMessageLabel = PaddingLabel()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setAttributes()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // reuse 전에 값들을 다 초기화
        leftMessageLabel.text = ""
        rightMessageLabel.text = ""
        
        leftMessageLabel.isHidden = false
        rightMessageLabel.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
        
        leftImageView.isHidden = false
        rightImageView.isHidden = false
    }
    
    // MARK: - Functions
    private func addSubViews() {
        [nicknameLabel, leftMessageLabel, rightMessageLabel,
         rightTimeLabel, leftTimeLabel,
         leftImageView, rightImageView,].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        leftMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.left.equalTo(leftImageView.snp.right).offset(10)
        }
        
        rightMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
        
        leftTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftMessageLabel.snp.bottom)
            make.left.equalTo(leftMessageLabel.snp.right).offset(3)
        }
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightMessageLabel.snp.bottom)
            make.right.equalTo(rightMessageLabel.snp.left).offset(-3)
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
    
    private func setAttributes() {
        nicknameLabel.setTextColorAndFont(textColor: .black, font: .customFont(.neoBold, size: 11))
        rightTimeLabel.setTextColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        leftTimeLabel.setTextColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        
        [leftMessageLabel, rightMessageLabel].forEach {
            $0.paddingTop = 10
            $0.paddingBottom = 10
            $0.paddingLeft = 18
            $0.paddingRight = 18
            $0.setTextColorAndFont(textColor: .black, font: .customFont(.neoMedium, size: 15))
            $0.numberOfLines = 0
            $0.backgroundColor = .init(hex: 0xEFEFEF)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
            $0.textAlignment = .left
            $0.lineBreakMode = .byCharWrapping
            $0.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.569
            $0.sizeToFit()
            $0.setNeedsLayout()
        }
        
        [leftImageView, rightImageView].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
    }
}

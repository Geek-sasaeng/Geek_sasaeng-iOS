//
//  ImageMessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/30.
//

import UIKit
import SnapKit

class ImageMessageCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    let leftImageView = UIButton().then {
        $0.isUserInteractionEnabled = true
    }
    let rightImageView = UIImageView()
    let nicknameLabel = UILabel()
    let rightTimeLabel = UILabel()
    let leftTimeLabel = UILabel()
    let leftImageMessageView = UIView()
    let rightImageMessageView = UIView()
    let imageView = UIImageView()
    let imageData = UIImage()
    
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
        leftImageMessageView.isHidden = false
        rightImageMessageView.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
        
        leftImageView.isHidden = false
        rightImageView.isHidden = false
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [nicknameLabel, leftImageMessageView, rightImageMessageView,
         rightTimeLabel, leftTimeLabel,
         leftImageView, rightImageView,].forEach {
            addSubview($0)
        }
        [leftImageMessageView, rightImageMessageView].forEach {
            $0.addSubview(imageView)
        }
    }
    
    private func setLayouts() {
        leftImageMessageView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.width.equalTo(155)
            make.height.equalTo(154)
        }
        
        rightImageMessageView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
            make.width.equalTo(155)
            make.height.equalTo(154)
        }
        
        leftTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftImageMessageView.snp.bottom)
            make.left.equalTo(leftImageMessageView.snp.right).offset(3)
        }
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightImageMessageView.snp.bottom)
            make.right.equalTo(rightImageMessageView.snp.left).offset(-3)
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
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(135)
            make.height.equalTo(134)
            make.center.equalToSuperview()
        }
    }
    
    private func setAttributes() {
        nicknameLabel.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoBold, size: 11))
        rightTimeLabel.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        leftTimeLabel.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        [leftImageMessageView, rightImageMessageView].forEach {
            $0.backgroundColor = .init(hex: 0xEFEFEF)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
        }
        
        [leftImageView, rightImageView].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
    }
}

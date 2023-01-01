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
    
    let leftUnreadCntLabel = UILabel()
    let rightUnreadCntLabel = UILabel()
    let leftTimeLabel = UILabel()
    let rightTimeLabel = UILabel()
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
        
        leftMessageLabel.text = ""
        rightMessageLabel.text = ""
        
        leftTimeLabel.text = ""
        rightTimeLabel.text = ""
        
        leftUnreadCntLabel.text = ""
        rightUnreadCntLabel.text = ""
        
        leftMessageLabel.isHidden = false
        rightMessageLabel.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
        
        leftUnreadCntLabel.isHidden = false
        rightUnreadCntLabel.isHidden = false
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            leftMessageLabel, rightMessageLabel,
            leftTimeLabel, rightTimeLabel,
            leftUnreadCntLabel, rightUnreadCntLabel
        ].forEach {
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
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightMessageLabel.snp.bottom)
            make.right.equalTo(rightMessageLabel.snp.left).offset(-3)
        }
        
        leftUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftTimeLabel.snp.centerY)
            make.left.equalTo(leftTimeLabel.snp.right).offset(6)
        }
        
        rightUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightTimeLabel.snp.centerY)
            make.right.equalTo(rightTimeLabel.snp.left).offset(-6)
        }
    }
    
    private func setAttributes() {
        [leftTimeLabel, rightTimeLabel].forEach {
            $0.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        }
        
        [leftUnreadCntLabel, rightUnreadCntLabel].forEach {
            $0.setTextAndColorAndFont(textColor: .mainColor, font: .customFont(.neoMedium, size: 12))
        }
        
        [leftMessageLabel, rightMessageLabel].forEach {
            $0.paddingTop = 10
            $0.paddingBottom = 10
            $0.paddingLeft = 18
            $0.paddingRight = 18
            $0.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoMedium, size: 15))
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
    }
}

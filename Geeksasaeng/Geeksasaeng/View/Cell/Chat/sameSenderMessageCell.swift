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
        
        label.sizeToFit()
        label.setNeedsLayout()
        
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
        
        label.sizeToFit()
        label.setNeedsLayout()
        
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
        
//        contentView.backgroundColor = .yellow
        
        addSubViews()
        setLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        leftMessageLabel.text = ""
        rightMessageLabel.text = ""
        
        leftMessageLabel.isHidden = false
        rightMessageLabel.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
    }
    
    // MARK: - Functions
    private func addSubViews() {
        [leftMessageLabel, rightMessageLabel,
         rightTimeLabel, leftTimeLabel].forEach {
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
    }
}

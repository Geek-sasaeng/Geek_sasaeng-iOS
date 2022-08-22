//
//  ParticipantCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit

class SystemMessageCell: UICollectionViewCell {
    // MARK: - SubViews
    
    var systemMessageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .init(hex: 0x636363)
        label.backgroundColor = .init(hex: 0xF8F8F8)
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 250
        
        label.sizeToFit()
        label.setNeedsLayout()
        
        label.paddingTop = 6
        label.paddingBottom = 6
        label.paddingLeft = 18
        label.paddingRight = 18
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    private func addSubViews() {
        addSubview(systemMessageLabel)
    }
    
    private func setLayouts() {
        systemMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
}

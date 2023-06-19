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
    
    var systemMessageLabel = PaddingLabel().then {
        $0.setTextAndColorAndFont(textColor: .init(hex: 0x636363), font: .customFont(.neoMedium, size: 12))
        $0.backgroundColor = .init(hex: 0xF8F8F8)
        $0.numberOfLines = 0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        $0.lineBreakMode = .byCharWrapping
        $0.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.783
        
        $0.sizeToFit()
        $0.setNeedsLayout()
        
        $0.paddingTop = 6
        $0.paddingBottom = 6
        $0.paddingLeft = 18
        $0.paddingRight = 18
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        systemMessageLabel.text = ""
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

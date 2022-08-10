//
//  ParticipantCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit

class ParticipantCell: UICollectionViewCell {
    // MARK: - SubViews
    
    var participantLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .init(hex: 0x636363)
        label.backgroundColor = .init(hex: 0xF8F8F8)
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        setLayouts()
    }
    
    private func addSubViews() {
        addSubview(participantLabel)
    }
    
    private func setLayouts() {
        participantLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
}

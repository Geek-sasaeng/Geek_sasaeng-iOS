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
    var participantView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 5
        return view
    }()
    
    var participantLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = .init(hex: 0x636363)
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        setLayouts()
    }
    
    private func addSubViews() {
        participantView.addSubview(participantLabel)
        addSubview(participantView)
    }
    
    private func setLayouts() {
        participantLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        participantView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(39)
        }
    }
}

//
//  TimeCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/24.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TimeCell"
    
    // MARK: - Subviews
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 14)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttributes()
        setLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        // contentView의 색깔 설정 = cell의 색깔 설정이었다...!
        contentView.backgroundColor = .init(hex: 0xF8F8F8)
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    private func setLayouts() {
        contentView.addSubview(timeLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

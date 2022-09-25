//
//  WeeklyTopCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit

import SnapKit
import Then

class WeeklyTopCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = "WeeklyTopCell"
    
    // MARK: - Subviews
    
    var rankLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    var searchLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .init(hex: 0x5B5B5B)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        // 레이아웃 설정
        contentView.snp.makeConstraints { make in
            make.top.left.right.height.equalToSuperview()
        }
        contentView.clipsToBounds = true
        setLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setLayouts() {
        [rankLabel, searchLabel].forEach { contentView.addSubview($0) }
        
        rankLabel.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
        }
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rankLabel)
            make.left.equalTo(rankLabel.snp.right).offset(15)
        }
    }
}

//
//  RecentSearchCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit

import SnapKit
import Then

class RecentSearchCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = "RecentSearchCell"
    
    // MARK: - Subviews
    
    var recentSearchLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    var xImageView = UIImageView().then {
        $0.image = UIImage(systemName: "xmark")
        $0.tintColor = .init(hex: 0x5B5B5B)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        setLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setLayouts() {
        // 레이아웃 설정
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [recentSearchLabel, xImageView].forEach { contentView.addSubview($0) }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
        }
        
        xImageView.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchLabel)
            make.right.equalToSuperview()
            make.left.equalTo(recentSearchLabel.snp.right).offset(3)
            make.width.equalTo(13)
            make.height.equalTo(16)
        }
    }
}

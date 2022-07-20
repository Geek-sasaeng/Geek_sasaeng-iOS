//
//  RecentSearchCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit
import SnapKit

class RecentSearchCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = "RecentSearchCell"
    
    // MARK: - Subviews
    
    var recentSearchLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 14)
        label.textColor = .init(hex: 0x5B5B5B)
        return label
    }()
    
    var xImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = .init(hex: 0x5B5B5B)
        return imageView
    }()
    
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
        [recentSearchLabel, xImageView].forEach { contentView.addSubview($0) }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
        }
        
        xImageView.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchLabel)
            make.right.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(16)
        }
    }
}

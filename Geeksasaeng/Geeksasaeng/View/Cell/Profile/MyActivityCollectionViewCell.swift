//
//  MyActivityCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class MyActivityCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "MyActivityCollectionViewCell"
    
    // MARK: - SubViews
    let categoryLabel = UILabel().then {
        $0.text = "배달파티"
        $0.textColor = .mainColor
        $0.font = .customFont(.neoRegular, size: 11)
    }
    
    let titleLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 13)
    }
    let createdAtLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 11)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    
    let deliveryPartyImageView = UIImageView(image: UIImage(named: "DeliveryPartyIcon"))
    
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        
        addSubViews()
        setLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func addSubViews() {
        [ categoryLabel, titleLabel, createdAtLabel, deliveryPartyImageView ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.left.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.left.equalTo(categoryLabel.snp.left)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
        }
        
        deliveryPartyImageView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
        }
    }
    
}

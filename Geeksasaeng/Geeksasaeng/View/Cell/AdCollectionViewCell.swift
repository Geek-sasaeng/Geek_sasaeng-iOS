//
//  AdCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/06.
//

import UIKit

import SnapKit
import Then

class AdCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AdCell"
    
    // MARK: - Subviews
    
    var cellImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .mainColor  // test. 배포 때는 없앨 것
        $0.contentMode = .scaleToFill
        $0.image = UIImage()
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        // 레이아웃 설정.
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(18)
            make.height.equalToSuperview()
        }
        
        contentView.clipsToBounds = true
        self.contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.top.left.right.height.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

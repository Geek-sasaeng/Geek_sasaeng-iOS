//
//  AdCollectionViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/06.
//

import UIKit
import SnapKit

class AdCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AdCell"
    
    // MARK: - Subviews
    
    var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .mainColor  // test. 배포 때는 없앨 것
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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

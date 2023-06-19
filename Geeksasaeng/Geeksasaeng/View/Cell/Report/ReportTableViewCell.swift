//
//  ReportTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/23.
//

import UIKit

import SnapKit
import Then

class ReportTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ReportCell"
    
    // MARK: - SubViews
    
    var reportCategoryLabel = UILabel().then {
        $0.textColor = .init(hex: 0x636363)
        $0.font = .customFont(.neoMedium, size: 14)
    }
    
    var arrowButton = UIButton().then {
        $0.setImage(UIImage(named: "ReportArrow"), for: .normal)
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            reportCategoryLabel,
            arrowButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        reportCategoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(17)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(17)
        }
    }

}

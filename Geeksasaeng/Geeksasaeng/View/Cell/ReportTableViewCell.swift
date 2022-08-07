//
//  ReportTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/23.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ReportCell"
    
    // MARK: - SubViews
    
    var reportCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x636363)
        label.font = .customFont(.neoMedium, size: 14)
        return label
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ReportArrow"), for: .normal)
        return button
    }()
    
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

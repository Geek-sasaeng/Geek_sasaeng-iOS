//
//  OngoingTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/18.
//

import UIKit

import SnapKit
import Then

/* 진행 중인 활동 tableview의 cell */
class OngoingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "OngoingCell"
    var partyTitle: String? {
        didSet {
            partyTitleLabel.text = partyTitle
        }
    }
    
    // MARK: - SubViews
    
    let masterProfileImageView = UIImageView(image: UIImage(named: "PartyChatImage")).then {
        $0.layer.cornerRadius = 26 / 2
    }
    
    let partyTitleLabel = UILabel().then {
        $0.text = "한둘셋넷닷한둘셋넷닷총열개"
        $0.font = UIFont.customFont(.neoBold, size: 13)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    let arrowButton = UIButton().then {
        $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        contentView.backgroundColor = .white
        
        setAttributes()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        contentView.backgroundColor = .init(hex: 0xFCFDFE)
        self.selectionStyle = .none
        
        // 셀 간격 설정
        let margins = UIEdgeInsets(top: 1, left: 4, bottom: 8, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
        
        // 셀 테두리 그림자 생성
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.position = contentView.center
    }
    
    private func addSubViews() {
        [
            masterProfileImageView,
            partyTitleLabel,
            arrowButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 레이아웃 설정.
        masterProfileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(18)
            make.width.height.equalTo(26)
        }
        
        partyTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(masterProfileImageView.snp.right).offset(10)
            make.width.equalTo(155)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(partyTitleLabel.snp.right).offset(18)
            make.right.equalToSuperview().inset(19)
        }
    }

}
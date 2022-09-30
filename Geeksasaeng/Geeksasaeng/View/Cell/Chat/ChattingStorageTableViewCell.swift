//
//  ChattingStorageTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/09/29.
//

import UIKit

/* 보관된 채팅 목록 테이블뷰의 셀 */
class ChattingStorageTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ChattingStorageCell"
    
    // MARK: - SubViews
    
    /* 채팅방 이미지 */
    let partyChatImageView = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.image = UIImage(named: "PartyChatImage")
    }
    
    /* 채팅방 제목 label */
    let titleLabel = UILabel().then {
        $0.text = "맛있게 같이 먹어요"
        $0.textColor = .black
        $0.font = .customFont(.neoBold, size: 15)
    }
    
    /* 사람 아이콘 이미지 */
    let peopleImageView = UIImageView().then {
        $0.image = UIImage(named: "PeopleMark")
        $0.tintColor = .init(hex: 0xA8A8A8)
    }
    
    /* 채팅방에 총 몇명이 있었는지 label */
    let totalPeopleNumberLabel = UILabel().then {
        $0.text = "4"
        $0.textColor = .init(hex: 0xA8A8A8)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    /* 배달파티 음식 카테고리 label */
    let categoryLabel = UILabel().then {
        $0.text = "중식"
        $0.textColor = .init(hex: 0xA8A8A8)
        $0.font = .customFont(.neoMedium, size: 13)
    }

    /* 마지막 메세지의 전송 날짜 label */
    let lastReceivedTimeLabel = UILabel().then {
        $0.text = "2022.08.08"
        $0.textColor = .init(hex: 0xA8A8A8)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .gray
        addSubViews()
        setLayouts()
    }
    
    // MARK: - prepareForReuse()
    
    // reuse cell을 사용하기 전에 뷰를 초기화 해주는 것
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Functions
    
    private func addSubViews() {
        [
            partyChatImageView, titleLabel,
            peopleImageView, totalPeopleNumberLabel, categoryLabel, lastReceivedTimeLabel
        ].forEach { self.contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.right.bottom.equalToSuperview()
        }

        partyChatImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(27)
            make.width.height.equalTo(33)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(partyChatImageView)
            make.left.equalTo(partyChatImageView.snp.right).offset(11)
            make.width.equalTo(150) // 넓이 제한 필요 (최대 글자수 11개에 맞게)
        }
        
        peopleImageView.snp.makeConstraints { make in
            make.top.equalTo(partyChatImageView.snp.bottom).offset(13)
            make.left.equalTo(partyChatImageView).offset(5)
            make.width.height.equalTo(13)
        }
        totalPeopleNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleImageView)
            make.left.equalTo(peopleImageView.snp.right).offset(10)
        }
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPeopleNumberLabel)
            make.left.equalTo(totalPeopleNumberLabel.snp.right).offset(24)
        }
        lastReceivedTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.right.equalToSuperview().inset(32)
        }
    }
}

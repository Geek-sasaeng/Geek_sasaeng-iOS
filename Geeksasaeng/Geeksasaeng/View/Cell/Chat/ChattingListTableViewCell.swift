//
//  ChattingListTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit

import SnapKit
import Then

/* 채팅방 목록 셀 */
class ChattingListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ChattingListCell"
    
    /* 채팅방의 가장 최신 메세지 발송 시간 */
    var receivedTimeString = "" {
        didSet {
            receivedTimeLabel.text = receivedTimeString
        }
    }
    
    // 셀이 클릭된 적이 있는지/없는지 여부를 알기 위한 변수
    var isClicked = false
    
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

    /* 채팅방 가장 최근 메세지 label */
    let recentMessageLabel = UILabel().then {
        $0.text = "채팅을 시작해보세요!"
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
    }

    /* 메세지를 받은지 얼마나 됐는지 알려주는 시간 label */
    let receivedTimeLabel = UILabel().then {
        $0.text = "방금"
        $0.textColor = .init(hex: 0xA8A8A8)
        $0.font = .customFont(.neoMedium, size: 11)
    }
    
    /* 안 읽은 메세지가 몇 갠지 알려주는 label */
    let unreadMessageCountLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .customFont(.neoBold, size: 11)
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .init(hex: 0xFCFDFE)
        contentView.backgroundColor = .init(hex: 0xFCFDFE)
        self.superview?.backgroundColor = .init(hex: 0xFCFDFE)
        
        self.selectionStyle = .gray
        addSubViews()
        setLayouts()
    }
    
    // MARK: - prepareForReuse()
    
    // reuse cell을 사용하기 전에 뷰를 초기화 해주는 것
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 초기화
        self.titleLabel.text = ""
        self.recentMessageLabel.text = ""
        self.receivedTimeLabel.text = ""
        self.unreadMessageCountLabel.text = ""
    }

    // MARK: - Functions
    
    private func addSubViews() {[
            partyChatImageView, titleLabel,
            recentMessageLabel, receivedTimeLabel, unreadMessageCountLabel
        ].forEach { self.contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        partyChatImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(33)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(partyChatImageView.snp.top).offset(5)
            make.left.equalTo(partyChatImageView.snp.right).offset(11)
        }
        recentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.width.equalTo(150) // 넓이 제한 필요 (최대 글자수 11개에 맞게)
        }
        // TODO: - receivedTimeLabel 레이아웃 수정 필요해보임
        receivedTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recentMessageLabel)
            make.left.equalTo(recentMessageLabel.snp.right).offset(19)
        }
        unreadMessageCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(receivedTimeLabel)
            make.right.equalToSuperview().inset(7)
        }
    }
}

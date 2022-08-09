//
//  ChattingListTableViewCell.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit
import SnapKit

/* 채팅방 목록 셀 */
class ChattingListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ChattingListCell"
    
    // 셀이 클릭된 적이 있는지/없는지 여부를 알기 위한 변수
    var isClicked = false
    
    // MARK: - SubViews
    
    /* 채팅방 이미지 */
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        // TODO: - 추후에 채팅방 이미지 나오면 연결하기! 지금은 임시 이미지
        imageView.image = UIImage(named: "TempChattingImage")
        return imageView
    }()
    
    /* 채팅방 제목 label */
    let titleLabel: UILabel = {
        let label = UILabel()
        // TODO: - 값 연결
        label.text = "맛있게 같이 먹어요"
        label.textColor = .black
        label.font = .customFont(.neoBold, size: 15)
        return label
    }()

    /* 채팅방 가장 최근 메세지 label */
    let recentMessageLabel: UILabel = {
        let label = UILabel()
        // TODO: - 값 연결
        label.text = "간난단란만반산안잔찬칸까지"    // 칸까지 나오면 성공
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()

    /* 메세지를 받은지 얼마나 됐는지 알려주는 시간 label */
    let receivedTimeLabel: UILabel = {
        let label = UILabel()
        // TODO: - 값 연결
        label.text = "방금"
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 11)
        return label
    }()
    
    /* 안 읽은 메세지가 몇 갠지 알려주는 label */
    let unreadMessageCountLabel: UILabel = {
        let label = UILabel()
        // TODO: - 값 연결
        label.text = "+999"
        label.textColor = .mainColor
        label.font = .customFont(.neoBold, size: 11)
        return label
    }()
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - prepareForReuse()
    
    // reuse cell을 사용하기 전에 뷰를 초기화 해주는 것
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Functions
    
    private func addSubViews() {[
            profileImageView, titleLabel,
            recentMessageLabel, receivedTimeLabel, unreadMessageCountLabel
        ].forEach { self.contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.right.bottom.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(11)
        }
        recentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.left.equalTo(titleLabel)
            make.width.equalTo(150) // 넓이 제한 필요 (최대 글자수 11개에 맞게)
        }
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

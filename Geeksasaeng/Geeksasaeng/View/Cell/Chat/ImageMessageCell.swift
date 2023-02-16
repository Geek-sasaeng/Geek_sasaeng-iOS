//
//  ImageMessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/30.
//

import UIKit
import SnapKit

class ImageMessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ImageMessageCell"

    // 여기서 ChattingVC의 함수를 호출하기 위한 delegate
    var delegate: PresentPopUpViewDelegate?
    var memberId: Int?
    
    // MARK: - SubViews
    
    lazy var leftProfileImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfileImage)))
    }
    let rightProfileImageView = UIImageView()
    let nicknameLabel = UILabel()
    
    let leftImageMessageView = UIView()
    let rightImageMessageView = UIView()
    var leftImageView = UIImageView()
    let rightImageView = UIImageView()
    let rightTimeLabel = UILabel()
    let leftTimeLabel = UILabel()
    let leftUnreadCntLabel = UILabel()
    let rightUnreadCntLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        contentView.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setAttributes()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // reuse 전에 값들을 다 초기화
        leftTimeLabel.text = ""
        rightTimeLabel.text = ""
        
        leftUnreadCntLabel.text = ""
        rightUnreadCntLabel.text = ""
        
        leftImageMessageView.isHidden = false
        rightImageMessageView.isHidden = false
        
        leftProfileImageView.isHidden = false
        rightProfileImageView.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
        
        leftImageView.isHidden = false
        rightImageView.isHidden = false
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            nicknameLabel,
            leftProfileImageView, rightProfileImageView,
            leftImageMessageView, rightImageMessageView,
            rightTimeLabel, leftTimeLabel,
            leftUnreadCntLabel, rightUnreadCntLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        leftImageMessageView.addSubview(leftImageView)
        rightImageMessageView.addSubview(rightImageView)
    }
    
    private func setLayouts() {
        leftProfileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(23)
        }
        
        rightProfileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(23)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(leftProfileImageView.snp.right).offset(10)
            make.right.equalTo(rightProfileImageView.snp.left).offset(-10)
        }
        
        leftImageMessageView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.left.equalTo(leftProfileImageView.snp.right).offset(10)
            make.width.equalTo(155)
            make.height.equalTo(154)
        }
        
        rightImageMessageView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.right.equalTo(rightProfileImageView.snp.left).offset(-10)
            make.width.equalTo(155)
            make.height.equalTo(154)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(10)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(10)
        }
        
        leftTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftImageMessageView.snp.bottom)
            make.left.equalTo(leftImageMessageView.snp.right).offset(3)
        }
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightImageMessageView.snp.bottom)
            make.right.equalTo(rightImageMessageView.snp.left).offset(-3)
        }
        
        leftUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftTimeLabel.snp.centerY)
            make.left.equalTo(leftTimeLabel.snp.right).offset(6)
        }
        
        rightUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightTimeLabel.snp.centerY)
            make.right.equalTo(rightTimeLabel.snp.left).offset(-6)
        }
    }
    
    private func setAttributes() {
        contentView.isUserInteractionEnabled = true
        
        nicknameLabel.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoBold, size: 11))
        rightTimeLabel.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        leftTimeLabel.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
        [leftImageMessageView, rightImageMessageView].forEach {
            $0.backgroundColor = .init(hex: 0xEFEFEF)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
        }
        
        [ leftImageView, rightImageView, leftImageMessageView, rightImageMessageView ].forEach {
            $0.isUserInteractionEnabled = true
        }
        
        [leftProfileImageView, rightProfileImageView].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
        
        [leftImageView, rightImageView].forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
        }
        
        [leftUnreadCntLabel, rightUnreadCntLabel].forEach {
            $0.setTextAndColorAndFont(textColor: .mainColor, font: .customFont(.neoMedium, size: 12))
        }
        
        if leftUnreadCntLabel.text == "0" {
            leftUnreadCntLabel.text = ""
        }
        if rightUnreadCntLabel.text == "0" {
            rightUnreadCntLabel.text = ""
        }
    }
    
    // MARK: - @objc Functions
    
    /* 상대 유저 프로필 클릭 시 실행되는 함수
     1. ChattingVC에서 해당 유저의 정보를 받아온다
     2. 성공 시 팝업뷰를 띄워준다
     */
    @objc
    private func tapProfileImage() {
        guard let profileImg = self.leftImageView.image else { return }
        // 서버로부터 해당 유저의 정보를 받아온다.
        delegate?.getInfoMember(memberId: memberId ?? 0, profileImg: profileImg)
    }
}

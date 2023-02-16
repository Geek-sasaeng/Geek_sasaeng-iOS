//
//  MessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit
import Then

class MessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // 여기서 ChattingVC의 함수를 호출하기 위한 delegate
    var delegate: PresentPopUpViewDelegate?
    var memberId: Int?
    
    // MARK: - SubViews
    
    lazy var leftImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfileImage)))
    }
    let rightImageView = UIImageView()
    let nicknameLabel = UILabel()
    
    let leftUnreadCntLabel = UILabel()
    let rightUnreadCntLabel = UILabel()
    let leftTimeLabel = UILabel()
    let rightTimeLabel = UILabel()
    let leftMessageLabel = PaddingLabel()
    let rightMessageLabel = PaddingLabel()
    
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
        leftMessageLabel.text = ""
        rightMessageLabel.text = ""
        
        leftTimeLabel.text = ""
        rightTimeLabel.text = ""
        
        leftUnreadCntLabel.text = ""
        rightUnreadCntLabel.text = ""
        
        leftMessageLabel.isHidden = false
        rightMessageLabel.isHidden = false
        
        leftTimeLabel.isHidden = false
        rightTimeLabel.isHidden = false
        
        leftImageView.isHidden = false
        rightImageView.isHidden = false
        
        leftUnreadCntLabel.isHidden = false
        rightUnreadCntLabel.isHidden = false
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            leftImageView, rightImageView,
            nicknameLabel,
            leftMessageLabel, rightMessageLabel,
            leftTimeLabel, rightTimeLabel,
            leftUnreadCntLabel, rightUnreadCntLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.right.bottom.equalToSuperview()
        }
        
        leftMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.left.equalTo(leftImageView.snp.right).offset(10)
        }
        
        rightMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
        
        leftTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(leftMessageLabel.snp.bottom)
            make.left.equalTo(leftMessageLabel.snp.right).offset(3)
        }
        
        rightTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rightMessageLabel.snp.bottom)
            make.right.equalTo(rightMessageLabel.snp.left).offset(-3)
        }
        
        leftUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftTimeLabel.snp.centerY)
            make.left.equalTo(leftTimeLabel.snp.right).offset(6)
        }
        
        rightUnreadCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightTimeLabel.snp.centerY)
            make.right.equalTo(rightTimeLabel.snp.left).offset(-6)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(23)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(23)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
    }
    
    private func setAttributes() {
        [leftImageView, rightImageView].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
        
        nicknameLabel.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoBold, size: 11))
        
        [leftMessageLabel, rightMessageLabel].forEach {
            $0.paddingTop = 10
            $0.paddingBottom = 10
            $0.paddingLeft = 18
            $0.paddingRight = 18
            $0.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoMedium, size: 15))
            $0.numberOfLines = 0
            $0.backgroundColor = .init(hex: 0xEFEFEF)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
            $0.textAlignment = .left
            $0.lineBreakMode = .byCharWrapping
            $0.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.569
            $0.sizeToFit()
            $0.setNeedsLayout()
        }
        
        [leftTimeLabel, rightTimeLabel].forEach {
            $0.setTextAndColorAndFont(textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 12))
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
    
    /* 상대 유저 프로필 클릭시 실행 -> ChattingVC에서 팝업뷰를 띄워준다 */
    @objc
    private func tapProfileImage() {
        guard let profileImg = self.leftImageView.image else { return }
        delegate?.getInfoMember(memberId: memberId ?? 0, profileImg: profileImg)
    }
}

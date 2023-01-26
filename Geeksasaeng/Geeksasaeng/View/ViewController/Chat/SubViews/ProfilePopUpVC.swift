//
//  ProfilePopUpVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/09/29.
//

import Kingfisher
import UIKit

/* 상대 프로필 이미지 클릭시 뜨는 사용자 정보 뷰 */
class ProfilePopUpViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: PushReportUserDelegate?
    var profileImage: UIImage?
    var nickNameStr: String?
    
    // MARK: - SubViews
    
    var blurView: UIVisualEffectView?
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 10
    }
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 72 / 2
        $0.clipsToBounds = true
    }
    
    let stageImageView = UIImageView().then {
        $0.image = UIImage(named: "UserStage")
    }
    let infoLabel = UILabel().then {
        // TODO: - 값 연결
        $0.text = "신입생  ㅣ  파티원"
        $0.font = .customFont(.neoBold, size: 13)
        $0.textColor = .mainColor
    }
    let nickNameLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 18)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    lazy var borderView = UIView().then {
        $0.layer.cornerRadius = 7
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0xEFEFEF).cgColor
        $0.isUserInteractionEnabled = true
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapUserReportView))
        $0.addGestureRecognizer(viewTapGesture)
    }
    let reportImageView = UIImageView().then {
        $0.image = UIImage(named: "UserReport")
    }
    let reportLabel = UILabel().then {
        $0.text = "신고하기"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 15)
    }
    lazy var reportStackView = UIStackView(arrangedSubviews: [reportImageView, reportLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView = setDarkBlurView()
        
        addSubviews()
        setLayouts()
        setAttributes()
    }
    
    // MARK: - Initialization
    
    init(profileImage: UIImage, nickNameStr: String) {
        super.init(nibName: nil, bundle: nil)
        self.profileImage = profileImage
        self.nickNameStr = nickNameStr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
        // 학교 선택 리스트뷰가 확장되었을 때, universityListView 밖의 화면을 클릭 시 뷰가 사라지도록 설정함
        if let touch = touches.first, touch.view == blurView {
            dismiss(animated: true)
        }
    }
    
    private func addSubviews() {
        [
            blurView!,
            containerView,
            profileImageView
        ].forEach { view.addSubview($0) }
        [
            stageImageView,
            infoLabel,
            nickNameLabel,
            borderView
        ].forEach { containerView.addSubview($0) }
        borderView.addSubview(reportStackView)
    }

    private func setLayouts() {
        blurView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(196 + 22)
            make.bottom.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        stageImageView.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel)
            make.right.equalTo(infoLabel.snp.left).offset(-4)
            make.width.equalTo(9)
            make.height.equalTo(13)
        }
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(infoLabel)
            make.top.equalTo(infoLabel.snp.bottom).offset(18)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(38)
            make.left.right.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(22)
        }
        reportImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(22)
        }
        reportStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setAttributes() {
        profileImageView.image = profileImage
        nickNameLabel.text = nickNameStr
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapUserReportView() {
        // present로 띄운 이 화면을 dismiss시키고
        dismiss(animated: true)
        // navigation을 쓴 chattingVC를 통해 ReportUserVC를 push한다!
        delegate?.pushReportUserVC()
    }
}

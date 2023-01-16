//
//  ProfilePopUpViewController.swift
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
    var profileUrl: URL?
    
    // MARK: - SubViews
    
    var blurView: UIVisualEffectView?
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 10
    }
    let profileImageContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 72 / 2
    }
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 66 / 2
        $0.clipsToBounds = true
    }
    let roleLabel = UILabel().then {
        $0.text = "파티원"
        $0.font = .customFont(.neoMedium, size: 11)
        $0.textColor = .init(hex: 0x636363)
    }
    let nickNameLabel = UILabel().then {
        $0.text = "같이먹자냠냠"
        $0.font = .customFont(.neoBold, size: 18)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    let lineView = UIView().then {
        $0.backgroundColor = .init(hex: 0xEFEFEF)
    }
    let reportImageView = UIImageView().then {
        $0.image = UIImage(named: "UserReport")
    }
    lazy var reportLabel = UIButton().then {
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.init(hex: 0x2F2F2F), for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 15)
        $0.addTarget(self, action: #selector(tapUserReportButton), for: .touchUpInside)
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
    
    init(profileUrl: URL) {
        super.init(nibName: nil, bundle: nil)
        self.profileUrl = profileUrl
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
            profileImageContainerView,
            profileImageView
        ].forEach { view.addSubview($0) }
        [
            roleLabel,
            nickNameLabel,
            lineView,
            reportStackView
        ].forEach { containerView.addSubview($0) }
    }

    private func setLayouts() {
        blurView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(212)
            make.bottom.equalToSuperview()
        }
        profileImageContainerView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(profileImageContainerView)
            make.width.height.equalTo(66)
        }
        roleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(roleLabel)
            make.top.equalTo(roleLabel.snp.bottom).offset(10)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(19)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(25)
            make.height.equalTo(1.7)
        }
        reportImageView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(17)
        }
        reportStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(25)
        }
    }
    
    private func setAttributes() {
        profileImageView.kf.setImage(with: profileUrl)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapUserReportButton() {
        // present로 띄운 이 화면을 dismiss시키고
        dismiss(animated: true)
        // navigation을 쓴 chattingVC를 통해 ReportUserVC를 push한다!
        delegate?.pushReportUserVC()
    }
}

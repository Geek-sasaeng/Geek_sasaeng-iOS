//
//  ProfileVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/16.
//

import UIKit

import SnapKit
import Then
import Kingfisher
import KakaoSDKTalk
import SafariServices

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    var ongoingPartyList: [UserInfoPartiesModel] = []
    var naverLoginVM = naverLoginViewModel()
    var safariVC: SFSafariViewController?
    
    
    // MARK: - SubViews
    
    /* MyInfo View가 올라가는 background View */
    let backgroundView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    
    /* grade & 복학까지 ~ 가 들어있는 view */
    let gradeView = UIView().then { view in
        view.backgroundColor = .mainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // TODO: - gradeLabel, remainLabel getUserInfo API에서 불러와야 함
        let gradeLabel = UILabel().then {
            $0.font = .customFont(.neoBold, size: 12)
            $0.textColor = .white
            $0.text = "신입생"
        }
        let separateImageView = UIImageView(image: UIImage(named: "MyInfoSeparateIcon"))
        let remainLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 12)
            $0.textColor = .white
            $0.text = "복학까지 5학점 남았어요"
        }
        let arrowImageView = UIImageView(image: UIImage(named: "MyInfoArrowIcon"))
        
        [ gradeLabel, separateImageView, remainLabel, arrowImageView ].forEach {
            view.addSubview($0)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        separateImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(gradeLabel.snp.right).offset(10)
        }
        remainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(separateImageView.snp.right).offset(10)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(remainLabel.snp.right).offset(10)
        }
    }
    /* 내 정보 view */
    lazy var myInfoView = UIView().then { view in
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.setViewShadow(shadowOpacity: 1, shadowRadius: 7)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMyInfoView))
        view.addGestureRecognizer(tapGesture)
        
        let heartImageView = UIImageView(image: UIImage(named: "MyInfoCardIcon"))
        let nicknameLabel = UILabel().then {
            $0.font = .customFont(.neoBold, size: 20)
        }
        let universityLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .init(hex: 0x636363)
        }
        let dormitoryLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .init(hex: 0x636363)
        }
        let profileImageView = UIImageView().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 54
        }
        
        UserInfoAPI.getUserInfo { isSuccess, result in
            if isSuccess {
                nicknameLabel.text = result.nickname
                universityLabel.text = result.universityName
                dormitoryLabel.text = result.dormitoryName
                
                let url = URL(string: result.profileImgUrl!)
                profileImageView.kf.setImage(with: url)
            }
        }
        
        [ heartImageView, nicknameLabel, universityLabel, dormitoryLabel, profileImageView ].forEach {
            view.addSubview($0)
        }
        
        heartImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(heartImageView.snp.top)
            make.left.equalTo(heartImageView.snp.right).offset(5)
        }
        universityLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.left.equalTo(nicknameLabel.snp.left)
        }
        dormitoryLabel.snp.makeConstraints { make in
            make.top.equalTo(universityLabel.snp.bottom).offset(10)
            make.left.equalTo(universityLabel.snp.left)
        }
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(108)
        }
    }
    
    // 나의 활동 보기 옆의 화살표 버튼
    lazy var myActivityArrowButton = UIButton().then {
        $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
        $0.addTarget(self, action: #selector(tapMyActivityArrowButton), for: .touchUpInside)
    }
    
    /* 나의 활동 view */
    lazy var myActivityView = UIView().then { view in
        let showMyActivityLabel = UILabel().then {
            $0.text = "나의 활동 보기"
            $0.font = .customFont(.neoMedium, size: 15)
        }
        
        [ showMyActivityLabel, myActivityArrowButton].forEach {
            view.addSubview($0)
        }
        
        showMyActivityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(15)
        }
        myActivityArrowButton.snp.makeConstraints { make in
            make.top.equalTo(showMyActivityLabel.snp.top)
            make.right.equalToSuperview().inset(15)
        }
        
        UserInfoAPI.getUserInfo { isSuccess, result in
            if isSuccess {
                let stackView = UIStackView().then {
                    $0.axis = .horizontal
                    $0.distribution = .fillEqually
                    $0.alignment = .center
                    $0.spacing = 10
                }
                
                result.parties?.forEach {
                    stackView.addArrangedSubview(self.createStackViewElement(title: $0.title!, createdAt: String($0.createdAt!.prefix(10))))
                }
                if result.parties?.count == 1 {
                    stackView.addArrangedSubview(self.createEmptyStackViewElement())
                    stackView.addArrangedSubview(self.createEmptyStackViewElement())
                } else if result.parties?.count == 2 {
                    stackView.addArrangedSubview(self.createEmptyStackViewElement())
                }
                
                view.addSubview(stackView)
                stackView.snp.makeConstraints { make in
                    make.top.equalTo(showMyActivityLabel.snp.bottom).offset(15)
                    make.left.right.equalToSuperview().inset(10)
                }
            }
        }
        
    }
    
    /* 구분선 View */
    let separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    let firstLineView = UIView()
    let secondLineView = UIView()
    let thirdLineView = UIView()
    
    /* 나의 정보 수정, 문의하기, 이용 약관 보기, 로그아웃 */
    let editMyInfoLabel = UILabel().then { $0.text = "나의 정보 수정" }
    let contactUsLabel = UILabel().then { $0.text = "문의하기" }
    let termsOfUseLabel = UILabel().then { $0.text = "이용 약관 보기" }
    let logoutLabel = UILabel().then { $0.text = "로그아웃"}
    
    lazy var withdrawalMembershipButton = UIButton().then {
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.makeBottomLine(color: 0xA8A8A8, width: 48, height: 1, offsetToTop: -8)
        $0.setTitle("회원탈퇴", for: .normal)
        $0.addTarget(self, action: #selector(tapWithdrawalMembershipButton), for: .touchUpInside)
    }
    
    // 나의 정보 수정, 문의하기, 이용 약관 보기, 로그아웃 옆의 화살표 버튼
    let editMyInfoArrowButton = UIButton()
    let contactUsArrowButton = UIButton()
    let termsOfUseArrowButton = UIButton()
    let logoutArrowButton = UIButton()
    
    lazy var logoutView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "로그아웃"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "서비스 사용이 제한되며,\n로그인이 필요해요.\n로그아웃을 진행할까요?"
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapLogoutConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
    }
    
    lazy var withdrawalMembershipView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "회원탈퇴"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "긱사생 서비스를 더 이상\n이용할 수 없어요.\n탈퇴를 진행할까요?"
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapWithdrawalMembershipConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
    }
    
    var visualEffectView: UIVisualEffectView?

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributes()
        
        setUserInfo()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setUserInfo() {
        UserInfoAPI.getUserInfo { isSuccess, result in
            if isSuccess {
                let url = URL(string: result.profileImgUrl!)
//                self.profileImageView.kf.setImage(with: url)
//                self.degreeLabel.text = result.dormitoryName
//                self.univLabel.text = result.universityName
//                self.nickNameLabel.text = result.nickname
                self.ongoingPartyList = result.parties!
            }
        }
    }
    
    private func setAttributes() {
        /* view */
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapViewController))
        view.addGestureRecognizer(gesture)
        
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 정보"
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "Bell"), style: .plain, target: self, action: #selector(tapBellButton)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        /* 서비스 labels Attrs 설정 */
        [ editMyInfoLabel, contactUsLabel, termsOfUseLabel, logoutLabel ].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x2F2F2F)
        }
        
        /* 구분선 설정 */
        [firstLineView, secondLineView, thirdLineView].forEach {
            $0.backgroundColor = .init(hex: 0xF8F8F8)
        }
        
        /* 화살표 버튼들 */
        [ editMyInfoArrowButton, contactUsArrowButton, termsOfUseArrowButton, logoutArrowButton ].forEach {
            $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
        }
        
        /* 타겟 설정 */
        editMyInfoArrowButton.addTarget(self, action: #selector(tapEditMyInfoButton), for: .touchUpInside)
        logoutArrowButton.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
        contactUsArrowButton.addTarget(self, action: #selector(tapContactUsArrowButton), for: .touchUpInside)
    }
    
    private func createBlurView() {
        if visualEffectView == nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            visualEffectView.layer.opacity = 0.6
            visualEffectView.frame = view.frame
            visualEffectView.isUserInteractionEnabled = false
            view.addSubview(visualEffectView)
            self.visualEffectView = visualEffectView
        }
    }
    
    private func createStackViewElement(title: String, createdAt: String) -> UIView {
        let activityView = UIView().then { view in
            view.backgroundColor = .white
            view.layer.masksToBounds = false
            view.layer.cornerRadius = 5
            view.layer.borderColor = UIColor(hex: 0xFFFFFF).cgColor
            view.layer.borderWidth = 1
            view.setViewShadow(shadowOpacity: 1, shadowRadius: 4)
            
            let categoryLabel = UILabel().then {
                $0.text = "배달파티"
                $0.textColor = .mainColor
                $0.font = .customFont(.neoRegular, size: 11)
            }
            let titleLabel = UILabel().then {
                $0.text = title
                $0.font = .customFont(.neoBold, size: 13)
            }
            let createdAtLabel = UILabel().then {
                $0.text = createdAt
                $0.font = .customFont(.neoMedium, size: 11)
                $0.textColor = .init(hex: 0xA8A8A8)
            }
            let deliveryPartyImageView = UIImageView(image: UIImage(named: "DeliveryPartyIcon"))
            
            [ categoryLabel, titleLabel, createdAtLabel, deliveryPartyImageView].forEach {
                view.addSubview($0)
            }
            
            categoryLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(5)
                make.left.equalToSuperview().inset(5)
            }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(categoryLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().inset(5)
            }
            createdAtLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().inset(5)
            }
            deliveryPartyImageView.snp.makeConstraints { make in
                make.bottom.right.equalToSuperview()
            }
        }
        
        activityView.snp.makeConstraints { make in
            make.width.equalTo(106)
            make.height.equalTo(84)
        }
        
        return activityView
    }
    
    private func createEmptyStackViewElement() -> UIView {
        return UIView().then {
            $0.snp.makeConstraints { make in
                make.width.equalTo(106)
                make.height.equalTo(84)
            }
        }
    }
    
    private func addSubViews() {
        myInfoView.addSubview(gradeView)
        backgroundView.addSubview(myInfoView)
        
        [
            backgroundView,
            myActivityView,
            separateView,
            editMyInfoLabel, editMyInfoArrowButton, firstLineView,
            contactUsLabel, contactUsArrowButton, secondLineView,
            termsOfUseLabel, termsOfUseArrowButton, thirdLineView,
            logoutLabel, logoutArrowButton,
            withdrawalMembershipButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        gradeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        myInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(166)
        }
        
        myActivityView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(160)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(myActivityView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }

        editMyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        firstLineView.snp.makeConstraints { make in
            make.top.equalTo(editMyInfoLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(19)
            make.height.equalTo(1)
        }

        contactUsLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        secondLineView.snp.makeConstraints { make in
            make.top.equalTo(contactUsLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        
        termsOfUseLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        thirdLineView.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        
        logoutLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }

        editMyInfoArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(editMyInfoLabel)
            make.right.equalToSuperview().inset(31)
        }
        contactUsArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(contactUsLabel)
            make.right.equalToSuperview().inset(31)
        }
        termsOfUseArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(termsOfUseLabel)
            make.right.equalToSuperview().inset(31)
        }
        logoutArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutLabel)
            make.right.equalToSuperview().inset(31)
        }
        
        withdrawalMembershipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoutLabel.snp.bottom).offset(100)
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapMyInfoView() {
        let profileCardVC = ProfileCardViewController()
        profileCardVC.modalPresentationStyle = .overFullScreen
        profileCardVC.modalTransitionStyle = .crossDissolve
        self.present(profileCardVC, animated: true)
    }
    
    // 나의 활동 목록 화면으로 이동
    @objc
    private func tapMyActivityArrowButton() {
        let activityListVC = ActivityListViewController()
        activityListVC.modalPresentationStyle = .overFullScreen
        activityListVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(activityListVC, animated: true)
    }
    
    @objc
    private func tapBellButton() {
        print("DEBUG: 종 버튼 클릭")
    }
    
    @objc
    private func tapPencilButton() {
        print("DEBUG: 연필 버튼 클릭")
    }
    
    @objc
    private func tapEditMyInfoButton() {
        let editMyInfoVC = EditMyInfoViewController()
        navigationController?.pushViewController(editMyInfoVC, animated: true)
    }
    
    @objc
    private func tapContactUsArrowButton() {
        self.safariVC = SFSafariViewController(url: KakaoSDKTalk.TalkApi.shared.makeUrlForChannelChat(channelPublicId: "_Sxolhxj")!)
        guard self.safariVC != nil else { return }
        
        self.safariVC?.modalTransitionStyle = .crossDissolve
        self.safariVC?.modalPresentationStyle = .overCurrentContext
        self.present(self.safariVC!, animated: true)
    }
    
    @objc
    private func tapLogoutButton() {
        if visualEffectView == nil {
            createBlurView()
            view.addSubview(logoutView)
            logoutView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(256)
                make.height.equalTo(236)
            }
        }
    }
    
    @objc
    private func tapWithdrawalMembershipButton() {
        if visualEffectView == nil {
            createBlurView()
            view.addSubview(withdrawalMembershipView)
            withdrawalMembershipView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(256)
                make.height.equalTo(236)
            }
        }
    }
    
    @objc
    private func tapXButton() {
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
        logoutView.removeFromSuperview()
        withdrawalMembershipView.removeFromSuperview()
    }
    
    @objc
    private func tapLogoutConfirmButton() {
        // TODO: - 로그아웃 api 연동
        UserDefaults.standard.set("nil", forKey: "jwt") // delete local jwt
        naverLoginVM.resetToken() // delete naver login token
        
        let rootVC = LoginViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func tapWithdrawalMembershipConfirmButton() {
        print("회원탈퇴")
        // TODO: - 회원탈퇴 처리
    }
    
    @objc
    private func tapViewController() {
        if visualEffectView != nil {
            visualEffectView?.removeFromSuperview()
            visualEffectView = nil
            logoutView.removeFromSuperview()
            withdrawalMembershipView.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(""), object: "true")
        }
    }
}


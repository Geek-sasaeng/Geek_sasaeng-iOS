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

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    var ongoingPartyList: [UserInfoPartiesModel] = []
    
    
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
    
    /* 나의 활동 view */
    lazy var myActivityView = UIView().then { view in
        let showMyActivityLabel = UILabel().then {
            $0.text = "나의 활동 보기"
            $0.font = .customFont(.neoMedium, size: 15)
        }
        let arrowImageView = UIImageView(image: UIImage(named: "ServiceArrow"))
        
        [ showMyActivityLabel, arrowImageView].forEach {
            view.addSubview($0)
        }
        
        showMyActivityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(15)
        }
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(showMyActivityLabel.snp.top)
            make.right.equalToSuperview().inset(15)
        }
        
        UserInfoAPI.getUserInfo { isSuccess, result in
            if isSuccess {
                let stackView = UIStackView().then {
                    $0.sizeToFit()
                    $0.layoutIfNeeded()
                    $0.distribution = .fillProportionally
                    $0.alignment = .leading
                }
                
                result.parties?.forEach {
                    stackView.addArrangedSubview(self.createStackViewElement(title: $0.title!, createdAt: $0.createdAt!))
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
//        $0.addTarget(self, action: #selector(tapWithdrawalMembershipButton), for: .touchUpInside)
    }
    
    // 나의 정보 수정, 문의하기, 이용 약관 보기, 로그아웃 옆의 화살표 버튼
    let editMyInfoArrowButton = UIButton()
    let contactUsArrowButton = UIButton()
    let termsOfUseArrowButton = UIButton()
    let logoutArrowButton = UIButton()

    
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
    }
    
    private func createStackViewElement(title: String, createdAt: String) -> UIView {
        let activityView = UIView().then { view in
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 5
            view.layer.borderColor = UIColor(hex: 0xFFFFFF).cgColor
            view.layer.borderWidth = 1
            
            view.backgroundColor = .red
            
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
}


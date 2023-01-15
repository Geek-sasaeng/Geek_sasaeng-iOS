//
//  ProfileCardViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/15.
//

import UIKit

/* 상대 프로필 이미지 클릭시 뜨는 사용자 정보 뷰 */
class ProfileCardViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - SubViews
    
    var blurView: UIVisualEffectView?
    
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
    
    /* 아이디, 이메일, 전화번호, 가입일 View */
    let etcInfoView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF1F5F9)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        let idLabel = UILabel()
        let emailLabel = UILabel()
        let phoneNumberLabel = UILabel()
        [ idLabel, emailLabel, phoneNumberLabel ].forEach {
            $0.font = .customFont(.neoMedium, size: 12)
            $0.textColor = .init(hex: 0xA8A8A8)
        }
        idLabel.text = "아이디"
        emailLabel.text = "이메일"
        phoneNumberLabel.text = "전화번호"
        
        let idDataLabel = UILabel()
        let emailDataLabel = UILabel()
        let phoneNumberDataLabel = UILabel()
        [ idDataLabel, emailDataLabel, phoneNumberDataLabel ].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x636363)
        }
        
        let signUpDateLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 12)
            $0.textColor = .init(hex: 0xA8A8A8)
        }
        
        UserInfoAPI.getUserInfo { isSuccess, result in
            if isSuccess {
                idDataLabel.text = result.nickname
                emailDataLabel.text = result.emailAddress
                phoneNumberDataLabel.text = result.phoneNumber
//                signUpDateLabel.text = "가입일 | " + result.createdAt!
                let endIdx = result.createdAt!.index(result.createdAt!.startIndex, offsetBy: 10)
                signUpDateLabel.text = "가입일  |  " + result.createdAt![...endIdx]
            }
        }
        
        [
            idLabel, idDataLabel,
            emailLabel, emailDataLabel,
            phoneNumberLabel, phoneNumberDataLabel,
            signUpDateLabel
        ].forEach {
            view.addSubview($0)
        }
        
        idLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(45)
            make.top.equalToSuperview().inset(30)
        }
        idDataLabel.snp.makeConstraints { make in
            make.left.equalTo(idLabel.snp.left)
            make.top.equalTo(idLabel.snp.bottom).offset(9)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(idDataLabel.snp.left)
            make.top.equalTo(idDataLabel.snp.bottom).offset(24)
        }
        emailDataLabel.snp.makeConstraints { make in
            make.left.equalTo(emailLabel.snp.left)
            make.top.equalTo(emailLabel.snp.bottom).offset(9)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(emailDataLabel.snp.left)
            make.top.equalTo(emailDataLabel.snp.bottom).offset(24)
        }
        phoneNumberDataLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneNumberLabel.snp.left)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(9)
        }
        
        signUpDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneNumberDataLabel.snp.bottom).offset(53)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView = setDarkBlurView()
        
        addSubviews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
        if let touch = touches.first, touch.view == blurView {
            dismiss(animated: true)
        }
    }
    
    private func addSubviews() {
        myInfoView.addSubview(gradeView)
        [
            blurView!,
            etcInfoView,
            myInfoView,
        ].forEach {
            view.addSubview($0)
        }
    }

    private func setLayouts() {
        blurView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradeView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(36)
        }
        
        myInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(166)
            make.top.equalToSuperview().inset(100)
        }
        
        etcInfoView.snp.makeConstraints { make in
            make.top.equalTo(myInfoView.snp.bottom).offset(-10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(300)
        }
    }
}

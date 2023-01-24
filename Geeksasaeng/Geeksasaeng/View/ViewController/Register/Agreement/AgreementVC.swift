//
//  AgreementVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/06.
//

import UIKit
import SnapKit

class AgreementViewController: UIViewController {
    
    // MARK: - SubViews
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        return view
    }()
    var progressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoTop"))
        return imageView
    }()
    var remainIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoBottom"))
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "긱사생에 오신 것을\n환영합니다"
        label.font = .customFont(.neoBold, size: 32)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var wholeAgreementCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        return button
    }()
    let termsOfUseAgreementCheckBox = UIButton()
    let personalInfoAgreementCheckBox = UIButton()
    
    lazy var wholeAgreementButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 약관 전체동의", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 18)
        return button
    }()
    
    lazy var termsOfUseAgreementButton: UIButton = {
        let button = UIButton()
        let text = " (필수) 서비스 이용약관 동의"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.mainColor, range: (text as NSString).range(of: "(필수)"))
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    lazy var personalInfoAgreementButton: UIButton = {
        let button = UIButton()
        let text = " (필수) 개인정보 수집 및 이용동의"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.mainColor, range: (text as NSString).range(of: "(필수)"))
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    lazy var termsOfUseAgreementArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AgreementArrow"), for: .normal)
        button.addTarget(self, action: #selector(tapTermsOfUseAgreementArrow), for: .touchUpInside)
        return button
    }()
    lazy var personalInfoAgreementArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AgreementArrow"), for: .normal)
        button.addTarget(self, action: #selector(tapPersonalInfoAgreementArrow), for: .touchUpInside)
        return button
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    /* 이전 화면에서 받아온 데이터들 */
    var pwCheckData: String? = nil
    var emailId: Int? = nil
    var idData: String? = nil
    var nickNameData: String? = nil
    var pwData: String? = nil
    var phoneNumberId: Int? = nil
    var university: String? = nil
    
    var isFromNaverRegister = false
    var accessToken: String?
    var email: String?
    
    var isAgreeTermsOfUse = false
    var isAgreePersonalInfo = false
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        addRightSwipe()
        setAttributes()
    }
    
    // MARK: - Initialization
    
    /* 일반 회원가입용 */
    init(idData: String, pwData: String, pwCheckData: String, nickNameData: String, university: String, emailId: Int, phoneNumberId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.idData = idData
        self.pwData = pwData
        self.pwCheckData = pwCheckData
        self.nickNameData = nickNameData
        self.university = university
        self.emailId = emailId
        self.phoneNumberId = phoneNumberId
    }
    
    /* 네이버 회원가입용 */
    init(isFromNaverRegister: Bool, accessToken: String, nickNameData: String, university: String, email: String) {
        super.init(nibName: nil, bundle: nil)
        self.isFromNaverRegister = isFromNaverRegister
        self.accessToken = accessToken
        self.nickNameData = nickNameData
        self.university = university
        self.email = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func addSubViews() {
        [
            progressBar, remainBar, progressIcon, remainIcon,
            welcomeLabel,
            wholeAgreementCheckBox, wholeAgreementButton,
            separateView,
            termsOfUseAgreementCheckBox, termsOfUseAgreementButton,
            personalInfoAgreementCheckBox, personalInfoAgreementButton,
            termsOfUseAgreementArrow, personalInfoAgreementArrow,
            completeButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(UIScreen.main.bounds.width - 67)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(25)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(16)
            make.top.equalTo(progressBar.snp.top).offset(-4)
            make.right.equalTo(remainIcon.snp.right).offset(-6)
        }
        
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(31)
            make.top.equalTo(progressIcon.snp.top).offset(-2.19)
            make.right.equalTo(remainBar.snp.right)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(183)
            make.left.equalToSuperview().inset(23)
        }
        
        wholeAgreementCheckBox.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(106)
            make.left.equalToSuperview().inset(23)
        }
        
        wholeAgreementButton.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreementCheckBox.snp.top).offset(-5)
            make.left.equalTo(wholeAgreementCheckBox.snp.right).offset(9)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreementButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        
        termsOfUseAgreementCheckBox.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(39)
            make.left.equalToSuperview().inset(23)
        }
        
        termsOfUseAgreementButton.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseAgreementCheckBox.snp.top).offset(-5)
            make.left.equalTo(termsOfUseAgreementCheckBox.snp.right).offset(9)
        }
        
        personalInfoAgreementCheckBox.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseAgreementButton.snp.bottom).offset(44)
            make.left.equalToSuperview().inset(23)
        }
        
        personalInfoAgreementButton.snp.makeConstraints { make in
            make.top.equalTo(personalInfoAgreementCheckBox.snp.top).offset(-5)
            make.left.equalTo(personalInfoAgreementCheckBox.snp.right).offset(9)
        }
        
        termsOfUseAgreementArrow.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseAgreementButton.snp.top).offset(5)
            make.right.equalToSuperview().inset(32)
        }
        
        personalInfoAgreementArrow.snp.makeConstraints { make in
            make.top.equalTo(personalInfoAgreementButton.snp.top).offset(5)
            make.right.equalToSuperview().inset(32)
        }
        
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    private func setAttributes() {
        [progressBar, remainBar].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 1.5
        }
        
        [termsOfUseAgreementCheckBox, personalInfoAgreementCheckBox].forEach {
            $0.setImage(UIImage(systemName: "square"), for: .normal)
            $0.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
            $0.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        }
        
        [termsOfUseAgreementButton, personalInfoAgreementButton].forEach {
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .customFont(.neoRegular, size: 18)
        }
    }

    /* 회원가입 Request 보내는 함수 */
    @objc private func tapCompleteButton() {
        // TODO: - 네이버 회원가입 수정 필요
        if isFromNaverRegister { // naver 회원가입인 경우
            if let email = email,
               let nickname = self.nickNameData,
               let universityName = self.university,
               let accessToken = self.accessToken {
                let input = NaverRegisterInput(accessToken: accessToken, email: email, informationAgreeStatus: "Y", nickname: nickname, universityName: universityName)
                RegisterAPI.registerUserFromNaver(input) { isSuccess, result in
                    switch isSuccess {
                    case .success:
                        // 네이버 회원가입은 자동 로그인이 default
                        UserDefaults.standard.set(result?.jwt, forKey: "jwt")
                        LoginModel.jwt = result?.jwt
                        LoginModel.memberId = result?.memberId
                        self.showDomitoryView()
                    case .onlyRequestSuccess:
                        print("onlyRequestSuccess")
                    case .failure:
                        print("Failure")
                    }
                    
                }
            }
        } else { // 일반 회원가입인 경우
            // Request 생성.
            // 최종적으로 데이터 전달
            if let idData = self.idData,
               let pwData = self.pwData,
               let pwCheckData = self.pwCheckData,
               let nickNameData = self.nickNameData,
               let univ = self.university,
               let emailId = self.emailId,
               let phoneNumberId = self.phoneNumberId
            {
                let agreeStatus = (self.isAgreeTermsOfUse && self.isAgreePersonalInfo) ? "Y" : "N"
                let input = RegisterInput(checkPassword: pwCheckData,
                                          emailId: emailId,
                                          informationAgreeStatus: agreeStatus,
                                          loginId: idData,
                                          nickname: nickNameData,
                                          password: pwData,
                                          phoneNumberId: phoneNumberId,
                                          universityName: univ)
                
                RegisterAPI.registerUser(input) { isSuccess in
                    switch isSuccess {
                    case .success:
                        self.showLoginView()
                    case .onlyRequestSuccess:
                        print("onlyRequestSuccess")
                    case .failure:
                        print("Failure")
                    }
                }
            }
        }
    }
    
    @objc
    private func tapCheckButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "square") {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            if sender == termsOfUseAgreementCheckBox { isAgreeTermsOfUse = true }
            if sender == personalInfoAgreementCheckBox { isAgreePersonalInfo = true }
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        if sender == wholeAgreementCheckBox && sender.currentImage == UIImage(systemName: "checkmark.square") {
            termsOfUseAgreementCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            personalInfoAgreementCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isAgreeTermsOfUse = true
            isAgreePersonalInfo = true
        } else if sender == wholeAgreementCheckBox && sender.currentImage == UIImage(systemName: "square") {
            termsOfUseAgreementCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
            personalInfoAgreementCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    @objc
    private func tapTermsOfUseAgreementArrow() {
        let termsOfUseAgreementVC = TermsOfUseAgreementViewController()
        termsOfUseAgreementVC.TermsOfUseAgreementDelegate = self
        navigationController?.pushViewController(termsOfUseAgreementVC, animated: true)
    }
    
    @objc
    private func tapPersonalInfoAgreementArrow() {
        let personalInfoAgreementVC = PersonalInfoAgreementViewController()
        personalInfoAgreementVC.personalInfoAgreementDelegate = self
        navigationController?.pushViewController(personalInfoAgreementVC, animated: true)
    }
    
    /* 일반 회원가입 끝났으면 로그인 화면으로 돌아가도록 */
    public func showLoginView() {
        let loginVC = LoginViewController()
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    /* 네이버 회원가입 시 사용 */
    public func showDomitoryView() {
        let dormitoryVC = DormitoryViewController()
        dormitoryVC.modalTransitionStyle = .crossDissolve
        dormitoryVC.modalPresentationStyle = .fullScreen
        present(dormitoryVC, animated: true)
    }
}

extension AgreementViewController: TermsOfUseAgreementDelegate, PersonalInfoAgreementDelegate {
    func termsOfUseAgreement(isTrue: Bool) {
        print("delegate func called")
        if isTrue {
            termsOfUseAgreementCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isAgreeTermsOfUse = true
        }
    }
    
    func personalInfoAgreement(isTrue: Bool) {
        print("delegate func called")
        if isTrue {
            personalInfoAgreementCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isAgreePersonalInfo = true
        }
    }
}

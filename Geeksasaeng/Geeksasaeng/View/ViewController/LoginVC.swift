//
//  ViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/06/28.
//

import UIKit
import SnapKit
import NaverThirdPartyLogin

class LoginViewController: UIViewController {
    
    // MARK: - SubViews
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppLogo"))
        return imageView
    }()
    
    lazy var idTextField: UITextField = {
        var textField = UITextField()
        textField.autocapitalizationType = .none
        textField.font = .customFont(.neoLight, size: 14)
        textField.textColor = .init(hex: 0x2F2F2F)
        textField.attributedPlaceholder = NSAttributedString(
            string: "아이디",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(335)
        textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.autocapitalizationType = .none
        textField.font = .customFont(.neoLight, size: 14)
        textField.textColor = .init(hex: 0x2F2F2F)
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(335)
        textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.backgroundColor = UIColor.init(hex: 0xEFEFEF)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var naverLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NaverLogo"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setTitle("  네이버 로그인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.init(hex: 0x00C73C)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tapNaverloginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var automaticLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle"), for: .normal)
        button.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
        button.setTitle(" 자동 로그인", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.addTarget(self, action: #selector(tapAutomaticLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        button.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    let loginVM = LoginViewModel()
    let naverLoginVM = naverLoginViewModel()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNaverLoginVM()
        attemptAutoLogin()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addSubViews() {
        [logoImageView, idTextField, passwordTextField, loginButton, naverLoginButton, automaticLoginButton, signUpButton].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(133)
            make.centerX.equalTo(self.view.center)
            make.top.equalToSuperview().offset(150)
        }
        
        idTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(50)
            make.left.equalTo(23)
            make.width.equalTo(314)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.top.equalTo(self.idTextField.snp.bottom).offset(30)
            make.left.equalTo(23)
            make.width.equalTo(314)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.width.equalTo(314)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(50)
            make.height.equalTo(51)
        }
        
        naverLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.width.equalTo(314)
            make.top.equalTo(self.loginButton.snp.bottom).offset(10)
            make.height.equalTo(51)
        }
        
        automaticLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.top.equalTo(self.naverLoginButton.snp.bottom).offset(15)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImageView)
            make.top.equalTo(self.automaticLoginButton.snp.bottom).offset(45)
        }
    }
    
    private func setNaverLoginVM() {
        naverLoginVM.setInstanceDelegate(self)
    }
    
    private func attemptAutoLogin() {
        if let id = UserDefaults.standard.string(forKey: "id"),
           let password = UserDefaults.standard.string(forKey: "password") {
            let input = LoginInput(loginId: id, password: password)
            loginVM.login(self, input)
        }
    }
    
    @objc func tapSignUpButton() {
        // registerVC로 화면 전환.
        let registerVC = RegisterViewController()
        
        // TODO: - 회원가입 과정 중에 모달 방식 고민 필요
        // coverVertical로 할 거면 fullScreen 안 하는 게 나을 듯
        // crossDissolve로 할 거면 fullScreen 하는 게 나을 듯
        registerVC.modalTransitionStyle = .coverVertical
//        registerVC.modalPresentationStyle = .fullScreen
        
        present(registerVC, animated: true)
    }
    
    @objc func tapLoginButton() {
        // 로그인 시도
        if let id = self.idTextField.text,
           let pw = self.passwordTextField.text {
            let input = LoginInput(loginId: id, password: pw)
            loginVM.login(self, input)
        }
    }
    
    // MARK: 네이버 아이디 로그아웃 -> 토큰 삭제 (아이디 비밀번호 재입력 하게) => 나중에 차례되면 구현
    // MARK: 긱사생 회원가입 -> 기숙사 선택 화면 -> 홈 화면 (자동 로그인 자동 활성화 x)
    // MARK: 네이버 회원가입 -> 기숙사 선택 화면 -> 홈 화면 (자동 로그인 자동 활성화 o)
    @objc func tapNaverloginButton() {
        naverLoginVM.requestLogin()
//        if naverLoginVM.isExistToken() {
//            showHomeView()
//        } else {
//            print("===Not exist token===")
//        } -> 네이버 회원가입 때 어차피 자동 로그인 자동 활성화 하니까 토큰 여부 확인할 필요 없을 듯 ?
    }
    
    @objc func tapAutomaticLoginButton() {
        if automaticLoginButton.currentImage == UIImage(systemName: "rectangle") {
            automaticLoginButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        } else {
            automaticLoginButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        }
    }
    
    @objc func didChangeTextField(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        // 정규식 넣어서 수정 예정
        switch sender {
        case idTextField:
            if text.count >= 1 && passwordTextField.text?.count ?? 0 >= 1 {
                loginButton.isEnabled = true
                loginButton.tintColor = .white
                loginButton.backgroundColor = .mainColor
            } else {
                loginButton.isEnabled = false
                loginButton.tintColor = UIColor(hex: 0xA8A8A8)
                loginButton.backgroundColor = UIColor(hex: 0xEFEFEF)
            }
        default:
            if text.count >= 1 && idTextField.text?.count ?? 0 >= 1 {
                loginButton.isEnabled = true
                loginButton.tintColor = .white
                loginButton.backgroundColor = .mainColor
            } else {
                loginButton.isEnabled = false
                loginButton.tintColor = UIColor(hex: 0xA8A8A8)
                loginButton.backgroundColor = UIColor(hex: 0xEFEFEF)
            }
        }
        
    }
    
    /* 로그인 완료 후 화면 전환 */
    public func showNextView(isFirstLogin: Bool) {
        // 첫 로그인 시에는 기숙사 선택 화면으로 이동
        if isFirstLogin {
            let dormitoryVC = DormitoryViewController()
            // TODO: - 서버에서 로그인 API res로 닉네임 주면 그때 수정 예정
//            dormitoryVC.userNickName = userNickName
            dormitoryVC.modalTransitionStyle = .crossDissolve
            dormitoryVC.modalPresentationStyle = .fullScreen
            present(dormitoryVC, animated: true)
        } else {
            // 첫 로그인이 아니면 바로 홈 화면으로 이동
            showHomeView()
        }
    }
    
    /* 홈 화면으로 이동 */
    public func showHomeView() {
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
    public func showNaverRegisterView(id: String, phoneNum: String) {
        let naverRegisterVC = NaverRegisterViewController()
        naverRegisterVC.modalTransitionStyle = .crossDissolve
        naverRegisterVC.modalPresentationStyle = .fullScreen
        naverRegisterVC.phoneNumber = phoneNum
        naverRegisterVC.idData = id
        present(naverRegisterVC, animated: true)
    }
}


// MARK: - LoginVC Extensions

extension LoginViewController : NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성공
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        naverLoginVM.naverLoginPaser(self)
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰\(naverLoginVM.returnToken())")
    }
    
    // 토큰 삭제
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃")
    }
    
    // 모든 에러 출력
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
}

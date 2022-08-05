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
        textField.makeBottomLine(UIScreen.main.bounds.width - 23 * 2)
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
        textField.makeBottomLine(UIScreen.main.bounds.width - 23 * 2)
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
        button.setImage(UIImage(named: "CheckBox"), for: .normal)
        button.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapAutomaticLoginButton), for: .touchUpInside)
        return button
    }()
    
    let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 로그인"
        label.font = .customFont(.neoRegular, size: 15)
        label.textColor = .init(hex: 0x5B5B5B)
        return label
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
    var accessToken: String?
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNaverLoginVM()
        attemptAutoLogin()
        addSubViews()
        setLayouts()
//        print(UIScreen.main.bounds.size)
    }
    
    // MARK: - Function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addSubViews() {
        [
            logoImageView,
            idTextField, passwordTextField,
            loginButton, naverLoginButton,
            automaticLoginButton,autoLoginLabel,
            signUpButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(133)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.main.bounds.height / 6.83)
        }
        
        idTextField.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(UIScreen.main.bounds.height / 16.8)
            make.left.equalTo(23)
            make.right.equalTo(-23)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(idTextField.snp.bottom).offset(30)
            make.left.equalTo(23)
            make.right.equalTo(-23)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(51)
        }
        
        naverLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(51)
        }
        
        autoLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(naverLoginButton.snp.bottom).offset(21)
            make.centerX.equalTo(logoImageView).offset(9.5)
        }
        
        automaticLoginButton.snp.makeConstraints { make in
            make.right.equalTo(autoLoginLabel.snp.left).offset(-5)
            make.centerY.equalTo(autoLoginLabel)
            make.width.height.equalTo(15)
        }
        
        // TODO: - 아이팟 터치에서는 다른 버튼 크기를 비율 맞춰 줄여봐도 이 버튼이 가려짐. 스크롤뷰 추가해야 할 듯
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(automaticLoginButton.snp.bottom).offset(UIScreen.main.bounds.height / 18.7)
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
    
    @objc private func tapSignUpButton() {
        // registerVC로 화면 전환.
        let registerVC = RegisterViewController()
        
        // TODO: - 회원가입 과정 중에 모달 방식 고민 필요
        registerVC.modalTransitionStyle = .crossDissolve
        registerVC.modalPresentationStyle = .fullScreen
        
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
        if automaticLoginButton.currentImage == UIImage(named: "CheckBox") {
            automaticLoginButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        } else {
            automaticLoginButton.setImage(UIImage(named: "CheckBox"), for: .normal)
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
    public func showNextView(isFirstLogin: Bool, nickName: String? = nil) {
        // 첫 로그인 시에는 기숙사 선택 화면으로 이동
        if isFirstLogin {
            let dormitoryVC = DormitoryViewController()
            print("체크", nickName!)
            dormitoryVC.userNickName = nickName
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
    
    /* 네이버 회원가입으로 이동 */
    public func showNaverRegisterView() {
        let naverRegisterVC = NaverRegisterViewController()
        naverRegisterVC.accessToken = accessToken
        naverRegisterVC.modalTransitionStyle = .crossDissolve
        naverRegisterVC.modalPresentationStyle = .fullScreen
        present(naverRegisterVC, animated: true)
    }
    
    /* 기숙사 선택화면으로 이동 */
    public func showDormitoryView() {
        let dormitoryVC = DormitoryViewController()
        dormitoryVC.modalTransitionStyle = .crossDissolve
        dormitoryVC.modalPresentationStyle = .fullScreen
        present(dormitoryVC, animated: true)
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

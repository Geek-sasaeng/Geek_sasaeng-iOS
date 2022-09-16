//
//  ViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/06/28.
//

import UIKit
import SnapKit
import NaverThirdPartyLogin
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - SubViews
    
    /* 회원가입 버튼이 가려지는 작은 디바이스에는 스크롤뷰를 추가 */
    // 스크롤뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xB5B5B5)]
        )
        textField.delegate = self
        textField.makeBottomLine()
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xB5B5B5)]
        )
        textField.delegate = self
        textField.makeBottomLine()
        textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        textField.isSecureTextEntry = true
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
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.init(hex: 0x00C73C)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tapNaverLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AppleLogo"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setTitle("  Apple 로그인", for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .black
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tapAppleLoginButton), for: .touchUpInside)
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
    
    let naverLoginVM = naverLoginViewModel()
    var accessToken: String?
    var dormitoryInfo: DormitoryNameResult?
    var userImageUrl: String?
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNaverLoginVM()
        attemptAutoLogin()
        addSubViews()
        setLayouts()
        setKeyboardDown()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            logoImageView,
            idTextField, passwordTextField,
            loginButton, naverLoginButton, appleLoginButton,
            automaticLoginButton,autoLoginLabel,
            signUpButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.width.equalTo(view.safeAreaLayoutGuide)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.bottom).offset(30)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(133)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height / 6.83)
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
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(naverLoginButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(51)
        }
        
        autoLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(21)
            make.centerX.equalTo(logoImageView).offset(9.5)
        }
        
        automaticLoginButton.snp.makeConstraints { make in
            make.right.equalTo(autoLoginLabel.snp.left).offset(-5)
            make.centerY.equalTo(autoLoginLabel)
            make.width.height.equalTo(15)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(automaticLoginButton.snp.bottom).offset(UIScreen.main.bounds.height / 18.7)
        }
    }
    
    private func setNaverLoginVM() {
        naverLoginVM.setInstanceDelegate(self)
    }
    
    private func attemptAutoLogin() {
        if let jwt = UserDefaults.standard.string(forKey: "jwt") {
            print(jwt)
            AutoLoginAPI.attemptAutoLogin(jwt: jwt) { result in
                // static에 필요한 데이터 저장
                LoginModel.jwt = jwt
                LoginModel.nickname = result.nickname
                LoginModel.userImgUrl = result.userImageUrl
                
                self.dormitoryInfo = DormitoryNameResult(id: result.dormitoryId, name: result.dormitoryName)
                self.userImageUrl = result.userImageUrl
                
                // 로그인 완료 후 경우에 따른 화면 전환
                if result.loginStatus == "NEVER" {
                    self.showNextView(isFirstLogin: true, nickName: result.nickname ?? "홍길동")
                } else {
                    self.showNextView(isFirstLogin: false)
                }
            }
        }
    }
    
    /* 배경 누르면 토글된 키보드 내려가게 하기 */
    private func setKeyboardDown() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapSignUpButton() {
        // registerVC로 화면 전환.
        let registerVC = RegisterViewController()
        
        registerVC.modalTransitionStyle = .crossDissolve
        registerVC.modalPresentationStyle = .fullScreen
        
        present(registerVC, animated: true)
    }
    
    @objc private func tapLoginButton() {
        // 로그인 시도
        if let id = self.idTextField.text,
           let pw = self.passwordTextField.text {
            let input = LoginInput(loginId: id, password: pw, fcmToken: nil)
            LoginViewModel.login(self, input) { result in
                // 자동로그인 체크 시 UserDefaults에 jwt 저장
                if self.automaticLoginButton.currentImage == UIImage(systemName: "checkmark.rectangle") {
                    UserDefaults.standard.set(result.jwt, forKey: "jwt")
                }
                
                // static property에 jwt, nickname, userImgUrl 저장
                LoginModel.jwt = result.jwt
                LoginModel.nickname = result.nickName
                LoginModel.userImgUrl = result.userImageUrl
                
                // dormitoryId, Name 저장
                self.dormitoryInfo = DormitoryNameResult(id: result.dormitoryId, name: result.dormitoryName)
                // userImageUrl 저장
                self.userImageUrl = result.userImageUrl
                
                // 로그인 완료 후 경우에 따른 화면 전환
                if result.loginStatus == "NEVER" {
                    self.showNextView(isFirstLogin: true, nickName: result.nickName ?? "홍길동")
                } else {
                    self.showNextView(isFirstLogin: false)
                }
            }
        }
    }
    
    @objc private func tapNaverLoginButton() {
        // 토큰 존재하면 재발급 받아서 로그인 시도
        if naverLoginVM.isValidAccessTokenExpireTimeNow() {
            naverLoginVM.requestAccessTokenWithRefreshToken()
        }
        naverLoginVM.requestLogin()
    }
    
    @objc private func tapAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc private func tapAutomaticLoginButton() {
        if automaticLoginButton.currentImage == UIImage(named: "CheckBox") {
            automaticLoginButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        } else {
            automaticLoginButton.setImage(UIImage(named: "CheckBox"), for: .normal)
        }
    }
    
    @objc private func didChangeTextField(_ sender: UITextField) {
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
        
        let navController = tabBarController.viewControllers![0] as! UINavigationController
        let deliveryVC = navController.topViewController as! DeliveryViewController
        deliveryVC.dormitoryInfo = dormitoryInfo
        deliveryVC.userImageUrl = userImageUrl
        
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
    public func showDormitoryView(nickname: String) {
        let dormitoryVC = DormitoryViewController()
        dormitoryVC.userNickName = nickname
        dormitoryVC.modalTransitionStyle = .crossDissolve
        dormitoryVC.modalPresentationStyle = .fullScreen
        present(dormitoryVC, animated: true)
    }
}


// MARK: - NaverThirdPartyLoginConnectionDelegate

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

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // 키보드의 return 버튼 누르면 키보드 내려가게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // 로그인 진행하는 화면 표출
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID 연동 실패")
        self.showToast(viewController: self, message: "로그인 실패! 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8))
    }
}


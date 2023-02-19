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
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let naverLoginVM = NaverLoginViewModel()
    var accessToken: String?
    var dormitoryInfo: DormitoryNameResult?
    var userImageUrl: String?
    
    // MARK: - SubViews
    
    /* 회원가입 버튼이 가려지는 작은 디바이스에는 스크롤뷰를 추가 */
    // 스크롤뷰
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let logoImageView = UIImageView(image: UIImage(named: "AppLogo"))
    
    let idTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "아이디",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xB5B5B5)]
        )
    }
    let passwordTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xB5B5B5)]
        )
        $0.isSecureTextEntry = true
    }
    
    lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.init(hex: 0xEFEFEF)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
    }
    lazy var naverLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "NaverLogo"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.setTitle("  네이버 로그인", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = UIColor.init(hex: 0x00C73C)
        $0.addTarget(self, action: #selector(tapNaverLoginButton), for: .touchUpInside)
    }
    lazy var appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "AppleLogo"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.setTitle("  Apple로 로그인", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = .black
        $0.addTarget(self, action: #selector(tapAppleLoginButton), for: .touchUpInside)
    }
    
    lazy var automaticLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "CheckBox"), for: .normal)
        $0.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapAutomaticLoginButton), for: .touchUpInside)
    }
    
    let autoLoginLabel = UILabel().then {
        $0.text = "자동 로그인"
        $0.font = .customFont(.neoRegular, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
    }
    
    lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        $0.titleLabel?.font = .customFont(.neoLight, size: 15)
        $0.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        $0.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNaverLoginVM()
        attemptAutoLogin()
        addSubViews()
        setLayouts()
        setKeyboardDown()
        setAttributes()
        setNotificationCenter()
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
            make.bottom.equalTo(signUpButton.snp.bottom).offset(screenHeight / 28.4)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(screenWidth / 2.95)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(screenHeight / 6.83)
        }
        
        idTextField.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(screenHeight / 16.8)
            make.left.equalTo(screenWidth / 17.08)
            make.right.equalTo(-(screenWidth / 17.08))
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(idTextField.snp.bottom).offset(screenHeight / 28.4)
            make.left.equalTo(screenWidth / 17.08)
            make.right.equalTo(-(screenWidth / 17.08))
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(passwordTextField.snp.bottom).offset(screenHeight / 17.04)
            make.width.equalTo(317)
            make.height.equalTo(44)
        }
        
        naverLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(loginButton.snp.bottom).offset(screenHeight / 85.2)
            make.width.equalTo(317)
            make.height.equalTo(44)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(naverLoginButton.snp.bottom).offset(screenHeight / 85.2)
            make.width.equalTo(317)
            make.height.equalTo(44)
        }
        
        autoLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(screenHeight / 40.57)
            make.centerX.equalTo(logoImageView).offset(screenWidth / 41.36)
        }
        
        automaticLoginButton.snp.makeConstraints { make in
            make.right.equalTo(autoLoginLabel.snp.left).offset(-(screenWidth / 78.6))
            make.centerY.equalTo(autoLoginLabel)
            make.width.height.equalTo(screenWidth / 26.2)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(logoImageView)
            make.top.equalTo(automaticLoginButton.snp.bottom).offset(screenHeight / 18.7)
        }
    }
    
    private func setNaverLoginVM() {
        naverLoginVM.setInstanceDelegate(self)
    }
    
    private func attemptAutoLogin() {
        if let jwt = UserDefaults.standard.string(forKey: "jwt") {
            MyLoadingView.shared.show()
            
            LoginAPI.attemptAutoLogin(jwt: jwt) { result in
                MyLoadingView.shared.hide()
                
                // static에 필요한 데이터 저장
                LoginModel.jwt = jwt
                LoginModel.memberId = result.memberId
                LoginModel.nickname = result.nickname
                LoginModel.profileImgUrl = result.profileImgUrl
                LoginModel.dormitoryId = result.dormitoryId
                LoginModel.dormitoryName = result.dormitoryName
                
                self.dormitoryInfo = DormitoryNameResult(id: result.dormitoryId, name: result.dormitoryName)
                self.userImageUrl = result.profileImgUrl
                
                // 로그인 완료 후 경우에 따른 화면 전환
                if result.loginStatus == "NEVER" {
                    self.showDormitoryView(nickname: result.nickname ?? "홍길동")
                } else {
                    self.showHomeView()
                }
            }
        }
    }
    
    /* 배경 누르면 토글된 키보드 내려가게 하기 */
    private func setKeyboardDown() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setAttributes() {
        [scrollView, contentView].forEach {
            $0.backgroundColor = .white
        }
        
        [idTextField, passwordTextField].forEach {
            $0.autocapitalizationType = .none
            $0.font = .customFont(.neoLight, size: 14)
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.delegate = self
            $0.makeBottomLine()
            $0.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
        
        [loginButton, naverLoginButton, appleLoginButton].forEach {
            $0.titleLabel?.font = .customFont(.neoBold, size: 20)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.layer.cornerRadius = 5
        }
    }
    
    private func setNotificationCenter() {
        // 다른 VC에서 여기에 토스트 메세지를 띄우기 위한 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(completeLogout), name: NSNotification.Name("CompleteLogout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(completeWithdrawal), name: NSNotification.Name("CompleteWithdrawal"), object: nil)
    }
    
    /* 홈 화면으로 이동 */
    public func showHomeView() {
        let tabBarController = TabBarController()
        
        let navController = tabBarController.viewControllers![0] as! UINavigationController
        let deliveryVC = navController.topViewController as! DeliveryViewController
        deliveryVC.dormitoryInfo = dormitoryInfo ?? DormitoryNameResult(id: 1, name: "제1기숙사")
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
    
    // MARK: - @objc Functions
    
    @objc
    private func tapSignUpButton() {
        // registerVC로 화면 전환.
        let registerVC = RegisterViewController()
        
        registerVC.modalTransitionStyle = .crossDissolve
        registerVC.modalPresentationStyle = .fullScreen
        
        present(registerVC, animated: true)
    }
    
    @objc
    private func tapLoginButton() {
        MyLoadingView.shared.show()
          
        // 로그인 시도
        if let id = self.idTextField.text,
           let pw = self.passwordTextField.text {

            // fcm 등록토큰 값 불러오기
            let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
            print("DEBUG: fcmToken in LoginVC", fcmToken)
            let input = LoginInput(loginId: id, password: pw, fcmToken: fcmToken)
            
            LoginViewModel.login(input) { model  in
                MyLoadingView.shared.hide()
                
                if let model = model {
                    switch model.code {
                    case 1000: // 로그인 성공
                        guard let result = model.result else { return }
                        // 자동로그인 체크 시 UserDefaults에 jwt 저장
                        if self.automaticLoginButton.currentImage == UIImage(systemName: "checkmark.rectangle") {
                            UserDefaults.standard.set(result.jwt, forKey: "jwt")
                        }
                        
                        // static property에 jwt, nickname, userImgUrl 저장
                        LoginModel.jwt = result.jwt
                        LoginModel.nickname = result.nickName
                        LoginModel.profileImgUrl = result.profileImgUrl
                        LoginModel.memberId = result.memberId
                        LoginModel.dormitoryId = result.dormitoryId
                        LoginModel.dormitoryName = result.dormitoryName
                        
                        // dormitoryId, Name 저장
                        self.dormitoryInfo = DormitoryNameResult(id: result.dormitoryId, name: result.dormitoryName)
                        // userImageUrl 저장
                        self.userImageUrl = result.profileImgUrl
                        
                        // 로그인 완료 후 경우에 따른 화면 전환
                        if result.loginStatus == "NEVER" {
                            self.showDormitoryView(nickname: result.nickName ?? "홍길동")
                        } else {
                            self.showHomeView()
                        }
                    case 2011, 2012, 2400:
                        self.showToast(viewController: self, message: "로그인 실패! 다시 시도해주세요", font: .customFont(.neoMedium, size: 15), color: .init(hex: 0xA8A8A8), width: 229, height: 40, top: 26)
                    default:
                        // 서버 에러
                        self.showBottomToast(viewController: self, message: "잠시 후 다시 시도해주세요", font: .customFont(.neoMedium, size: 15), color: .lightGray)
                    }
                } else {
                    // 서버 에러
                    self.showBottomToast(viewController: self, message: "잠시 후 다시 시도해주세요", font: .customFont(.neoMedium, size: 15), color: .lightGray)
                }
            }
        }
    }
    
    @objc
    private func tapNaverLoginButton() {
        if naverLoginVM.returnToken() != "" { // 토큰이 이미 발행되었다면
            naverLoginVM.naverLoginPaser(self) // 가입 페이지로
        }
        // 토큰 존재하면 재발급 받아서 로그인 시도
        if naverLoginVM.isValidAccessTokenExpireTimeNow() {
            naverLoginVM.requestAccessTokenWithRefreshToken()
        }
        naverLoginVM.requestLogin()
    }
    
    @objc
    private func tapAppleLoginButton() {
//        RegisterAPI.registerUserFromApple { result in
//            print(result)
//        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    private func tapAutomaticLoginButton() {
        if automaticLoginButton.currentImage == UIImage(named: "CheckBox") {
            automaticLoginButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        } else {
            automaticLoginButton.setImage(UIImage(named: "CheckBox"), for: .normal)
        }
    }
    
    @objc
    private func didChangeTextField(_ sender: UITextField) {
        let text = sender.text ?? ""
        
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
        default: // passwordTextField
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
    
    // 로그아웃을 완료했을 때 토스트 메세지 띄우기
    @objc
    private func completeLogout(_ notification: Notification) {
        self.showToast(viewController: self, message: "로그아웃 되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 184, height: 59)
    }
    
    // 회원탈퇴를 완료했을 때 토스트 메세지 띄우기
    @objc
    private func completeWithdrawal(_ notification: Notification) {
        self.showToast(viewController: self, message: "탈퇴가 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 198, height: 59)
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
            
            // 애플 로그인 시 받아올 정보
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(tokenStr ?? "")")
            
        default:
            break
        }
    }

    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID 연동 실패")
        self.showToast(viewController: self, message: "로그인 실패! 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 229, height: 40)
    }
}


//
//  PhoneAuthVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/06.
//

import UIKit
import SnapKit
import Then

class PhoneAuthViewController: UIViewController {
    
    // MARK: - Properties
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    /* 이전 화면에서 받아온 데이터들 */
    var idData: String? = nil
    var pwData: String? = nil
    var pwCheckData: String? = nil
    var nickNameData: String? = nil
    var university: String? = nil
    var emailId: Int? = nil
    var uuid: UUID? = nil
    
    var phoneNumberId: Int? = nil
    
    // 애플 로그인
    var idToken: String?
    var code: String?
    var email: String?
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: Timer?
    
    // MARK: - SubViews
    
    var progressBar = UIView().then {
        $0.backgroundColor = .mainColor
    }
    var remainBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xF2F2F2)
    }
    var progressIcon = UIImageView().then {
        $0.image = UIImage(named: "LogoTop")
    }
    var remainIcon = UIImageView().then {
        $0.image = UIImage(named: "LogoBottom")
    }
    
    var phoneNumLabel = UILabel()
    var authLabel = UILabel()
    
    lazy var phoneNumTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    lazy var authTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    lazy var authSendButton = UIButton().then {
        $0.setTitle("인증번호 전송", for: .normal)
        $0.setActivatedButton()
        $0.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
    }
    lazy var authCheckButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(tapAuthCheckButton), for: .touchUpInside)
    }
    
    var remainTimeLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setTextFieldTarget()
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    // MARK: - Initialization
    
    init(idData: String, pwData: String, pwCheckData: String, nickNameData: String, university: String, emailId: Int, uuid: UUID) {
        super.init(nibName: nil, bundle: nil)
        self.idData = idData
        self.pwData = pwData
        self.pwCheckData = pwCheckData
        self.nickNameData = nickNameData
        self.university = university
        self.emailId = emailId
        self.uuid = uuid
    }
    
    /* 애플 로그인용 */
    init(idToken: String, code: String, nicknameData: String, university: String, email: String, uuid: UUID) {
        super.init(nibName: nil, bundle: nil)
        self.idToken = idToken
        self.code = code
        self.nickNameData = nicknameData
        self.university = university
        self.email = email
        self.uuid = uuid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addSubViews() {
        [progressBar, remainBar, progressIcon, remainIcon,
         phoneNumLabel, authLabel,
         phoneNumTextField, authTextField,
         authSendButton, authCheckButton,
         nextButton,
         remainTimeLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(screenWidth / 142)
            make.width.equalTo((screenWidth - 50) / 5 * 4)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(screenHeight / 85.2)
            make.left.equalToSuperview().inset(screenWidth / 15.72)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(screenWidth / 142)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(screenHeight / 85.2)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(screenWidth / 15.72)
        }
        
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 11.22)
            make.height.equalTo(screenHeight / 38.72)
            make.top.equalTo(progressBar.snp.top).offset(-(screenHeight / 85.2))
            make.left.equalTo(progressBar.snp.right).inset(screenWidth / 26.2)
        }
        
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 17.86)
            make.height.equalTo(screenHeight / 23.66)
            make.top.equalTo(progressBar.snp.top).offset(-(screenHeight / 106.5))
            make.right.equalTo(remainBar.snp.right).offset(screenWidth / 131)
        }
        
        /* phoneNumLabel */
        phoneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(screenHeight / 17.04)
            make.left.equalToSuperview().inset(screenWidth / 14.55)
        }
        
        /* authLabel */
        authLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.55)
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(screenHeight / 10.51)
        }
        
        /* phoneNumTextField */
        phoneNumTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.right.equalTo(authSendButton.snp.left).offset(-(screenWidth / 26.2))
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(screenHeight / 42.6)
        }
        /* authTextField */
        authTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.right.equalTo(authCheckButton.snp.left).offset(-(screenWidth / 26.2))
            make.top.equalTo(authLabel.snp.bottom).offset(screenHeight / 42.6)
        }
        
        /* authSendButton */
        authSendButton.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumTextField.snp.bottom).offset(screenHeight / 85.2)
            make.right.equalToSuperview().inset(screenWidth / 15.11)
            make.width.equalTo(screenWidth / 3.74)
            make.height.equalTo(screenHeight / 20.78)
        }
        
        /* authCheckButton */
        authCheckButton.snp.makeConstraints { make in
            make.bottom.equalTo(authTextField.snp.bottom).offset(screenHeight / 85.2)
            make.right.equalToSuperview().inset(screenWidth / 15.11)
            make.width.equalTo(screenWidth / 3.74)
            make.height.equalTo(screenHeight / 20.78)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(screenWidth / 14.03)
            make.bottom.equalToSuperview().inset(screenHeight / 16.7)
            make.height.equalTo(screenHeight / 16.7)
        }
        
        /* remainTimeLabel */
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 9.82)
            make.top.equalTo(authTextField.snp.bottom).offset(screenHeight / 40.57)
        } // authTextField 레이아웃 초기화 이후에 레이아웃 설정해줘야 하기 때문에 일단 뒤에 배치
    }
    
    private func startTimer(startTime: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
                let expireLimit = 300
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    self?.remainTimeLabel.textColor = .red
                    self?.remainTimeLabel.text = "인증번호 입력 시간이 만료되었습니다."
                    return
                }
                
                let remainSeconds = expireLimit - elapsedTimeSeconds
                let minutes = remainSeconds / 60
                let seconds = remainSeconds % 60
                self?.remainTimeLabel.textColor = .mainColor
                self?.remainTimeLabel.text = String(format: "%02d분 %02d초 남았어요", minutes, seconds)
            }
        }
    }
    
    private func setAttributes() {
        /* labels attr */
        setMainLabelAttrs(phoneNumLabel, text: "휴대폰 번호 입력")
        setMainLabelAttrs(authLabel, text: "인증번호 입력")
        
        /* textFields attr */
        setTextFieldAttrs(phoneNumTextField, msg: "- 제외 숫자만 입력하세요", width: 187)
        setTextFieldAttrs(authTextField, msg: "입력하세요", width: 187)
        
        [progressBar, remainBar].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 1.5
        }
        
        [authSendButton, authCheckButton].forEach {
            $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
            $0.layer.cornerRadius = 5
//            $0.clipsToBounds = true
        }
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ label: UILabel, text: String) {
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
    }
    
    private func setTextFieldAttrs(_ textField: UITextField, msg: String, width: CGFloat) {
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine()
    }
    
    private func setTextFieldTarget() {
        [phoneNumTextField, authTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        }
    }
    
    @objc
    private func didChangeTextField() {
        if phoneNumTextField.text?.count ?? 0 >= 1 && authTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
            authCheckButton.setActivatedButton()
        } else {
            nextButton.setDeactivatedNextButton()
            authCheckButton.setDeactivatedButton()
        }
    }
    
    // 인증번호 일치/불일치 확인
    @objc
    private func tapAuthCheckButton() {
        /* 인증번호 입력한 게 맞는지 "확인" 버튼 눌렀을 때 확인하는 것으로 변경. */
        if let phoneNum = phoneNumTextField.text,
           let authNum = authTextField.text {
            MyLoadingView.shared.show()
            
            let input = PhoneAuthCheckInput(recipientPhoneNumber: phoneNum, verifyRandomNumber: authNum)
            PhoneAuthCheckViewModel.requestCheckPhoneAuth(input) { isSuccess, result, message in
                MyLoadingView.shared.hide()
                
                switch isSuccess {
                case .success:
                    // 인증 완료 텍스트 띄우기
                    self.remainTimeLabel.text = "성공적으로 인증이 완료되었습니다"
                    self.timer?.invalidate()
                    self.timer = nil
                    
                    self.phoneNumberId = result?.phoneNumberId
                    self.nextButton.setActivatedNextButton()
                default:
                    self.showToast(viewController: self, message: message!, font: .customFont(.neoBold, size: 13), color: UIColor(hex: 0xA8A8A8))
                }
            }
        }
    }
    
    @objc
    private func showNextView() {
        print(self.idToken)
        print(self.code)
        print(self.nickNameData)
        print(self.university)
        print(self.email)
        // 일치했을 때에만 화면 전환
        if let idData = self.idData,
           let pwData = self.pwData,
           let pwCheckData = self.pwCheckData,
           let nickNameData = self.nickNameData,
           let university = self.university,
           let emailId = self.emailId,
           let phoneNumberId = self.phoneNumberId {
            let agreementVC = AgreementViewController(idData: idData, pwData: pwData, pwCheckData: pwCheckData, nickNameData: nickNameData, university: university, emailId: emailId, phoneNumberId: phoneNumberId)
            
            let navVC = UINavigationController(rootViewController: agreementVC)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            
            present(navVC, animated: true)
        }
        
        if let idToken = self.idToken,
           let code = self.code,
           let nickNameData = self.nickNameData,
           let university = self.university,
           let email = self.email {
            let agreementVC = AgreementViewController(idToken: idToken, code: code, nickNameData: nickNameData, university: university, email: email, phoneNumber: phoneNumTextField.text!)
            
            let navVC = UINavigationController(rootViewController: agreementVC)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            
            present(navVC, animated: true)
        }
//
//        if idToken != nil { // 애플 로그인
//            agreementVC = AgreementViewController(idToken: idToken!, code: code!, nickNameData: nickNameData, university: university, email: email!, phoneNumber: phoneNumTextField.text!)
//        }
        
        
    }
    
    /* 핸드폰번호 인증번호 전송 버튼 눌렀을 때 실행되는 함수 */
    @objc
    private func tapAuthSendButton() {
        if let phoneNum = self.phoneNumTextField.text,
           let uuid = uuid {
            MyLoadingView.shared.show()
            
            startTimer(startTime: Date())
            authCheckButton.setActivatedButton()
            authSendButton.setTitle("재전송 하기", for: .normal)
            let input = PhoneAuthInput(recipientPhoneNumber: phoneNum, uuid: uuid.uuidString)
            print("DEBUG:", uuid.uuidString)
            PhoneAuthViewModel.requestSendPhoneAuth(input) { model in
                MyLoadingView.shared.hide()
                
                if let model = model {
                    // 경우에 맞는 토스트 메세지 출력
                    switch model.code {
                    case 1001:
                        self.showToast(viewController: self, message: "인증번호가 전송되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    case 2015:
                        self.showToast(viewController: self, message: "일일 최대 전송 횟수를 초과했습니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 248, height: 40)
                    default:
                        self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                    }
                } else {
                    self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension PhoneAuthViewController: UITextFieldDelegate {
    // return 버튼 클릭 시 실행
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드 내리기
        textField.resignFirstResponder()
        return true
    }
}

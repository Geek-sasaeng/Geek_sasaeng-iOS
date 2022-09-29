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
    
    var phoneNumTextField = UITextField()
    var authTextField = UITextField()
    
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
        $0.textColor = .mainColor
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
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    
    /* 이전 화면에서 받아온 데이터들 */
    var idData: String? = nil
    var pwData: String? = nil
    var pwCheckData: String? = nil
    var nickNameData: String? = nil
    var university: String? = nil
    var emailId: Int? = nil
    var uuid: UUID? = nil
    
    var phoneNumberId: Int? = nil
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: DispatchSourceTimer?
    
    
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
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 4)
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
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.top.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).inset(15)
        }
        
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(36)
            make.top.equalTo(progressBar.snp.top).offset(-8)
            make.right.equalTo(remainBar.snp.right).offset(3)
        }
        
        /* phoneNumLabel */
        phoneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(27)
        }
        
        /* authLabel */
        authLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(81)
        }
        
        /* phoneNumTextField */
        phoneNumTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authSendButton.snp.left).offset(-15)
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(20)
        }
        /* authTextField */
        authTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authCheckButton.snp.left).offset(-15)
            make.top.equalTo(authLabel.snp.bottom).offset(20)
        }
        
        /* authSendButton */
        authSendButton.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* authCheckButton */
        authCheckButton.snp.makeConstraints { make in
            make.bottom.equalTo(authTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
        
        /* remainTimeLabel */
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(authTextField.snp.bottom).offset(21)
        } // authTextField 레이아웃 초기화 이후에 레이아웃 설정해줘야 하기 때문에 일단 뒤에 배치
    }
    
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self.currentSeconds -= 1
            let minutes = self.currentSeconds / 60
            let seconds = self.currentSeconds % 60
            self.remainTimeLabel.text = String(format: "%02d분 %02d초 남았어요", minutes, seconds)
            
            if self.currentSeconds <= 0 {
                self.timer?.cancel()
                self.remainTimeLabel.textColor = .red
                self.remainTimeLabel.text = "인증번호 입력 시간이 만료되었습니다."
            }
        })
        timer?.resume()
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
            $0.clipsToBounds = true
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
            let input = PhoneAuthCheckInput(recipientPhoneNumber: phoneNum, verifyRandomNumber: authNum)
            PhoneAuthCheckViewModel.requestCheckPhoneAuth(input) { isSuccess, result, message in
                switch isSuccess {
                case .success:
                    self.phoneNumberId = result?.phoneNumberId
                    self.showNextView()
                default:
                    self.showToast(viewController: self, message: message!, font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8))
                }
            }
        }
    }
    
    @objc
    public func showNextView() {
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
    }
    
    /* 핸드폰번호 인증번호 전송 버튼 눌렀을 때 실행되는 함수 */
    @objc
    private func tapAuthSendButton() {
        if let phoneNum = self.phoneNumTextField.text,
           let uuid = uuid {
            startTimer()
            authCheckButton.setActivatedButton()
            authSendButton.setTitle("재전송 하기", for: .normal)
            let input = PhoneAuthInput(recipientPhoneNumber: phoneNum, uuid: uuid.uuidString)
            print("DEBUG:", uuid.uuidString)
            PhoneAuthViewModel.requestSendPhoneAuth(input) { isSuccess, message in
                switch isSuccess {
                case .success:
                    self.showToast(viewController: self, message: message, font: .customFont(.neoMedium, size: 13), color: .mainColor)
                default:
                    self.showToast(viewController: self, message: message, font: .customFont(.neoMedium, size: 13), color: .init(hex: 0xA8A8A8))
                }
            }
        }
    }
}

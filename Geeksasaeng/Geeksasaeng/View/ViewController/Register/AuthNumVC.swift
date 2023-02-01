//
//  AuthNumVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

// TODO: - AuthNumVC 지워도 되는지 확인하고 지우기 -> 이메일 인증 화면 합침

import UIKit

import SnapKit
import Then

/* 이메일 인증번호 입력하는 화면의 VC */
class AuthNumViewController: UIViewController {
    
    // MARK: - Subviews
    
    let progressBar = UIView().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 1.5
    }
    
    let remainBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xF2F2F2)
        $0.layer.cornerRadius = 1.5
    }
    
    let progressIcon = UIImageView(image: UIImage(named: "LogoTop"))
    
    let remainIcon = UIImageView(image: UIImage(named: "LogoBottom"))
    
    let authNumLabel = UILabel().then {
        $0.text = "인증번호 입력"
        $0.font = .customFont(.neoMedium, size: 18)
        $0.textColor = .black
    }
    
    lazy var authNumTextField = UITextField().then {
        $0.textColor = .black
        $0.attributedPlaceholder = NSAttributedString(
            string: "입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        $0.makeBottomLine()
        $0.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
    }
    
    lazy var authResendButton = UIButton().then {
        $0.setTitle("재전송 하기", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(tapAuthResendButton), for: .touchUpInside)
    }
    
    let remainTimeLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    /* 이전 화면에서 받아온 데이터들 */
    var idData: String? = nil
    var pwData: String? = nil
    var pwCheckData: String? = nil
    var nickNameData: String? = nil
    var university: String? = nil
    var email: String? = nil
    var emailId: Int? = nil
    var uuid: UUID? = nil
    
    /* 네이버 회원가입에서 받아온 데이터 */
    var isFromNaverRegister = false
    var accessToken: String? // 네이버 엑세스 토큰 -> Register API 호출에 필요
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: DispatchSourceTimer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        authResendButton.setActivatedButton()
        startTimer()
        addRightSwipe()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Initialization
    
    /* 일반 회원가입용 */
    init(idData: String, pwData: String, pwCheckData: String, nickNameData: String, university: String, email: String, uuid: UUID) {
        super.init(nibName: nil, bundle: nil)
        self.idData = idData
        self.pwData = pwData
        self.pwCheckData = pwCheckData
        self.nickNameData = nickNameData
        self.university = university
        self.email = email
        self.uuid = uuid
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
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            progressBar, remainBar,
            progressIcon, remainIcon,
            authNumLabel, authNumTextField,
            remainTimeLabel, authResendButton,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        [ progressBar, remainBar ].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(3)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            }
        }
        
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            if isFromNaverRegister {
                make.width.equalTo((UIScreen.main.bounds.width - 50) / 3 * 2)
            } else {
                make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 3)
            }
            make.left.equalToSuperview().inset(25)
        }
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.top.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).inset(15)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(36)
            make.top.equalTo(progressBar.snp.top).offset(-8)
            make.right.equalTo(remainBar.snp.right).offset(3)
        }
        
        /* authNumLabel */
        authNumLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(27)
        }
        
        /* authNumTextField */
        authNumTextField.snp.makeConstraints { make in
            make.top.equalTo(authNumLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authResendButton.snp.left).offset(-15)
        }
        
        /* remainTimeLabel */
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(authNumTextField.snp.bottom).offset(21)
        }
        
        /* authResendButton */
        authResendButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(80)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
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
    
    /* 이메일 인증번호 입력 후 다음 버튼을 누르면
     -> 인증번호 일치하는지 API를 통해서 판단 */
    @objc private func tapNextButton() {
        if let email = self.email,
           let authNum = self.authNumTextField.text {
            print("DEBUG: ", email, authNum)
//            EmailAuthCheckViewModel.requestCheckEmailAuth(self, EmailAuthCheckInput(email: email, key: authNum))
        }
    }
    
    @objc
    private func didChangeTextField(_ sender: UITextField) {
        if authNumTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
    
    // 이메일 재전송 하기 버튼 눌렀을 때 실행되는 함수
    @objc
    private func tapAuthResendButton() {
        timer?.cancel()
        currentSeconds = 300
        startTimer()
        
        if let email = email,
           let univ = university {    // 값이 들어 있어야 괄호 안의 코드 실행 가능
            print("DEBUG: ", email, univ)
            
            let input = EmailAuthInput(email: email, university: univ)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(input) { model in
                if let model = model {
                    // 경우에 맞는 토스트 메세지 출력
                    switch model.code {
                    case 1802:
                        self.showToast(viewController: self, message: "인증번호가 전송되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    case 2804:
                        self.showToast(viewController: self, message: "이메일 인증은 하루 최대 10번입니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 250, height: 40)
                    default:
                        self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                    }
                } else {
                    self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                }
            }
        }
    }
    
    // 다음 버튼을 누르면 -> 회원 가입 완료 & 로그인 화면 띄우기
    // VM에서 호출하는 함수이다
    public func showNextView() {
        if isFromNaverRegister {
            let agreementVC = AgreementViewController(isFromNaverRegister: true, accessToken: accessToken!, nickNameData: nickNameData!, university: university!, email: email!)
            agreementVC.modalTransitionStyle = .crossDissolve
            agreementVC.modalPresentationStyle = .fullScreen
            
            present(agreementVC, animated: true)
        } else {
            if let idData = self.idData,
               let pwData = self.pwData,
               let pwCheckData = self.pwCheckData,
               let nickNameData = self.nickNameData,
               let university = self.university,
               let emailId = self.emailId,
               let uuid = self.uuid {
                /* 인증번호 일치했을 때에만 휴대폰 번호 인증하는 화면 띄우기 */
                let phoneAuthVC = PhoneAuthViewController(idData: idData, pwData: pwData, pwCheckData: pwCheckData, nickNameData: nickNameData, university: university, emailId: emailId, uuid: uuid)
                
                phoneAuthVC.modalTransitionStyle = .crossDissolve
                phoneAuthVC.modalPresentationStyle = .fullScreen
                
                present(phoneAuthVC, animated: true)
            }
        }
    }
}


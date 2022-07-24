//
//  PhoneAuthVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/06.
//

import UIKit
import SnapKit

class PhoneAuthViewController: UIViewController {
    
    // MARK: - SubViews
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
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
    
    var phoneNumLabel = UILabel()
    var authLabel = UILabel()
    
    var phoneNumTextField = UITextField()
    var authTextField = UITextField()
    
    lazy var authSendButton: UIButton = {
        var button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setActivatedButton()
        button.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
        return button
    }()
    
    lazy var authCheckButton: UIButton = {
        var button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapAuthCheckButton), for: .touchUpInside)
        return button
    }()
    
    lazy var passButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        button.addTarget(self, action: #selector(tapPassButton), for: .touchUpInside)
        return button
    }()
    
    lazy var passView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(298)
        }
        
        /* top View: 건너뛰기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "건너뛰기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoRegular, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = UIColor(hex: 0x5B5B5B)
        cancelButton.titleLabel?.font = .customFont(.neoRegular, size: 15)
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(206)
            make.top.equalTo(topSubView.snp.bottom)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "본 단계에서는 앱 내의 커뮤니티와 프로필 등의 기능을 사용하기 위해 필요한 정보를 수집합니다.\n정보 입력이 완료되지 않을 시\n 앱 사용 범위가 제한될 수 있으며, 추후 입력이 가능함을 알립니다."
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .customFont(.neoRegular, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(193)
            make.height.equalTo(144)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.width.equalTo(230)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoRegular, size: 18)
        confirmButton.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        return view
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        return button
    }()
    
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
         nextButton, passButton,
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
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(15)
        }
        /* authTextField */
        authTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(authLabel.snp.bottom).offset(15)
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
        
        passButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.center)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
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
        phoneNumLabel = setMainLabelAttrs("휴대폰 번호 입력")
        authLabel = setMainLabelAttrs("인증번호 입력")
        
        /* textFields attr */
        phoneNumTextField = setTextFieldAttrs(msg: "- 제외 숫자만 입력하세요", width: 187)
        authTextField = setTextFieldAttrs(msg: "입력하세요", width: 187)
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }
    
    private func setTextFieldAttrs(msg: String, width: CGFloat) -> UITextField {
        let textField = UITextField()
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(width)
        return textField
    }
    
    private func setTextFieldTarget() {
        [phoneNumTextField, authTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        }
    }
    
    @objc func didChangeTextField() {
        if phoneNumTextField.text?.count ?? 0 >= 1 && authTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
            authCheckButton.setActivatedButton()
        } else {
            nextButton.setDeactivatedNextButton()
            authCheckButton.setDeactivatedButton()
        }
    }
    
    // 인증번호 일치/불일치 확인
    @objc func tapAuthCheckButton() {
        /* 인증번호 입력한 게 맞는지 "확인" 버튼 눌렀을 때 확인하는 것으로 변경. */
        if let phoneNum = phoneNumTextField.text,
           let authNum = authTextField.text {
            let input = PhoneAuthCheckInput(recipientPhoneNumber: phoneNum, verifyRandomNumber: authNum)
            PhoneAuthCheckViewModel.requestCheckPhoneAuth(self, input)
        }
    }
    
    @objc public func showNextView() {
        // 일치했을 때에만 화면 전환
        let agreementVC = AgreementViewController()

        agreementVC.modalTransitionStyle = .crossDissolve
        agreementVC.modalPresentationStyle = .fullScreen
        
        // 데이터 전달 (아이디, 비번, 확인비번, 닉네임, 학교이름, 이메일, 폰번호) 총 7개
        // 최종적으로 회원가입 Req를 보내는 AgreementVC까지 끌고 가야함
        if let idData = self.idData,
           let pwData = self.pwData,
           let pwCheckData = self.pwCheckData,
           let nickNameData = self.nickNameData,
           let univ = self.university,
           let emailId = self.emailId,
           let phoneNumberId = self.phoneNumberId {
            agreementVC.idData = idData
            agreementVC.pwData = pwData
            agreementVC.pwCheckData = pwCheckData
            agreementVC.nickNameData = nickNameData
            agreementVC.university = univ
            agreementVC.emailId = emailId
            agreementVC.phoneNumberId = phoneNumberId
        }
        
        present(agreementVC, animated: true)
    }
    
    /* 핸드폰번호 인증번호 전송 버튼 눌렀을 때 실행되는 함수 */
    @objc func tapAuthSendButton() {
        if let phoneNum = self.phoneNumTextField.text,
           let uuid = uuid {
            startTimer()
            authCheckButton.setActivatedButton()
            authSendButton.setTitle("재전송 하기", for: .normal)
            let input = PhoneAuthInput(recipientPhoneNumber: phoneNum, uuid: uuid.uuidString)
            print("DEBUG:", uuid.uuidString)
            PhoneAuthViewModel.requestSendPhoneAuth(self, input)
        }   // API 호출
    }
    
    @objc func tapPassButton() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
        
        view.addSubview(passView)
        passView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    @objc func tapCancelButton() {
        passView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
}
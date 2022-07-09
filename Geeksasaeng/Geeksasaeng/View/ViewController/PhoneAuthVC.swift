//
//  PhoneAuthVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/06.
//

import UIKit
import SnapKit

class PhoneAuthViewController: UIViewController {
    
    // MARK: - Subviews
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
    
    var authSendButton: UIButton = {
        var button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setActivatedButton()
        button.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
        return button
    }()
    
    var authResendButton: UIButton = {
        var button = UIButton()
        button.setTitle("재전송 하기", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapAuthResendButton), for: .touchUpInside)
        return button
    }()
    
    var passButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.makeBottomLine(55)
        button.addTarget(self, action: #selector(showPassView), for: .touchUpInside)
        return button
    }()
    
    var passView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(276)
            make.height.equalTo(284)
        }
        
        let titleLabel = UILabel()
        let lineView = UIView()
        let contentLabel = UILabel()
        let confirmButton = UIButton()
        
        [titleLabel, lineView, contentLabel, confirmButton].forEach {
            view.addSubview($0)
        }
        
        /* set titleLabel */
        titleLabel.text = "건너뛰기"
        titleLabel.textColor = .black
        titleLabel.font = .customFont(.neoRegular, size: 18)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        lineView.backgroundColor = UIColor.init(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(230)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        /* set contentLabel */
        contentLabel.text = "본 단계에서는 앱 내의 커뮤니티와 프로필 등의 기능을 사용하기 위해 필요한 정보를 수집합니다.\n정보 입력이 완료되지 않을 시\n 앱 사용 범위가 제한될 수 있으며, 추후 입력이 가능함을 알립니다."
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .customFont(.neoRegular, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(193)
            make.height.equalTo(144)
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(20)
        }
        
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 5
        confirmButton.backgroundColor = .mainColor
        confirmButton.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
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
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(checkPhoneAuthNum), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var idData: String!
    var pwData: String!
    var pwCheckData: String!
    var nickNameData: String!
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: DispatchSourceTimer?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setLayouts()
        setTextFieldTarget()
        startTimer()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        /* progress Bar */
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 4)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(25)
        }
        
        /* remain Bar */
        view.addSubview(remainBar)
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        
        view.addSubview(progressIcon)
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.top.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).inset(15)
        }
        
        view.addSubview(remainIcon)
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(36)
            make.top.equalTo(progressBar.snp.top).offset(-8)
            make.right.equalTo(remainBar.snp.right).offset(3)
        }
        
        /* labels */
        [
            phoneNumLabel,
            authLabel
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(27)
            }
        }
        /* phoneNumLabel */
        phoneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        /* authLabel */
        authLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(81)
        }
        
        /* text fields */
        [
            phoneNumTextField,
            authTextField,
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(36)
            }
        }
        /* phoneNumTextField */
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(15)
        }
        /* authTextField */
        authTextField.snp.makeConstraints { make in
            make.top.equalTo(authLabel.snp.bottom).offset(15)
        }
        
        /* authSendButton */
        view.addSubview(authSendButton)
        authSendButton.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        view.addSubview(authResendButton)
        authResendButton.snp.makeConstraints { make in
            make.bottom.equalTo(authTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
        
        view.addSubview(passButton)
        passButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.center)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
        }
        
        /* remainTimeLabel */
        view.addSubview(remainTimeLabel)
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(authTextField.snp.bottom).offset(21)
        } // authTextField 레이아웃 초기화 이후에 레이아웃 설정해줘야 하기 때문에 일단 뒤에 배치
    }
    
    private func startTimer() {
        if timer == nil {
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
        print("it works")
        if phoneNumTextField.text?.count ?? 0 >= 1 && authTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
    
    @objc func checkPhoneAuthNum() {
        /* 현재는 인증번호 입력한 게 맞는지도 다음 버튼을 눌렀을 때 확인함 -> 하지만 디자인 수정 가능성 있음. */
        // 인증번호 일치/불일치 확인
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
        present(agreementVC, animated: true)
    }
    
    /* 핸드폰번호 인증번호 전송 버튼 눌렀을 때 실행되는 함수 */
    @objc func tapAuthSendButton() {
        authSendButton.setDeactivatedButton()
        authResendButton.setActivatedButton()
        tapAuthResendButton()   // API 호출
    }
    
    // API를 통해 서버에 인증번호 전송을 요청하는 코드
    @objc func tapAuthResendButton() {
        if let phoneNum = self.phoneNumTextField.text {
            let input = PhoneAuthInput(recipientPhoneNumber: phoneNum)
            PhoneAuthViewModel.requestSendPhoneAuth(self, input)
        }
    }
    
    @objc func showPassView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        view.addSubview(passView)
        passView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
}

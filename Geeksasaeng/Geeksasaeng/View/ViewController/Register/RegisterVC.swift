//
//  RegisterViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

import SnapKit
import Then

class RegisterViewController: UIViewController {
    
    // MARK: - Subviews
    
    var progressBar = UIView().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 1.5
    }
    
    var remainBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xF2F2F2)
        $0.layer.cornerRadius = 1.5
    }
    
    var progressIcon = UIImageView(image: UIImage(named: "LogoTop"))
    var remainIcon = UIImageView(image: UIImage(named: "LogoBottom"))
    
    var idLabel = UILabel()
    var passwordLabel = UILabel()
    var passwordCheckLabel = UILabel()
    var nickNameLabel = UILabel()
    
    var idTextField = UITextField()
    lazy var pwTextField = UITextField().then {
        $0.addTarget(self, action: #selector(isValidPwTextField), for: .editingDidEnd)
    }
    lazy var pwCheckTextField = UITextField().then {
        $0.addTarget(self, action: #selector(isValidPwCheckTextField), for: .editingDidEnd)
    }
    var nickNameTextField = UITextField()
    
    var idAvailableLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    var passwordAvailableLabel = UILabel().then {
        $0.text = "문자, 숫자 및 특수문자 포함 8자 이상으로 입력해주세요"
        $0.textColor = .red
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    var passwordSameCheckLabel = UILabel().then {
        $0.text = "비밀번호를 다시 확인해주세요"
        $0.textColor = .red
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    var nickNameAvailableLabel = UILabel().then {
        $0.text = "사용 가능한 아이디입니다"
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    lazy var idCheckButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapIdCheckButton), for: .touchUpInside)
    }
    
    lazy var nickNameCheckButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapNickNameCheckButton), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    var idCheck = false
    var nicknameCheck = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        addSubViews()
        setLayouts()
        setTextFieldTarget()
        addRightSwipe()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            progressBar, remainBar, progressIcon, remainIcon,
            idLabel, passwordLabel, passwordCheckLabel, nickNameLabel,
            idTextField, pwTextField, pwCheckTextField, nickNameTextField,
            idAvailableLabel, passwordAvailableLabel, passwordSameCheckLabel, nickNameAvailableLabel,
            idCheckButton, nickNameCheckButton,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(25)
        }
        
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
        
        /* id */
        idLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        
        idCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.top.equalTo(remainBar.snp.bottom).offset(82)
        }
        
        idTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.right.equalTo(idCheckButton.snp.left).offset(-16)
            make.top.equalTo(idLabel.snp.bottom).offset(20)
        }
        
        idAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(idTextField.snp.bottom).offset(21)
        }
        
        /* password */
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(idAvailableLabel.snp.bottom).offset(31)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(27)
            make.top.equalTo(passwordLabel.snp.bottom).offset(20)
        }
        
        passwordAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(pwTextField.snp.bottom).offset(21)
        }
        
        /* password check */
        passwordCheckLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(passwordAvailableLabel.snp.bottom).offset(31)
        }
        
        pwCheckTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(27)
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(20)
        }
        
        passwordSameCheckLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(pwCheckTextField.snp.bottom).offset(21)
        }
        
        /* nickname */
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(passwordSameCheckLabel.snp.bottom).offset(31)
        }
        
        nickNameCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.top.equalTo(pwCheckTextField.snp.bottom).offset(73)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.right.equalTo(nickNameCheckButton.snp.left).offset(-16)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(20)
        }
        
        nickNameAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(21)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        setMainLabelAttrs(idLabel, "아이디")
        setMainLabelAttrs(passwordLabel, "비밀번호")
        setMainLabelAttrs(passwordCheckLabel, "비밀번호 확인")
        setMainLabelAttrs(nickNameLabel, "닉네임")
        
        /* textFields attr */
        setTextFieldAttrs(textField: idTextField, msg: "6-20자 영문+숫자로 입력", width: 210)
        setTextFieldAttrs(textField: pwTextField, msg: "문자, 숫자 및 특수문자 포함 8자 이상으로 입력", width: 307)
        setTextFieldAttrs(textField: pwCheckTextField, msg: "문자, 숫자 및 특수문자 포함 8자 이상으로 입력", width: 307)
        setTextFieldAttrs(textField: nickNameTextField, msg: "3-8자 영문 혹은 한글로 입력", width: 210)
        
        /* 중복확인 buttons attr */
        [idCheckButton, nickNameCheckButton].forEach {
            $0.setTitle("중복 확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.setDeactivatedButton()
        }
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ label: UILabel, _ text: String) {
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
    }
    
    private func setTextFieldAttrs(textField: UITextField, msg: String, width: CGFloat){
        // 색깔 설정
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        // 하단에 줄 생성
        textField.makeBottomLine()
        // 자동 대문자 해제
        textField.autocapitalizationType = .none
    }
    
    private func setTextFieldTarget() {
        [idTextField, pwTextField, pwCheckTextField, nickNameTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    // MARK: - @objc Functions
    
    // EmailAuthVC로 화면 전환.
    @objc private func showNextView() {
        if let idData = self.idTextField.text,
           let pwData = self.pwTextField.text,
           let pwCheckData = self.pwCheckTextField.text,
           let nickNameData = self.nickNameTextField.text {
            // 생성자를 통한 필수 데이터 전달
            let emailAuthVC = EmailAuthViewController(idData: idData, pwData: pwData, pwCheckData: pwCheckData, nickNameData: nickNameData)
            
            emailAuthVC.modalTransitionStyle = .crossDissolve
            emailAuthVC.modalPresentationStyle = .fullScreen
            
            // 화면 전환
            present(emailAuthVC, animated: true)
        }
    }
    
    @objc private func didChangeTextField(_ sender: UITextField) {
        guard let idCount = idTextField.text?.count,
              let nickNameCount = nickNameTextField.text?.count,
              let isValidPassword = pwTextField.text?.isValidPassword()
        else { return }
        
        /* 변경될 때마다 중복확인 다시 하기 위해 false로 */
        if sender == idTextField {
            idCheck = false
        } else if sender == nickNameTextField {
            nicknameCheck = false
        }
        
        if idCount >= 1 {
            idCheckButton.setActivatedButton()
        } else if idCount < 1 {
            idCheckButton.setDeactivatedButton()
        }
        
        if nickNameCount >= 1 {
            nickNameCheckButton.setActivatedButton()
        } else if nickNameCount < 1 {
            nickNameCheckButton.setDeactivatedButton()
        }
        
        if idCheck && nicknameCheck && isValidPassword && pwCheckTextField.text == pwTextField.text {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
    
    @objc private func tapIdCheckButton() {
        guard let isValidId = idTextField.text?.isValidId() else { return }
        
        if !isValidId {
            idAvailableLabel.text = "6-20자 영문+숫자로 입력"
            idAvailableLabel.textColor = .red
            idAvailableLabel.isHidden = false
        } else {
            if let id = idTextField.text {
                let input = IdRepetitionInput(loginId: id)
                RepetitionAPI.checkIdRepetition(input) { isSuccess, message in
                    switch isSuccess {
                    case .success:
                        self.idCheck = true
                        if self.idTextField.text?.isValidId() ?? false
                            && self.pwTextField.text?.isValidPassword() ?? false
                            && self.pwCheckTextField.text == self.pwTextField.text
                            && self.nicknameCheck {
                            self.nextButton.setActivatedNextButton()
                        }
                        self.idAvailableLabel.text = message
                        self.idAvailableLabel.textColor = .mainColor
                        self.idAvailableLabel.isHidden = false
                    case .onlyRequestSuccess:
                        self.idCheck = false
                        self.idAvailableLabel.text = message
                        self.idAvailableLabel.textColor = .red
                        self.idAvailableLabel.isHidden = false
                    case .failure:
                        print(message)
                    }
                }
            }
        }
    }
    
    @objc private func tapNickNameCheckButton() {
        guard let isValidNickname = nickNameTextField.text?.isValidNickname() else { return }
        
        if !isValidNickname {
            nickNameAvailableLabel.text = "3-8자 영문 혹은 한글로 입력"
            nickNameAvailableLabel.textColor = .red
            nickNameAvailableLabel.isHidden = false
        } else {
            if let nickname = nickNameTextField.text {
                let input = NickNameRepetitionInput(nickName: nickname)
                RepetitionAPI.checkNicknameRepetition(input) { isSuccess, message in
                    switch isSuccess {
                    case .success:
                        self.nicknameCheck = true
                        if self.idTextField.text?.isValidId() ?? false
                            && self.pwTextField.text?.isValidPassword() ?? false
                            && self.pwCheckTextField.text == self.pwTextField.text
                            && self.idCheck {
                            self.nextButton.setActivatedNextButton()
                        }
                        self.nickNameAvailableLabel.text = message
                        self.nickNameAvailableLabel.textColor = .mainColor
                        self.nickNameAvailableLabel.isHidden = false
                    case .onlyRequestSuccess:
                        self.nicknameCheck = true
                        self.nickNameAvailableLabel.text = message
                        self.nickNameAvailableLabel.textColor = .red
                        self.nickNameAvailableLabel.isHidden = false
                    case .failure:
                        print(message)
                    }
                }
            }
        }
    }
    
    // 중복 확인 버튼 눌렀을 때, validation 검사하고(불일치하면 return) id 중복 확인 API 호출
    @objc private func isValidPwTextField() {
        guard let isValidPassword = pwTextField.text?.isValidPassword() else { return }
        passwordAvailableLabel.isHidden = isValidPassword
    }
    
    // pw validation 검사
    @objc private func isValidPwCheckTextField() {
        passwordSameCheckLabel.isHidden = (pwCheckTextField.text == pwTextField.text)
    }
}

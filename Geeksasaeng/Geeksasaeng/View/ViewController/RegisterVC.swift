//
//  RegisterViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit
import Alamofire

class RegisterViewController: UIViewController {
    
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
    
    var idLabel = UILabel()
    var passwordLabel = UILabel()
    var passwordCheckLabel = UILabel()
    var nickNameLabel = UILabel()
    
    var idTextField = UITextField()
    var pwTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(isValidPwTextField), for: .editingDidEnd)
        return textField
    }()
    var pwCheckTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(isValidPwCheckTextField), for: .editingDidEnd)
        return textField
    }()
    var nickNameTextField = UITextField()
    
    var idAvailableLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.isHidden = true
        return label
    }()
    
    var passwordAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "문자, 숫자 및 특수문자 포함 8자 이상으로 입력해주세요"
        label.textColor = .red
        label.font = .customFont(.neoMedium, size: 13)
        label.isHidden = true
        return label
    }()
    
    var passwordSameCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 다시 확인해주세요"
        label.textColor = .red
        label.font = .customFont(.neoMedium, size: 13)
        label.isHidden = true
        return label
    }()
    
    var nickNameAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "사용 가능한 아이디입니다"
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 13)
        label.isHidden = true
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
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var idCheckButton:  UIButton = {
        let button = UIButton()
        button.setTitle("중복 확인", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setDeactivatedButton()
        button.addTarget(self, action: #selector(tapIdCheckButton), for: .touchUpInside)
        return button
    }()
    
    var nickNameCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복 확인", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setDeactivatedButton()
        button.addTarget(self, action: #selector(tapNickNameCheckButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var idCheck = false
    var nicknameCheck = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setLayouts()
        setTextFieldTarget()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        /* progress Bar */
        [progressBar, remainBar, progressIcon, remainIcon].forEach {
            view.addSubview($0)
        }
        
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
        
        /* id, password, passwordCheck, nickname */
        [
            idLabel, passwordLabel, passwordCheckLabel, nickNameLabel,
            idTextField, pwTextField, pwCheckTextField, nickNameTextField,
            idAvailableLabel, nickNameAvailableLabel, passwordAvailableLabel, passwordSameCheckLabel,
            idCheckButton, nickNameCheckButton,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
        
        /* id */
        idLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        
        idTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(idLabel.snp.bottom).offset(15)
        }
        
        idAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(idTextField.snp.bottom).offset(21)
        }
        
        idCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.top.equalTo(remainBar.snp.bottom).offset(82)
        }
        
        /* password */
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.top.equalTo(idAvailableLabel.snp.bottom).offset(31)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(passwordLabel.snp.bottom).offset(15)
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
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(15)
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
        
        nickNameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(15)
        }

        nickNameAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(21)
        }
        
        nickNameCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.top.equalTo(pwCheckTextField.snp.bottom).offset(73)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        idLabel = setMainLabelAttrs("아이디")
        passwordLabel = setMainLabelAttrs("비밀번호")
        passwordCheckLabel = setMainLabelAttrs("비밀번호 확인")
        nickNameLabel = setMainLabelAttrs("닉네임")
        
        /* textFields attr */
        setTextFieldAttrs(textField: idTextField, msg: "6-20자 영문+숫자로 입력", width: 210)
        idTextField.autocapitalizationType = .none
        setTextFieldAttrs(textField: pwTextField,msg: "문자, 숫자 및 특수문자 포함 8자 이상으로 입력",width: 307)
        pwTextField.autocapitalizationType = .none
        setTextFieldAttrs(textField: pwCheckTextField, msg: "문자, 숫자 및 특수문자 포함 8자 이상으로 입력",width: 307)
        pwCheckTextField.autocapitalizationType = .none
        setTextFieldAttrs(textField: nickNameTextField,msg: "3-8자 영문 혹은 한글로 입력",width: 210)
        nickNameTextField.autocapitalizationType = .none
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }
    
    private func setTextFieldAttrs(textField: UITextField, msg: String, width: CGFloat){
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(width)
    }
    
    private func setTextFieldTarget() {
        [idTextField, pwTextField, pwCheckTextField, nickNameTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    // EmailAuthVC로 화면 전환.
    @objc func showNextView() {
        let emailAuthVC = EmailAuthViewController()
        
        emailAuthVC.modalTransitionStyle = .crossDissolve
        emailAuthVC.modalPresentationStyle = .fullScreen
        
        // 데이터 전달
        if let idData = self.idTextField.text,
           let pwData = self.pwTextField.text,
           let pwCheckData = self.pwCheckTextField.text,
           let nickNameData = self.nickNameTextField.text {
            emailAuthVC.idData = idData
            emailAuthVC.pwData = pwData
            emailAuthVC.pwCheckData = pwCheckData
            emailAuthVC.nickNameData = nickNameData
        }
        
        present(emailAuthVC, animated: true)
    }
    
    @objc func didChangeTextField(_ sender: UITextField) {
        if sender == idTextField {
            idCheck = false
        } else if sender == nickNameTextField {
            nicknameCheck = false
        }
        
        if idTextField.text?.count ?? 0 >= 1 {
            idCheckButton.setActivatedButton()
        } else if idTextField.text?.count ?? 0 < 1 {
            idCheckButton.setDeactivatedButton()
        }
        if nickNameTextField.text?.count ?? 0 >= 1 {
            nickNameCheckButton.setActivatedButton()
        } else if nickNameTextField.text?.count ?? 0 < 1 {
            nickNameCheckButton.setDeactivatedButton()
        }
        
        if pwTextField.text?.isValidPassword() ?? false && pwCheckTextField.text == pwTextField.text
            && idCheck && nicknameCheck
        {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
    
    @objc func tapIdCheckButton() {
        if idTextField.text?.isValidId() ?? false == false {
            idAvailableLabel.text = "6-20자 영문+숫자로 입력"
            idAvailableLabel.textColor = .red
            idAvailableLabel.isHidden = false
        } else {
            if let id = idTextField.text {
                let input = IdRepetitionInput(loginId: id)
                RepetitionAPI.checkIdRepetition(self, parameters: input)
            }
        }
    }
    
    @objc func tapNickNameCheckButton() {
        if nickNameTextField.text?.isValidNickname() ?? false == false {
            nickNameAvailableLabel.text = "3-8자 영문 혹은 한글로 입력"
            nickNameAvailableLabel.textColor = .red
            nickNameAvailableLabel.isHidden = false
        } else {
            if let nickname = nickNameTextField.text {
                let input = NickNameRepetitionInput(nickName: nickname)
                RepetitionAPI.checkNicknameRepetition(self, parameters: input)
            }
        }
    }
    
    // 중복 확인 버튼 눌렀을 때, validation 검사하고(불일치하면 return) id 중복 확인 API 호출
    
    @objc func isValidPwTextField() {
        if !(pwTextField.text?.isValidPassword() ?? false) {
            passwordAvailableLabel.isHidden = false
        } else {
            passwordAvailableLabel.isHidden = true
        }
    }
    
    @objc func isValidPwCheckTextField() {
        if pwCheckTextField.text != pwTextField.text {
            passwordSameCheckLabel.isHidden = false
        } else {
            passwordSameCheckLabel.isHidden = true
        }
    }
}

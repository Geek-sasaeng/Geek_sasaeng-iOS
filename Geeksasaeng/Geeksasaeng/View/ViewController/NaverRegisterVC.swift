//
//  NaverRegisterVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/07.
//

import UIKit
import SnapKit

class NaverRegisterViewController: UIViewController {
    
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
    
    var nickNameLabel = UILabel()
    var schoolLabel = UILabel()
    var emailLabel = UILabel()
    
    var nickNameTextField = UITextField()
    var schoolTextField = UITextField()
    var emailTextField = UITextField()
    var emailAddressTextField = UITextField()
    
    var nickNameCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapNickNameCheckButton), for: .touchUpInside)
        return button
    }()
    
    var nickNameAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "사용 가능한 닉네임입니다"
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 13)
        label.isHidden = true
        return label
    }()
    
    var authSendButton: UIButton = {
        var button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
        return button
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setLayouts()
        setTextFieldTarget()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        /* progress Bar */
        [progressBar, remainBar, progressIcon, remainIcon].forEach {
            view.addSubview($0)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 3)
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
        
        /* labels */
        [
            nickNameLabel,
            schoolLabel,
            emailLabel,
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(27)
            }
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(108)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(81)
        }
        
        /* text fields */
        [
            nickNameTextField,
            schoolTextField,
            emailTextField,
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(36)
            }
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(15)
        }
        
        schoolTextField.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(15)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(emailAddressTextField)
        emailAddressTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(36)
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
        }
        
        /* nickNameAvailableLabel */
        view.addSubview(nickNameAvailableLabel)
        nickNameAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(21)
        }
        
        /* nextButton */
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
        
        /* nickNameCheckButton */
        view.addSubview(nickNameCheckButton)
        nickNameCheckButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(82)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
        }
        
        /* authSendButton */
        view.addSubview(authSendButton)
        authSendButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailAddressTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        nickNameLabel = setMainLabelAttrs("닉네임")
        schoolLabel = setMainLabelAttrs("학교 선택")
        emailLabel = setMainLabelAttrs("학교 이메일 입력")
        
        /* textFields attr */
        nickNameTextField = setTextFieldAttrs(msg: "3-8자 영문으로 입력", width: 210)
        schoolTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailAddressTextField = setTextFieldAttrs(msg: "@", width: 187)
    }
    
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
        [nickNameTextField, schoolTextField, emailTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    @objc func tapNickNameCheckButton() {
        nickNameCheckButton.setDeactivatedButton()
        nickNameAvailableLabel.isHidden = false
    }
    
    @objc func tapAuthSendButton() {
        authSendButton.setDeactivatedButton()
        self.showToast(viewController: self, message: "인증번호가 전송되었습니다.", font: .customFont(.neoMedium, size: 15), color: .mainColor)
    }
    
    // EmailAuthVC로 화면 전환.
    @objc func showNextView() {
        let authNumVC = AuthNumViewController()
        
        authNumVC.modalTransitionStyle = .crossDissolve
        authNumVC.modalPresentationStyle = .fullScreen
        authNumVC.fromNaverRegister = true
        
        present(authNumVC, animated: true)
    }
    
    @objc func didChangeTextField(_ sender: UITextField) {
        if nickNameTextField.text?.count ?? 0 >= 1 {
            nickNameCheckButton.setActivatedButton()
        } else if nickNameTextField.text?.count ?? 0 < 1 {
            nickNameCheckButton.setDeactivatedButton()
        }
        
        if emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            authSendButton.setActivatedButton()
        } else if emailAddressTextField.text?.count ?? 0 < 1 {
            authSendButton.setDeactivatedButton()
        }

        if nickNameTextField.text?.count ?? 0 >= 1 && schoolTextField.text?.count ?? 0 >= 1 &&
            emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
}

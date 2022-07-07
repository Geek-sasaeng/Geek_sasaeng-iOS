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
        return button
    }()
    
//    var 건너띄기Button: UIButton = {
//        let button = UIButton()
//        button.setTitle("회원가입", for: .normal)
//        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
//        button.titleLabel?.font = .customFont(.neoLight, size: 15)
//        button.makeBottomLine(55)
//        button.addTarget(self, action: #selector(showRegisterView), for: .touchUpInside)
//        return button
//    }()
    
    var nextButton: UIButton = {
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
    
    // MARK: - Properties
    
    var idData: String!
    var pwData: String!
    var pwCheckData: String!
    var nickNameData: String!
    
    
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
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(260) // step = 65 -> device 가로 길이 / 5로 수정
//            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 4)
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
    
    @objc func showNextView() {
        let agreementVC = AgreementViewController()
        
        agreementVC.modalTransitionStyle = .crossDissolve
        agreementVC.modalPresentationStyle = .fullScreen
        present(agreementVC, animated: true)
    }
    
    @objc func tapAuthSendButton() {
        authSendButton.setDeactivatedButton()
        authResendButton.setActivatedButton()
    }
}

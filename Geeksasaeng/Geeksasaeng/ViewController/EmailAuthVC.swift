//
//  EmailAuthVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

class EmailAuthViewController: UIViewController {
    
    // MARK: - Subviews
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        return view
    }()
    
    var schoolLabel = UILabel()
    var emailLabel = UILabel()
    
    var schoolTextField = UITextField()
    var emailTextField = UITextField()
    var emailAddressTextField = UITextField()
    
    var authSendButton: UIButton = {
        var button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.isEnabled = false
        button.clipsToBounds = true
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
            make.width.equalTo(124)
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
        
        /* labels */
        [
            schoolLabel,
            emailLabel
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(27)
            }
        }
        /* schoolLabel */
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        /* emailLabel */
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(81)
        }
        
        /* text fields */
        [
            schoolTextField,
            emailTextField,
            emailAddressTextField
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(36)
            }
        }
        /* schoolTextField */
        schoolTextField.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(15)
        }
        /* emailTextField */
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
        }
        /* emailAddressTextField */
        emailAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
        }
        
        /* authSendButton */
        view.addSubview(authSendButton)
        authSendButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(243)
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
        schoolLabel = setMainLabelAttrs("학교 선택")
        emailLabel = setMainLabelAttrs("이메일 입력")
        
        /* textFields attr */
        schoolTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailAddressTextField = setTextFieldAttrs(msg: "@", width: 187)
        
        /* authSendButton attr */
        //        authSendButton = setAuthSendButtonAttrs()
        //        makeButtonShadow(authSendButton)
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
    
    // 인증번호 전송 버튼 속성 설정
    //    private func setAuthSendButtonAttrs() -> UIButton {
    //        let button = UIButton()
    //        button.setTitle("인증번호 전송", for: .normal)
    //        button.setTitleColor(.mainColor, for: .normal)
    //        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
    //        button.layer.cornerRadius = 5
    //        button.backgroundColor = .white
    //        button.clipsToBounds = true
    //        return button
    //    }
    
    private func setAuthSendButtonAttrs(_ button: UIButton) {
        button.isEnabled = true
        button.setTitleColor(.mainColor, for: .normal)
        button.backgroundColor = .white
    }
    
    private func unSetAuthSendButtonAttrs(_ button: UIButton) {
        button.isEnabled = false
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
    }
    
    // 버튼 뒤의 mainColor의 Shadow를 만드는 함수
    private func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    private func removeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 0
    }
    
    private func setTextFieldTarget() {
        [schoolTextField, emailTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    @objc func showNextView() {
        let authNumVC = AuthNumViewController()
        
        sendRegisterRequest()
        
        authNumVC.modalTransitionStyle = .crossDissolve
        authNumVC.modalPresentationStyle = .fullScreen
        present(authNumVC, animated: true)
    }
    
    @objc func didChangeTextField(_ sender: UITextField) {
        if schoolTextField.text?.count ?? 0 >= 1 && emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            nextButton.isEnabled = true
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = .mainColor
            setAuthSendButtonAttrs(authSendButton)
            makeButtonShadow(authSendButton)
        } else {
            nextButton.isEnabled = false
            nextButton.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            nextButton.backgroundColor = UIColor(hex: 0xEFEFEF)
            unSetAuthSendButtonAttrs(authSendButton)
            removeButtonShadow(authSendButton)
        }
    }
    
    func sendRegisterRequest() {
        // Request 생성.
        guard let school = self.schoolTextField.text,
              let email = self.emailTextField.text,
              let emailAddress = self.emailAddressTextField.text
        else { return }
        
        let input = RegisterInput(checkPassword: pwCheckData,
                                  email: email+emailAddress,
                                  loginId: idData,
                                  nickname: nickNameData,
                                  password: pwData,
                                  phoneNumber: "01012341234",
                                  universityName: school)
        
        RegisterManager.registerUser(self, input)
    }
}

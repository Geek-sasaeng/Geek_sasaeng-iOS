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
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 2)
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
        emailLabel = setMainLabelAttrs("학교 이메일 입력")
        
        /* textFields attr */
        schoolTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailAddressTextField = setTextFieldAttrs(msg: "@", width: 187)
        emailAddressTextField.isUserInteractionEnabled = false  // 유저가 입력하는 것이 아니라 학교에 따라 자동 설정되는 것.
        // TODO: emailAddress -> UILabel로 바뀌어야 할 듯
        emailAddressTextField.text = "@gachon.ac.kr"   //test
        
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
    
    private func setTextFieldTarget() {
        [schoolTextField, emailTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    @objc func didChangeTextField(_ sender: UITextField) {
        if schoolTextField.text?.count ?? 0 >= 1 && emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
            authSendButton.setActivatedButton()
        } else {
            nextButton.setDeactivatedNextButton()
            authSendButton.setDeactivatedButton()
        }
    }
    
    @objc private func tapAuthSendButton() {
        if let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let univ = schoolTextField.text {    // 값이 들어 있어야 괄호 안의 코드 실행 가능
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)
            let input = EmailAuthInput(email: email+emailAddress, university: univ)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(self, input)
        }
    }
    
    @objc func showNextView() {
        let authNumVC = AuthNumViewController()
        
        authNumVC.modalTransitionStyle = .crossDissolve
        authNumVC.modalPresentationStyle = .fullScreen
        
        // 학교 정보랑 학교 이메일 정보 넘겨줘야 한다 -> 재전송 하기 버튼 때문에
        authNumVC.university = schoolTextField.text!
        authNumVC.email = emailTextField.text! + "@gachon.ac.kr"
        
        present(authNumVC, animated: true)
    }
    
    // TODO: 이거 마지막 화면으로 옮겨야 됨. 회원가입 완료하는 함수.
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
        
        RegisterAPI.registerUser(self, input)
    }
}

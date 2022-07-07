//
//  RegisterViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

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
    var pwTextField = UITextField()
    var pwCheckTextField = UITextField()
    var nickNameTextField = UITextField()
    
    var idAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "사용 가능한 아이디입니다"
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
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var idCheckButton = UIButton()
    
    var nickNameCheckButton = UIButton()
    
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
            make.width.equalTo(66) // 1/5 -> 62
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
            idLabel,
            passwordLabel,
            passwordCheckLabel,
            nickNameLabel
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(27)
            }
        }
        /* idLabel */
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        
        /* passwordLabel */
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(108)
        }
        
        /* passwordCheckLabel */
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(81)
        }
        
        /* nickNameLabel */
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(81)
        }
        
        /* text fields */
        [
            idTextField,
            pwTextField,
            pwCheckTextField,
            nickNameTextField
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(36)
            }
        }
        /* idTextField */
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(15)
        }
        /* pwTextField */
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(15)
        }
        /* pwCheckTextField */
        pwCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(15)
        }
        /* nickNameTextField */
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(15)
        }
        
        /* idAvailableLabel */
        view.addSubview(idAvailableLabel)
        idAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(idTextField.snp.bottom).offset(21)
        }
        
        /* nextButton */
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
        
        /* 중복 확인 버튼 */
        [
            idCheckButton,
            nickNameCheckButton
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(26)
                make.width.equalTo(81)
                make.height.equalTo(41)
            }
        }
        /* idCheckButton */
        idCheckButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(82)
        }
        /* nickNameCheckButton */
        nickNameCheckButton.snp.makeConstraints { make in
            make.top.equalTo(pwCheckTextField.snp.bottom).offset(73)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        idLabel = setMainLabelAttrs("아이디")
        passwordLabel = setMainLabelAttrs("비밀번호")
        passwordCheckLabel = setMainLabelAttrs("비밀번호 확인")
        nickNameLabel = setMainLabelAttrs("닉네임")
        
        /* textFields attr */
        idTextField = setTextFieldAttrs(width: 210)
        pwTextField = setTextFieldAttrs(width: 307)
        pwCheckTextField = setTextFieldAttrs(width: 307)
        nickNameTextField = setTextFieldAttrs(width: 210)
        
        /* 중복 확인 버튼 attrs */
        setRedundancyCheckButtonAttrs(idCheckButton)
        setRedundancyCheckButtonAttrs(nickNameCheckButton)
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }
    
    private func setTextFieldAttrs(width: CGFloat) -> UITextField {
        let textField = UITextField()
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "3-15자 영문으로 입력",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(width)
        return textField
    }
    
    func setRedundancyCheckButtonAttrs(_ button: UIButton) {
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.isEnabled = false
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
        
        if idTextField.text?.count ?? 0 >= 1 && pwTextField.text?.count ?? 0 >= 1 &&
            pwCheckTextField.text?.count ?? 0 >= 1 && nickNameTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
}

// MARK: - UITextField extension

extension UITextField {
    
    // UITextField의 아래 라인 만들어주는 함수
    func makeBottomLine(_ width: CGFloat) {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(hex: 0xEFEFEF)
        borderStyle = .none
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(10)
            make.left.equalTo(-8)
            make.width.equalTo(width)
            make.height.equalTo(1)
        }
    }
    
}

extension UIButton {
    
    // UIButton의 아래 라인 만들어주는 함수
    func makeBottomLine(_ width: CGFloat) {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(hex: 0x5B5B5B)
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(-8)
            make.width.equalTo(width)
            make.height.equalTo(1)
        }
    }
    
    func setActivatedNextButton() {
        self.isEnabled = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .mainColor
    }
    
    func setDeactivatedNextButton() {
        self.isEnabled = false
        self.tintColor = UIColor(hex: 0xA8A8A8)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
    }
    
    func setActivatedButton() {
        self.isEnabled = true
        self.setTitleColor(.mainColor, for: .normal)
        self.backgroundColor = .white
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.mainColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
    
    func setDeactivatedButton() {
        self.isEnabled = false
        self.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
        self.layer.shadowRadius = 0
    }
}

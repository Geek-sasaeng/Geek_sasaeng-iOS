//
//  PasswordCheckVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/11/05.
//

import UIKit

import SnapKit
import Then

class PasswordCheckViewController: UIViewController {
    
    // MARK: - Properties
    
    /* 이전 뷰에서 받아오는 properties */
    var dormitoryId: Int?
    var loginId: String?
    var nickname: String?
    var profileImg: UIImage?
    
    // MARK: - SubViews
    
    /* titleLabel: 본인 확인하기 */
    let titleLabel = UILabel().then {
        $0.text = "본인 확인하기"
        $0.font = .customFont(.neoMedium, size: 18)
        $0.textColor = .black
    }
    
    /* backbutton */
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    /* 파티 채팅방 이름 입력하는 텍스트 필드 */
    lazy var passwordTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "기존 비밀번호를 입력해 주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)])
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.isSecureTextEntry = true
        $0.addTarget(self, action: #selector(changeValuePasswordTextField), for: .editingChanged)
        $0.returnKeyType = .done
        $0.delegate = self
    }
    
    let passwordCheckLabel = UILabel().then {
        $0.text = "비밀번호가 다릅니다"
        $0.textColor = .red
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    /* 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
//        $0.backgroundColor = .mainColor
        $0.setDeactivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setNotificationCenter()
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("ClosePasswordCheckVC"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }

    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(274)
        }
    }
    
    private func addSubViews() {
        [
            titleLabel, backButton,
            passwordTextField, passwordCheckLabel,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(37)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(248)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(18)
            make.left.equalTo(passwordTextField.snp.left)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
            make.width.equalTo(262)
            make.height.equalTo(51)
        }
    }
    
    // MARK: - @objc Functions
    
    /* 다음 버튼 누르면 실행되는 함수 */
    @objc
    private func tapNextButton() {
        MyLoadingView.shared.show()
        
        guard let password = passwordTextField.text else { return }
        let passwordInput = PasswordCheckInput(password: password)
        
        UserInfoAPI.passwordCheck(passwordInput) { isSuccess in
            MyLoadingView.shared.hide()
            
            if isSuccess { // 비밀번호 맞았을 때 -> 수정 화면으로 이동
                NotificationCenter.default.post(name: NSNotification.Name("CorrectPassword"), object: "true")
                let changePasswordVC = ChangePasswordViewController().then {
                    $0.dormitoryId = self.dormitoryId
                    $0.loginId = self.loginId
                    $0.nickname = self.nickname
                    $0.profileImg = self.profileImg
                }
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                self.tapBackButton()
            } else { // 비밀번호 틀렸을 때 -> TextField 하단에 notice
                self.passwordCheckLabel.isHidden = false
                self.passwordTextField.subviews.first?.backgroundColor = .red
            }
        }
    }
    
    /* 백버튼 눌렀을 때 실행 -> 이전 화면으로 돌아간다 */
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
        NotificationCenter.default.post(name: NSNotification.Name("TapBackButtonOfPasswordCheckVC"), object: "true")
    }
    
    @objc
    private func changeValuePasswordTextField() {
        guard let password = passwordTextField.text else { return }
        if password.count >= 1 {
            nextButton.setActivatedNextButton()
        }
    }
}

// MARK: - UITextFieldDelegate

extension PasswordCheckViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

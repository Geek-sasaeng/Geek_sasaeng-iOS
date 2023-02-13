//
//  ChangePasswordVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class ChangePasswordViewController: UIViewController {
    // MARK: - Properties
    /* 이전 뷰에서 받아오는 properties */
    var dormitoryId: Int?
    var loginId: String?
    var nickname: String?
    var profileImg: UIImage?
    
    /* 이 뷰에서 사용자에게 받는 properties */
    var password: String?
    var checkPassword: String?
    
    
    // MARK: - SubViews
    let deactivatedRightBarButtonItem = UIBarButtonItem().then {
        let registerButton = UIButton().then {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        }
        $0.customView = registerButton
        $0.isEnabled = false
    }
    
    /* title labels */
    let passwordLabel = UILabel()
    let passwordCheckLabel = UILabel()
    
    /* data textField */
    lazy var passwordDataTextField = UITextField()
    lazy var passwordCheckDataTextField = UITextField()
    
    /* textField 아래 notice label */
    let passwordChangeValidationLabel = UILabel()
    let passwordCheckValidationLabel = UILabel()
    
    /* password TextField 표시 버튼 */
    let showPasswordChangeTextFieldButton = UIButton()
    let showPasswordCheckTextFieldButton = UIButton()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setNavigationBar()
        addSubViews()
        setLayouts()
    }
    
    
    // MARK: - Functions
    private func setAttributes() {
        passwordLabel.text = "비밀번호 변경"
        passwordCheckLabel.text = "비밀번호 확인"
        
        [ passwordLabel, passwordCheckLabel ].forEach {
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
        }
        
        /* 비밀번호 표시 버튼 공통 설정 */
        [ showPasswordCheckTextFieldButton, showPasswordChangeTextFieldButton ].forEach {
            $0.setImage(UIImage(named: "BlockTextIcon"), for: .normal)
            $0.addTarget(self, action: #selector(tapShowTextIcon(sender: )), for: .touchUpInside)
        }
        
        /* 비밀번호 입력 텍스트 필드 입력 값 가리기 */
        [ passwordDataTextField, passwordCheckDataTextField ].forEach {
            $0.isSecureTextEntry = true
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 15)
            $0.makeBottomLine()
            $0.delegate = self
        }
        
        [ passwordChangeValidationLabel, passwordCheckValidationLabel ].forEach {
            $0.textColor = .mainColor
            $0.font = .customFont(.neoMedium, size: 13)
            $0.isHidden = true
        }
        
        passwordChangeValidationLabel.text = "문자, 숫자 및 특수문자 포함 8자 이상으로 입력해주세요"
        passwordCheckValidationLabel.text = "비밀번호가 다릅니다. 다시 확인해주세요"
    }
    
    private func setNavigationBar() {
        navigationItem.title = "비밀번호 변경"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(hex: 0x2F2F2F)]
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
    }
    
    private func addSubViews() {
        [
            passwordLabel, passwordCheckLabel,
            passwordDataTextField, passwordCheckDataTextField,
            passwordChangeValidationLabel, passwordCheckValidationLabel,
            showPasswordChangeTextFieldButton, showPasswordCheckTextFieldButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        passwordDataTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(passwordLabel.snp.bottom).offset(20)
        }
        passwordChangeValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordDataTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(23)
        }
        showPasswordChangeTextFieldButton.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(12.25)
            make.right.equalToSuperview().inset(35)
            make.centerY.equalTo(passwordDataTextField.snp.centerY)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordChangeValidationLabel.snp.bottom).offset(19)
            make.left.equalTo(passwordLabel.snp.left)
        }
        passwordCheckDataTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(20)
        }
        passwordCheckValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckDataTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(23)
        }
        showPasswordCheckTextFieldButton.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(12.25)
            make.right.equalToSuperview().inset(35)
            make.centerY.equalTo(passwordCheckDataTextField.snp.centerY)
        }
    }
    
    private func activeRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRightBarButton))
        navigationItem.rightBarButtonItem?.tintColor = .mainColor
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapShowTextIcon(sender: UIButton) {
        switch sender {
        case showPasswordCheckTextFieldButton: // passwordCheck TextField에 있는 Button
            if sender.imageView?.image == UIImage(named: "BlockTextIcon") { // secure 상태일 때
                sender.setImage(UIImage(named: "ShowTextIcon"), for: .normal)
                passwordCheckDataTextField.isSecureTextEntry = false // secure 해제
            } else { // secure 상태가 아닐 때
                sender.setImage(UIImage(named: "BlockTextIcon"), for: .normal)
                passwordCheckDataTextField.isSecureTextEntry = true // secure 적용
            }
        default: // passwordChange TextField에 있는 Button
            if sender.imageView?.image == UIImage(named: "BlockTextIcon") { // secure 상태일 때
                sender.setImage(UIImage(named: "ShowTextIcon"), for: .normal)
                passwordDataTextField.isSecureTextEntry = false // secure 해제
            } else { // secure 상태가 아닐 때
                sender.setImage(UIImage(named: "BlockTextIcon"), for: .normal)
                passwordDataTextField.isSecureTextEntry = true // secure 적용
            }
        }
    }
    
    @objc
    private func tapRightBarButton() {
        MyLoadingView.shared.show()
        
        let input = EditPasswordInput(
            checkNewPassword: self.checkPassword,
            newPassword: self.password
        )
        
        UserInfoAPI.editPassword(input) { isSuccess in
            MyLoadingView.shared.hide()
            
            if isSuccess {
                // 0번째 인덱스(= 프로필 VC) 화면으로 이동
                let controller = self.navigationController?.viewControllers[0]
                self.navigationController?.popToViewController(controller!, animated: true)
                // 프로필 VC에 토스트 메세지 띄우기
                NotificationCenter.default.post(name: NSNotification.Name("CompleteChangingPw"), object: nil)
            } else {
                self.showToast(viewController: self, message: "비밀번호 변경에 실패하였습니다", font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8), width: 250)
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case passwordDataTextField:
            passwordChangeValidationLabel.isHidden = false
        case passwordCheckDataTextField:
            passwordCheckValidationLabel.isHidden = false
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case passwordDataTextField:
            if let isValidPassword = passwordDataTextField.text?.isValidPassword() {
                if isValidPassword == false { // password validation에 적합하지 않다면
                    passwordDataTextField.subviews.first?.backgroundColor = .red
                    passwordChangeValidationLabel.textColor = .red
                } else {
                    password = passwordDataTextField.text
                    passwordChangeValidationLabel.isHidden = true
                    passwordDataTextField.subviews.first?.backgroundColor = .init(hex: 0xEFEFEF)
                }
            }
        case passwordCheckDataTextField:
            guard let passwordCheckText = passwordCheckDataTextField.text else { return }
            if passwordCheckText == passwordDataTextField.text { // 비밀번호가 같다면
                checkPassword = passwordCheckText
                passwordCheckValidationLabel.isHidden = true
                passwordCheckDataTextField.subviews.first?.backgroundColor = .init(hex: 0xEFEFEF)
                activeRightBarButton()
            } else {
                passwordCheckDataTextField.subviews.first?.backgroundColor = .red
                passwordCheckValidationLabel.textColor = .red
                passwordCheckValidationLabel.text = "비밀번호가 다릅니다"
            }
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case passwordCheckDataTextField:
            guard let str = textField.text else { return true }
            if (str + string) == self.passwordDataTextField.text ?? "" {
                self.activeRightBarButton()
                self.passwordCheckValidationLabel.isHidden = true
                passwordCheckDataTextField.subviews.first?.backgroundColor = .init(hex: 0xEFEFEF)
            }
            
            return true
        default:
            return true
        }
    }
}

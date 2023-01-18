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
    
    /* 수정 완료하기 View */
    lazy var editConfirmView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "수정 완료하기"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "지금 수정하신 정보로\n수정을 완료할까요?"
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapEditConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
    }
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        passwordChangeValidationLabel.text = "6-20자 영문+숫자로 입력해주세요"
        passwordCheckValidationLabel.text = "비밀번호를 다시 확인해주세요"
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
            showPasswordChangeTextFieldButton, showPasswordCheckTextFieldButton,
            editConfirmView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(119)
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
    
    private func createBlurView() {
        if visualEffectView == nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            visualEffectView.layer.opacity = 0.6
            visualEffectView.frame = view.frame
            visualEffectView.isUserInteractionEnabled = false
            view.addSubview(visualEffectView)
            self.visualEffectView = visualEffectView
        }
    }
    
    // MARK: - objc Functions
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
    private func tapEditConfirmButton() {
        let input = EditUserInput(
            checkPassword: self.checkPassword,
            dormitoryId: self.dormitoryId,
            loginId: self.loginId,
            nickname: self.nickname,
            password: self.password
        )
        
        UserInfoAPI.editUser(input, imageData: profileImg!) { isSuccess, result in
            if isSuccess {
                print("회원정보 수정 완료")
                self.editConfirmView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showToast(viewController: self, message: "회원정보 수정 실패", font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8))
                print("회원정보 수정 실패")
                self.editConfirmView.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func tapRightBarButton() {
        if visualEffectView == nil {
            createBlurView()
            view.addSubview(editConfirmView)
            editConfirmView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(256)
                make.height.equalTo(202)
            }
        }
    }
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapXButton() {
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
        editConfirmView.removeFromSuperview()
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
}

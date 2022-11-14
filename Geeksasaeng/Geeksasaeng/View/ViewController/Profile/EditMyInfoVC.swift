//
//  EditMyInfoVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/11/08.
//

import UIKit
import SnapKit
import Then

class EditMyInfoViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - SubViews
    
    /* 우측 하단 BarButton */
    let deactivatedRightBarButtonItem = UIBarButtonItem().then {
        let registerButton = UIButton().then {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        }
        $0.customView = registerButton
        $0.isEnabled = false
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
    }
    
    let userImageView = UIImageView().then {
        $0.image = UIImage(named: "EditUserImage")
    }
    
    /* title labels */
    let dormitoryLabel = UILabel()
    let nicknameLabel = UILabel()
    let idLabel = UILabel()
    let passwordLabel = UILabel()
    let passwordCheckLabel = UILabel()
    
    /* content labels */
    let dormitoryDataLabel = PaddingLabel().then {
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 15)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.paddingTop = 7
        $0.paddingBottom = 7
        $0.paddingLeft = 15
        $0.paddingRight = 15
    }
    
    /* Data TextField */
    lazy var nicknameDataTextField = UITextField()
    lazy var idDataTextField = UITextField()
    lazy var passwordDataTextField = UITextField()
    lazy var passwordCheckDataTextField = UITextField()
    
    /* TextField 아래 Notice Label*/
    let nicknameValidationLabel = UILabel()
    let idValidationLabel = UILabel()
    let passwordChangeValidationLabel = UILabel()
    let passwordCheckValidationLabel = UILabel()
    
    /* 중복확인 버튼 (닉네임, 아이디) */
    let nicknameCheckButton = UIButton()
    let idCheckButton = UIButton()
    
    /* password TextField 표시 버튼 */
    let showPasswordChangeTextFieldButton = UIButton()
    let showPasswordCheckTextFieldButton = UIButton()
    
    /* Edit Button */
    let editNicknameButton = UIButton()
    let editIdButton = UIButton()
    let editPasswordChangeButton = UIButton()
    let editPasswordCheckButton = UIButton()
    
    // MARK: - Properties
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        setNavigationBar()
        setAttributes()
        addSubViews()
        setLayouts()
        setUserInfo()
    }
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavigationBar() {
        navigationItem.title = "수정하기"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(hex: 0x2F2F2F)]
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .mainColor
    }
    
    private func setAttributes() {
        /* 각 항목 타이틀 라벨 공통 설정 */
        [dormitoryLabel, nicknameLabel, idLabel, passwordLabel, passwordCheckLabel].forEach {
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
        }
        
        /* 중복 확인 버튼 공통 설정 */
        [nicknameCheckButton, idCheckButton].forEach {
            $0.setTitle("중복 확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.setDeactivatedButton()
            $0.setTitleColor(.init(hex: 0xD8D8D8), for: .normal)
            $0.backgroundColor = .white
        }
        
        /* 비밀번호 표시 버튼 공통 설정 */
        [showPasswordCheckTextFieldButton, showPasswordChangeTextFieldButton].forEach {
            $0.setImage(UIImage(named: "BlockTextIcon"), for: .normal)
            $0.addTarget(self, action: #selector(tapShowTextIcon(sender: )), for: .touchUpInside)
        }
        
        /* 수정 버튼 공통 설정 */
        [editNicknameButton, editIdButton, editPasswordChangeButton, editPasswordCheckButton].forEach {
            $0.setTitle("Test", for: .normal)
            $0.setImage(UIImage(named: "EditInfoButton"), for: .normal)
        }
        
        /* 각 항목 타이틀 설정 */
        dormitoryLabel.text = "기숙사"
        nicknameLabel.text = "닉네임"
        idLabel.text = "아이디"
        passwordLabel.text = "비밀번호 변경"
        passwordCheckLabel.text = "비밀번호 확인"
        
        /* 비밀번호는 일단 더미 데이터 -> API res에 추가해야 할 듯 */
        /* placeholder로 할 경우 -> 비밀번호 placeholder 보안은 비밀번호 길이만큼 dots를 추가해야 할 듯 */
        passwordDataTextField.text = "password123!"
        passwordCheckDataTextField.text = "password123!"
        
        /* 비밀번호 입력 텍스트 필드 입력 값 가리기 */
        [passwordDataTextField, passwordCheckDataTextField].forEach {
            $0.isSecureTextEntry = true
        }

        /* 각 항목 데이터 텍스트 필드 공통 설정 */
        [nicknameDataTextField, idDataTextField, passwordDataTextField, passwordCheckDataTextField].forEach {
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 15)
            $0.makeBottomLine()
            $0.delegate = self
        }
        
        /* 텍스트 필드 아래 설명문 라벨 공통 설정 */
        [nicknameValidationLabel, idValidationLabel, passwordChangeValidationLabel, passwordCheckValidationLabel].forEach {
            $0.textColor = .mainColor
            $0.font = .customFont(.neoMedium, size: 13)
            $0.isHidden = true
        }
        nicknameValidationLabel.text = "3-8자 영문 혹은 한글로 입력해주세요"
        idValidationLabel.text = "6-20자 영문+숫자로 입력해주세요"
        passwordChangeValidationLabel.text = "6-20자 영문+숫자로 입력해주세요"
        passwordCheckValidationLabel.text = "비밀번호를 다시 확인해주세요"
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            userImageView,
            dormitoryLabel, dormitoryDataLabel,
            nicknameLabel, nicknameDataTextField, nicknameCheckButton, editNicknameButton, nicknameValidationLabel,
            idLabel, idDataTextField, idCheckButton, editIdButton, idValidationLabel,
            passwordLabel, passwordDataTextField, showPasswordChangeTextFieldButton, editPasswordChangeButton, passwordChangeValidationLabel,
            passwordCheckLabel, passwordCheckDataTextField, showPasswordCheckTextFieldButton, editPasswordCheckButton, passwordCheckValidationLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(passwordCheckDataTextField.snp.bottom).offset(80)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.width.height.equalTo(166)
            make.centerX.equalToSuperview()
        }
        
        dormitoryLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(64)
            make.left.equalToSuperview().inset(23)
        }
        dormitoryDataLabel.snp.makeConstraints { make in
            make.top.equalTo(dormitoryLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(dormitoryDataLabel.snp.bottom).offset(47)
            make.left.equalToSuperview().inset(23)
        }
        nicknameDataTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(nicknameCheckButton.snp.left).offset(-17)
        }
        editNicknameButton.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.right.equalTo(nicknameCheckButton.snp.left).offset(-28)
            make.centerY.equalTo(nicknameDataTextField.snp.centerY)
        }
        nicknameCheckButton.snp.makeConstraints { make in
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.centerY.equalTo(nicknameDataTextField.snp.centerY)
            make.right.equalToSuperview().inset(25)
        }
        nicknameValidationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.top.equalTo(nicknameDataTextField.snp.bottom).offset(18)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameDataTextField.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        idDataTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(idCheckButton.snp.left).offset(-17)
        }
        editIdButton.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.right.equalTo(idCheckButton.snp.left).offset(-28)
            make.centerY.equalTo(idDataTextField.snp.centerY)
        }
        idCheckButton.snp.makeConstraints { make in
            make.width.equalTo(81)
            make.height.equalTo(41)
            make.centerY.equalTo(idDataTextField.snp.centerY)
            make.right.equalToSuperview().inset(25)
        }
        idValidationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.top.equalTo(idDataTextField.snp.bottom).offset(18)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idDataTextField.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        passwordDataTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(23)
            make.left.right.equalToSuperview().inset(28)
        }
        editPasswordChangeButton.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.right.equalToSuperview().inset(40)
            make.centerY.equalTo(passwordDataTextField.snp.centerY)
        }
        showPasswordChangeTextFieldButton.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(12.25)
            make.right.equalTo(editPasswordChangeButton.snp.left).offset(-18)
            make.centerY.equalTo(passwordDataTextField.snp.centerY)
        }
        passwordChangeValidationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.top.equalTo(passwordDataTextField.snp.bottom).offset(18)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordDataTextField.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        passwordCheckDataTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(23)
            make.left.right.equalToSuperview().inset(28)
        }
        editPasswordCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.right.equalToSuperview().inset(40)
            make.centerY.equalTo(passwordCheckDataTextField.snp.centerY)
        }
        showPasswordCheckTextFieldButton.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(12.25)
            make.right.equalTo(editPasswordCheckButton.snp.left).offset(-18)
            make.centerY.equalTo(passwordCheckDataTextField.snp.centerY)
        }
        passwordCheckValidationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.top.equalTo(passwordCheckDataTextField.snp.bottom).offset(18)
        }
    }
    
    private func setUserInfo() {
        /* textfield로 변경 */
        UserInfoAPI.getUserInfo { isSuccess, result in
            self.dormitoryDataLabel.text = result.dormitoryName
            self.nicknameDataTextField.text = result.nickname
            self.idDataTextField.text = result.loginId
            
            /* passwordDataTextField, passwordDataCheckTextField 초기값 필요 */
            
        }
    }
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
}

extension EditMyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        
        switch textField {
        case nicknameDataTextField:
            nicknameValidationLabel.isHidden = false
            nicknameCheckButton.setActivatedButton()
            nicknameDataTextField.subviews.first?.backgroundColor = .mainColor
        case idDataTextField:
            idValidationLabel.isHidden = false
            idCheckButton.setActivatedButton()
            idDataTextField.subviews.first?.backgroundColor = .mainColor
        case passwordDataTextField:
            passwordChangeValidationLabel.isHidden = false
        case passwordCheckDataTextField:
            passwordCheckValidationLabel.isHidden = false
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = .init(hex: 0xA8A8A8)
        
        switch textField {
        case nicknameDataTextField:
            nicknameValidationLabel.isHidden = true
            nicknameDataTextField.subviews.first?.backgroundColor = .init(hex: 0xEFEFEF)
            nicknameCheckButton.setDeactivatedButton()
            nicknameCheckButton.setTitleColor(.init(hex: 0xD8D8D8), for: .normal)
            nicknameCheckButton.backgroundColor = .white
        case idDataTextField:
            idValidationLabel.isHidden = true
            idDataTextField.subviews.first?.backgroundColor = .init(hex: 0xEFEFEF)
            idCheckButton.setDeactivatedButton()
            idCheckButton.setTitleColor(.init(hex: 0xD8D8D8), for: .normal)
            idCheckButton.backgroundColor = .white
        case passwordDataTextField:
            passwordChangeValidationLabel.isHidden = true
        case passwordCheckDataTextField:
            passwordCheckValidationLabel.isHidden = true
        default:
            return
        }
    }
}

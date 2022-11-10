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
        }
        
        /* 비밀번호 표시 버튼 공통 설정 */
        [showPasswordCheckTextFieldButton, showPasswordChangeTextFieldButton].forEach {
            $0.setImage(UIImage(named: "ShowTextIcon"), for: .normal)
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
        /* 비밀번호 placeholder 보안은 비밀번호 길이만큼 dots를 추가해야 할 듯 */
        passwordDataTextField.placeholder = "password123!"
        passwordCheckDataTextField.placeholder = "password123!"
        
        /* 비밀번호 입력 텍스트 필드 입력 값 가리기 */
        [passwordDataTextField, passwordCheckDataTextField].forEach {
            $0.isSecureTextEntry = true
        }

        /* 각 항목 데이터 텍스트 필드 공통 설정 */
        [nicknameDataTextField, idDataTextField, passwordDataTextField, passwordCheckDataTextField].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.makeBottomLine()
        }
        
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            userImageView,
            dormitoryLabel, dormitoryDataLabel,
            nicknameLabel, nicknameDataTextField, nicknameCheckButton, editNicknameButton,
            idLabel, idDataTextField, idCheckButton, editIdButton,
            passwordLabel, passwordDataTextField, showPasswordChangeTextFieldButton, editPasswordChangeButton,
            passwordCheckLabel, passwordCheckDataTextField, showPasswordCheckTextFieldButton, editPasswordCheckButton
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
    }
    
    private func setUserInfo() {
        /* textfield로 변경 */
        UserInfoAPI.getUserInfo { isSuccess, result in
            self.dormitoryDataLabel.text = result.dormitoryName
            self.nicknameDataTextField.placeholder = result.nickname
            self.idDataTextField.placeholder = result.loginId
            
            /* passwordDataTextField, passwordDataCheckTextField 초기값 필요 */
            
        }
    }
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

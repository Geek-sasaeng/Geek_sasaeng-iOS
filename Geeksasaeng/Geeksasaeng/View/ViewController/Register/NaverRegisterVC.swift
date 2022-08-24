//
//  NaverRegisterVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/07.
//

import UIKit
import SnapKit

// MARK: - 수정된 회원가입 Res에 맞게 수정 필요
class NaverRegisterViewController: UIViewController {
    
    // MARK: - SubViews
    
    lazy var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    lazy var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    lazy var progressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoTop"))
        return imageView
    }()
    
    lazy var remainIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoBottom"))
        return imageView
    }()
    
    let selectYourUnivLabel: UILabel = {
        let label = UILabel()
        label.text = "자신의 학교를 선택해주세요"
        label.font = .customFont(.neoLight, size: 15)
        label.textColor = .init(hex: 0xD8D8D8)
        return label
    }()
    let toggleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = .init(hex: 0xD8D8D8)
        return imageView
    }()
    
    /* 자신의 학교를 선택해주세요 버튼 */
    lazy var universitySelectView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: 0xEFEFEF).cgColor
        
        view.addSubview(selectYourUnivLabel)
        view.addSubview(toggleImageView)
        selectYourUnivLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        toggleImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(8)
        }
        
        return view
    }()
    
    // Label Tap Gesture 적용을 위해 따로 꺼내놓음
    lazy var univNameLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대학교"
        label.font = .customFont(.neoLight, size: 15)
        label.textColor = .init(hex: 0x636363)
        return label
    }()
    /* 자신의 학교를 선택해주세요 눌렀을 때 확장되는 뷰
        -> 학교 리스트를 보여줌 */
    lazy var universityListView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: 0xEFEFEF).cgColor
        
        var selectYourUnivLabel: UILabel = {
            let label = UILabel()
            label.text = "자신의 학교를 선택해주세요"
            label.font = .customFont(.neoLight, size: 15)
            label.textColor = .init(hex: 0xD8D8D8)
            return label
        }()
        var toggleImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
            imageView.tintColor = .init(hex: 0xD8D8D8)
            return imageView
        }()
        var markUnivLabel: UILabel = {
            let label = UILabel()
            label.text = "ㄱ"
            label.font = .customFont(.neoLight, size: 12)
            label.textColor = .init(hex: 0xA8A8A8)
            return label
        }()
        
        [
            selectYourUnivLabel,
            toggleImageView,
            markUnivLabel,
            univNameLabel
        ].forEach {
            view.addSubview($0)
        }
        selectYourUnivLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(12)
        }
        toggleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.right.equalToSuperview().inset(18)
            make.width.equalTo(15)
            make.height.equalTo(8)
        }
        markUnivLabel.snp.makeConstraints { make in
            make.top.equalTo(selectYourUnivLabel.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(12)
        }
        univNameLabel.snp.makeConstraints { make in
            make.top.equalTo(markUnivLabel.snp.bottom).offset(11)
            make.left.equalToSuperview().inset(12)
        }
        view.isHidden = true
        return view
    }()
    
    var nickNameLabel = UILabel()
    var schoolLabel = UILabel()
    var emailLabel = UILabel()
    
    var nickNameTextField = UITextField()
    var emailTextField = UITextField()
    var emailAddressTextField = UITextField()
    
    lazy var nickNameCheckButton: UIButton = {
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
    
    lazy var authSendButton: UIButton = {
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
    
    lazy var nextButton: UIButton = {
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
    
    // MARK: - Properties
    
    var isNicknameChecked = false
    var isEmailSended = false
    var isExpanded: Bool! = false
    let tempEmailAddress = "@gachon.ac.kr"
    
    /* 회원가입 정보 */
    // 밑에 건 이 화면에서 바로 생성하여 전달 -> 변수로 둘 필요 x
    var nickNameData: String? = nil // nickNameTextField에서
    var university: String? = nil // selectYourUnivLabel에서
    var email: String? = nil // emailTextField에서
    var accessToken: String? // 네이버 엑세스 토큰 -> Register API 호출에 필요
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setTextFieldTarget()
        setViewTap()
        setLabelTap()
        
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
        // 학교 선택 리스트뷰가 확장되었을 때, universityListView 밖의 화면을 클릭 시 뷰가 사라지도록 설정함
        if let touch = touches.first, touch.view != universityListView, touch.view != universitySelectView {
            isExpanded = false
            universityListView.isHidden = true
            toggleImageView.image = UIImage(named: "ToggleMark")
        }
    }
    
    private func addSubViews() {
        [
            progressBar, remainBar, progressIcon, remainIcon,
            nickNameLabel, nickNameAvailableLabel, schoolLabel, emailLabel,
            nickNameTextField, emailTextField, emailAddressTextField,
            universitySelectView,
            nickNameCheckButton, authSendButton,
            nextButton,
            universityListView  // 맨마지막에 addSubview를 해야 등장 시 맨 앞으로 옴
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* progress Bar */
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
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(27)
        }
        
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(108)
            make.left.equalToSuperview().inset(27)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(82)
            make.left.equalToSuperview().inset(27)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.right.equalToSuperview().inset(25)
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
        }
        
        /* select univ */
        universitySelectView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(41)
        }
        universityListView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(316)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
        
        /* nickNameCheckButton */
        nickNameCheckButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(82)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(81)
            make.height.equalTo(41)
        }
        
        /* text fields */
        nickNameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.right.equalTo(nickNameCheckButton.snp.left).offset(-16)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(15)
        }
        
        /* nickNameAvailableLabel */
        nickNameAvailableLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.right.equalTo(nickNameCheckButton.snp.left).offset(-16)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(21)
        }
        
        /* authSendButton */
        authSendButton.snp.makeConstraints { make in
//            make.bottom.equalTo(emailAddressTextField.snp.bottom).offset(10)
            make.top.equalTo(emailTextField.snp.bottom).offset(28)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        emailAddressTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authSendButton.snp.left).offset(-15)
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        nickNameLabel = setMainLabelAttrs("닉네임")
        schoolLabel = setMainLabelAttrs("학교 선택")
        emailLabel = setMainLabelAttrs("학교 이메일 입력")
        
        /* textFields attr */
        nickNameTextField = setTextFieldAttrs(msg: "3-8자 영문으로 입력", width: 210)
        nickNameTextField.autocapitalizationType = .none
        
        emailTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailTextField.autocapitalizationType = .none
        
        emailAddressTextField = setTextFieldAttrs(msg: "@", width: 187)
        emailAddressTextField.isUserInteractionEnabled = false
    }
    
    private func setMainLabelAttrs(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }
    
    /* 텍스트 필드 속성 설정 */
    private func setTextFieldAttrs(msg: String, width: CGFloat) -> UITextField {
        // placeHolder 설정
        let textField = UITextField()
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoLight, size: 15)]
        )
        // 밑에 줄 설정
        textField.makeBottomLine()
        return textField
    }
    
    private func setTextFieldTarget() {
        [nickNameTextField, emailTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    /* universitySelectView에 탭 제스쳐를 추가 */
    private func setViewTap() {
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapUnivSelectView))
        universitySelectView.addGestureRecognizer(viewTapGesture)
    }
    
    private func setLabelTap() {
        let labelTapGesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(tapUnivName(_:)))
        univNameLabel.isUserInteractionEnabled = true
        univNameLabel.addGestureRecognizer(labelTapGesture)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapNickNameCheckButton() {
        if nickNameTextField.text?.isValidNickname() ?? false == false {
            nickNameAvailableLabel.text = "3-8자 영문 혹은 한글로 입력"
            nickNameAvailableLabel.textColor = .red
            nickNameAvailableLabel.isHidden = false
        } else {
            if let nickname = nickNameTextField.text {
                let input = NickNameRepetitionInput(nickName: nickname)
                RepetitionAPI.checkNicknameRepetitionFromNaverRegister(self, parameters: input)
            }
        }
    }
    
    @objc
    private func didChangeTextField(_ sender: UITextField) {
        // 초기화
        if sender == nickNameTextField {
            isNicknameChecked = false
        } else if sender == emailTextField {
            isEmailSended = false
        }
        
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

        if isNicknameChecked
            && isEmailSended
            && selectYourUnivLabel.text != "자신의 학교를 선택해주세요"
            && emailTextField.text?.count ?? 0 >= 1
        {
            nextButton.setActivatedNextButton()
        } else {
            nextButton.setDeactivatedNextButton()
        }
    }
    
    @objc
    private func tapUnivSelectView() {
        // TODO: API 연결 필요
//        UniversityListViewModel.requestGetUnivList(self)
        isExpanded = !isExpanded
        // 확장하는 거면 리스트 보여주기
        if isExpanded {
            universityListView.isHidden = false
            toggleImageView.image = UIImage(systemName: "chevron.down")
        } else {    // 접는 거면 리스트 닫기
            universityListView.isHidden = true
            toggleImageView.image = UIImage(named: "ToggleMark")
        }
        self.view.bringSubviewToFront(universitySelectView)
    }
    
    @objc
    private func tapUnivName(_ sender: UITapGestureRecognizer) {
        let univName = sender.view as! UILabel
        selectYourUnivLabel.text = univName.text
        selectYourUnivLabel.textColor = .init(hex: 0x636363)
        
        // textfield를 가천대의 이메일 address로 채워준다
        emailAddressTextField.text = tempEmailAddress
        didChangeTextField(emailAddressTextField)   // 이메일에서 id를 먼저 적고 학교 선택하면 호출 안 되길래 직접 호출
    }
    
    @objc
    private func tapAuthSendButton() {
        if let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let univ = univNameLabel.text {    // 값이 들어 있어야 괄호 안의 코드 실행 가능
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)
            let uuid = UUID()
            let input = EmailAuthInput(email: email+emailAddress, university: univ, uuid: uuid.uuidString)
            print("DEBUG: ", uuid.uuidString)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(input) { isSuccess, message in// // 경우에 맞는 토스트 메세지 출력
                self.showToast(viewController: self, message: message, font: .customFont(.neoMedium, size: 15), color: .mainColor)
                
                // 닉네임 확인, 이메일 인증번호 전송까지 성공했을 때에 다음 버튼을 활성화
                if isSuccess, self.isNicknameChecked {
                    self.nextButton.setActivatedNextButton()
                    self.isEmailSended = isSuccess
                }
            }
        }
    }
    
    // AuthNumVC로 화면 전환 -> 이메일 인증번호 확인하는 화면으로 전환한 것
    @objc
    private func showNextView() {
        let authNumVC = AuthNumViewController()
        
        authNumVC.modalTransitionStyle = .crossDissolve
        authNumVC.modalPresentationStyle = .fullScreen
        
        // 데이터 전달
        if let accessToken = accessToken,
           let nickNameData = nickNameTextField.text,
           let university = selectYourUnivLabel.text,
           let emailId = emailTextField.text,
           let emailAddress = emailAddressTextField.text {
            /* 값이 존재할 때에만 데이터 전달을 해야 한다 */
            authNumVC.isFromNaverRegister = true
            authNumVC.accessToken = accessToken
            authNumVC.nickNameData = nickNameData
            authNumVC.university = university
            authNumVC.email = emailId + emailAddress
            
            // 화면 전환
            present(authNumVC, animated: true)
        }
    }
}

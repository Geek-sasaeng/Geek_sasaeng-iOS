//
//  NaverRegisterVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/07.
//

import UIKit
import SnapKit
import Then

// MARK: - 수정된 회원가입 Res에 맞게 수정 필요
class NaverRegisterViewController: UIViewController {
    
    // MARK: - SubViews
    
    lazy var progressBar = UIView().then {
        $0.backgroundColor = .mainColor
    }
    lazy var remainBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xF2F2F2)
    }
    lazy var progressIcon = UIImageView().then {
        $0.image = UIImage(named: "LogoTop")
    }
    lazy var remainIcon = UIImageView().then {
        $0.image = UIImage(named: "LogoBottom")
    }
    
    let selectYourUnivLabel = UILabel().then {
        $0.text = "자신의 학교를 선택해주세요"
        $0.font = .customFont(.neoLight, size: 15)
        $0.textColor = .init(hex: 0xD8D8D8)
    }
    let toggleImageView = UIImageView().then {
        $0.image = UIImage(named: "ToggleMark")
        $0.tintColor = .init(hex: 0xD8D8D8)
    }
    
    /* 자신의 학교를 선택해주세요 버튼 */
    lazy var universitySelectView = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.init(hex: 0xEFEFEF).cgColor
        
        $0.addSubview(selectYourUnivLabel)
        $0.addSubview(toggleImageView)
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
    }
    
    // Label Tap Gesture 적용을 위해 따로 꺼내놓음
    lazy var univNameLabel = UILabel().then {
        $0.text = "가천대학교"
        $0.font = .customFont(.neoLight, size: 15)
        $0.textColor = .init(hex: 0x636363)
    }
    /* 자신의 학교를 선택해주세요 눌렀을 때 확장되는 뷰
        -> 학교 리스트를 보여줌 */
    lazy var universityListView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: 0xEFEFEF).cgColor
        
        var selectYourUnivLabel = UILabel().then {
            $0.text = "자신의 학교를 선택해주세요"
            $0.font = .customFont(.neoLight, size: 15)
            $0.textColor = .init(hex: 0xD8D8D8)
        }
        var toggleImageView = UIImageView().then {
            $0.image = UIImage(named: "ToggleMark")
            $0.tintColor = .init(hex: 0xD8D8D8)
        }
        var markUnivLabel = UILabel().then {
            $0.text = "ㄱ"
            $0.font = .customFont(.neoLight, size: 12)
            $0.textColor = .init(hex: 0xA8A8A8)
        }
        
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
    }
    
    var nickNameLabel = UILabel()
    var schoolLabel = UILabel()
    var emailLabel = UILabel()
    
    var nickNameTextField = UITextField()
    var emailTextField = UITextField()
    var emailAddressTextField = UITextField()
    
    lazy var nickNameCheckButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.addTarget(self, action: #selector(tapNickNameCheckButton), for: .touchUpInside)
    }
    lazy var authSendButton = UIButton().then {
        $0.setTitle("인증번호 전송", for: .normal)
        $0.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
    }
    
    var nickNameAvailableLabel = UILabel().then {
        $0.text = "사용 가능한 닉네임입니다"
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    let authNumLabel = UILabel().then {
        $0.text = "인증번호 입력"
        $0.font = .customFont(.neoMedium, size: 18)
        $0.textColor = .black
    }
    
    lazy var authNumTextField = UITextField().then {
        $0.textColor = .black
        $0.attributedPlaceholder = NSAttributedString(
            string: "입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        $0.makeBottomLine()
    }
    
    lazy var authResendButton = UIButton().then {
        $0.setTitle("재전송 하기", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(tapAuthResendButton), for: .touchUpInside)
        $0.isHidden = true
    }
    
    lazy var authCheckButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(tapAuthCheckButton), for: .touchUpInside)
    }
    
    let remainTimeLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        $0.isEnabled = false
    }
    
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
    var emailId: Int?
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: DispatchSourceTimer?
    
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
            nickNameCheckButton, authSendButton, authResendButton,
            authNumLabel, authNumTextField, authCheckButton, remainTimeLabel,
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
            make.top.equalTo(emailTextField.snp.bottom).offset(28)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        authResendButton.snp.makeConstraints { make in
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
        
        /* 인증번호 전송 */
        authNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(emailLabel.snp.bottom).offset(138)
        }
        authNumTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authResendButton.snp.left).offset(-15)
            make.top.equalTo(authNumLabel.snp.bottom).offset(20)
        }
        authCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
            make.bottom.equalTo(authNumTextField.snp.bottom).offset(9)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(authNumTextField.snp.bottom).offset(21)
        }
    }
    
    private func setAttributes() {
        /* label attr */
        setMainLabelAttrs(nickNameLabel, text: "닉네임")
        setMainLabelAttrs(schoolLabel, text: "학교 선택")
        setMainLabelAttrs(emailLabel, text: "학교 이메일 입력")
        
        /* textFields attr */
        setTextFieldAttrs(nickNameTextField, msg: "3-8자 영문으로 입력", width: 210)
        nickNameTextField.autocapitalizationType = .none
        
        setTextFieldAttrs(emailTextField, msg: "입력하세요", width: 307)
        emailTextField.autocapitalizationType = .none
        
        setTextFieldAttrs(emailAddressTextField, msg: "@", width: 187)
        emailAddressTextField.isUserInteractionEnabled = false
        
        [progressBar, remainBar].forEach {
            $0.clipsToBounds = true
            view.layer.cornerRadius = 1.5
        }
        
        authResendButton.setActivatedButton()
        authCheckButton.setDeactivatedButton()
        [nickNameCheckButton, authSendButton].forEach {
            $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
            $0.clipsToBounds = true
            $0.isEnabled = false
        }
    }
    
    private func setMainLabelAttrs(_ label: UILabel, text: String){
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
    }
    
    /* 텍스트 필드 속성 설정 */
    private func setTextFieldAttrs(_ textField: UITextField, msg: String, width: CGFloat){
        // placeHolder 설정
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoLight, size: 15)]
        )
        // 밑에 줄 설정
        textField.makeBottomLine()
    }
    
    private func setTextFieldTarget() {
        [nickNameTextField, emailTextField, emailAddressTextField, authNumTextField].forEach { textField in
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
    
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self.currentSeconds -= 1
            let minutes = self.currentSeconds / 60
            let seconds = self.currentSeconds % 60
            self.remainTimeLabel.text = String(format: "%02d분 %02d초 남았어요", minutes, seconds)
            
            if self.currentSeconds <= 0 {
                self.timer?.cancel()
                self.remainTimeLabel.textColor = .red
                self.remainTimeLabel.text = "인증번호 입력 시간이 만료되었습니다."
            }
        })
        timer?.resume()
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
                RepetitionAPI.checkNicknameRepetitionFromNaverRegister(parameters: input) { success, message in
                    if success {
                        self.isNicknameChecked = true
                        if self.selectYourUnivLabel.text != "자신의 학교를 선택해주세요"
                            && self.emailTextField.text?.count ?? 0 >= 1 {
                            self.nextButton.setActivatedNextButton()
                        }
                        self.nickNameAvailableLabel.text = message
                        self.nickNameAvailableLabel.textColor = .mainColor
                        self.nickNameAvailableLabel.isHidden = false
                    } else {
                        self.nickNameAvailableLabel.text = message
                        self.nickNameAvailableLabel.textColor = .red
                        self.nickNameAvailableLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    @objc
    private func didChangeTextField(_ sender: UITextField) {
        if sender == authNumTextField {
            if authNumTextField.text?.count ?? 0 >= 1 {
                authCheckButton.setActivatedButton()
            } else {
                authCheckButton.setDeactivatedButton()
            }
        }
        
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
            EmailAuthViewModel.requestSendEmail(input) { model in
                if let model = model {
                    // 경우에 맞는 토스트 메세지 출력
                    switch model.code {
                    case 1001:
                        self.showToast(viewController: self, message: "인증번호가 전송되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                        if self.isNicknameChecked {
                            self.authSendButton.isHidden = true
                            self.authResendButton.isHidden = false
                            self.startTimer()
                            self.remainTimeLabel.isHidden = false
                        }
                    case 2015:
                        self.showToast(viewController: self, message: "일일 최대 전송 횟수를 초과했습니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 248, height: 40)
                    default:
                        self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                    }
                } else {
                    self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                }
            }
        }
    }
    
    @objc
    private func tapAuthResendButton() {
        if let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let univ = univNameLabel.text {    // 값이 들어 있어야 괄호 안의 코드 실행 가능
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)

            let uuid = UUID()
            let input = EmailAuthInput(email: email+emailAddress, university: univ, uuid: uuid.uuidString)
            print("DEBUG: ", uuid.uuidString)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(input) { model in
                if let model = model {
                    // 경우에 맞는 토스트 메세지 출력
                    switch model.code {
                    case 1001:
                        self.showToast(viewController: self, message: "인증번호가 전송되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                        // 타이머 시작
                        self.timer?.cancel()
                        self.currentSeconds = 300
                        self.startTimer()
                    case 2015:
                        self.showToast(viewController: self, message: "일일 최대 전송 횟수를 초과했습니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 248, height: 40)
                    default:
                        self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                    }
                } else {
                    self.showToast(viewController: self, message: "잠시 후에 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 212, height: 40)
                }
            }
        }
    }
    
    @objc
    private func tapAuthCheckButton() {
        if let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let authNum = authNumTextField.text {
            let email = email + emailAddress
            print("DEBUG: ", email, authNum)
            EmailAuthCheckViewModel.requestCheckEmailAuth(EmailAuthCheckInput(email: email, key: authNum)) { isSuccess, emailId in
                if isSuccess {
                    self.emailId = emailId
                    self.nextButton.setActivatedButton()
                } else {
                    self.showToast(viewController: self, message: "인증번호가 틀렸습니다", font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8), width: 179, height: 40)
                }
            }
        }
    }
    
    // AuthNumVC로 화면 전환 -> 이메일 인증번호 확인하는 화면으로 전환한 것
    @objc
    private func tapNextButton() {
        if let accessToken = accessToken,
           let nickNameData = nickNameTextField.text,
           let university = selectYourUnivLabel.text,
           let emailId = emailTextField.text,
           let emailAddress = emailAddressTextField.text {
            // 생성자를 통해 데이터 전달
            let agreementVC = AgreementViewController(isFromNaverRegister: true, accessToken: accessToken, nickNameData: nickNameData, university: university, email: emailId+emailAddress)
            
            agreementVC.modalTransitionStyle = .crossDissolve
            agreementVC.modalPresentationStyle = .fullScreen
            
            present(agreementVC, animated: true)
        }
    }
}

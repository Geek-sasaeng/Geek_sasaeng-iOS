//
//  EmailAuthVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

import SnapKit
import Then

class EmailAuthViewController: UIViewController {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var idData: String?
    var pwData: String?
    var pwCheckData: String?
    var nickNameData: String?
    var uuid: UUID! = UUID()
    var emailId: Int?
    
    // 학교 선택 리스트가 열려있는지, 닫혀있는지 확인하기 위한 변수
    var isExpanded: Bool! = false
    let tempEmailAddress = "@gachon.ac.kr"
    
    // Timer
    var currentSeconds = 300 // 남은 시간
    var timer: DispatchSourceTimer?
    
    // MARK: - Subviews
    
    let progressBar = UIView().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 1.5
    }
    
    let remainBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xF2F2F2)
        $0.layer.cornerRadius = 1.5
    }
    
    let progressIcon = UIImageView(image: UIImage(named: "LogoTop"))
    
    let remainIcon = UIImageView(image: UIImage(named: "LogoBottom"))
    
    let selectYourUnivLabel = UILabel().then {
        $0.text = "자신의 학교를 선택해주세요"
        $0.font = .customFont(.neoLight, size: 15)
        $0.textColor = .init(hex: 0xD8D8D8)
    }
    let toggleImageView = UIImageView(image: UIImage(named: "ToggleMark")).then {
        $0.tintColor = .init(hex: 0xD8D8D8)
    }
    
    /* 자신의 학교를 선택해주세요 버튼 */
    lazy var universitySelectView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.init(hex: 0xEFEFEF).cgColor
        
        $0.addSubview(selectYourUnivLabel)
        $0.addSubview(toggleImageView)
        selectYourUnivLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 32.75)
            make.centerY.equalToSuperview()
        }
        toggleImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(screenWidth / 21.83)
            make.centerY.equalToSuperview()
            make.width.equalTo(screenWidth / 26.2)
            make.height.equalTo(screenHeight / 106.5)
        }
    }
    
    // Label Tap Gesture 적용을 위해 따로 꺼내놓음
    let univNameLabel = UILabel().then {
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
        
        let selectYourUnivLabel = UILabel().then {
            $0.text = "자신의 학교를 선택해주세요"
            $0.font = .customFont(.neoLight, size: 15)
            $0.textColor = .init(hex: 0xD8D8D8)
        }
        let toggleImageView = UIImageView(image: UIImage(named: "ToggleMark")).then {
            $0.tintColor = .init(hex: 0xD8D8D8)
        }
        let markUnivLabel = UILabel().then {
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
            make.top.equalToSuperview().inset(screenHeight / 85.2)
            make.left.equalToSuperview().inset(screenWidth / 32.75)
        }
        toggleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(screenHeight / 50.11)
            make.right.equalToSuperview().inset(screenWidth / 21.83)
            make.width.equalTo(screenWidth / 26.2)
            make.height.equalTo(screenHeight / 106.5)
        }
        markUnivLabel.snp.makeConstraints { make in
            make.top.equalTo(selectYourUnivLabel.snp.bottom).offset(screenHeight / 24.34)
            make.left.equalToSuperview().inset(screenWidth / 32.75)
        }
        univNameLabel.snp.makeConstraints { make in
            make.top.equalTo(markUnivLabel.snp.bottom).offset(screenHeight / 77.45)
            make.left.equalToSuperview().inset(screenWidth / 32.75)
        }
        view.isHidden = true
    }
    
    let schoolLabel = UILabel()
    let emailLabel = UILabel()
    let emailTextField = UITextField()
    let emailAddressTextField = UITextField()
    
    lazy var authSendButton = UIButton().then {
        $0.setTitle("인증번호 전송", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
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
        $0.keyboardType = .numberPad
        $0.makeBottomLine()
    }
    
    lazy var authResendButton = UIButton().then {
        $0.setTitle("재전송 하기", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
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
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes() // 호출 순서 바꾸면 에러남
        addSubViews()
        setLayouts()
        setTextFieldTarget()
        setTapGestures()
        addRightSwipe()
    }
    
    // MARK: - Initialization
    
    init(idData: String, pwData: String, pwCheckData: String, nickNameData: String) {
        super.init(nibName: nil, bundle: nil)
        self.idData = idData
        self.pwData = pwData
        self.pwCheckData = pwCheckData
        self.nickNameData = nickNameData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            progressBar, remainBar,
            progressIcon, remainIcon,
            schoolLabel, emailLabel,
            universitySelectView,
            emailTextField, emailAddressTextField,
            authSendButton, authResendButton,
            authNumLabel, authNumTextField, authCheckButton, remainTimeLabel,
            nextButton,
            universityListView  // 맨마지막에 addSubview를 해야 등장 시 맨 앞으로 옴
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(screenWidth / 142)
            make.width.equalTo((screenWidth - 50) / 5 * 2)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(screenHeight / 85.2)
            make.left.equalToSuperview().inset(screenWidth / 15.72)
        }
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 11.22)
            make.height.equalTo(screenHeight / 38.72)
            make.top.equalTo(progressBar.snp.top).offset(-(screenHeight / 85.2))
            make.left.equalTo(progressBar.snp.right).inset(screenWidth / 26.2)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(screenWidth / 142)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(screenHeight / 85.2)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(screenHeight / 15.72)
        }
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 17.86)
            make.height.equalTo(screenHeight / 23.66)
            make.top.equalTo(progressBar.snp.top).offset(-(screenHeight / 106.5))
            make.right.equalTo(remainBar.snp.right).offset(screenWidth / 131)
        }
        
        /* labels */
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(screenHeight / 17.04)
            make.left.equalToSuperview().inset(screenWidth / 14.55)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(screenHeight / 10.51)
            make.left.equalToSuperview().inset(screenWidth / 14.55)
        }
        
        /* universitySelectView */
        universitySelectView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(screenHeight / 85.2)
            make.left.right.equalToSuperview().inset(screenWidth / 14.03)
            make.height.equalTo(screenHeight / 20.78)
        }
        /* universityListView -> DropDown으로 확장되는 뷰 */
        universityListView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(screenHeight / 85.2)
            make.left.right.equalToSuperview().inset(screenWidth / 14.03)
            make.height.equalTo(screenHeight / 2.69)
        }
        
        /* text fields */
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(screenHeight / 56.8)
            make.left.right.equalToSuperview().inset(screenWidth / 14.03)
        }
        emailAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(screenHeight / 24.34)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.right.equalTo(authSendButton.snp.left).offset(-(screenWidth / 26.2))
        }
        
        /* authSendButton, authResendButton */
        authSendButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailAddressTextField.snp.bottom).offset(screenHeight / 85.2)
            make.right.equalToSuperview().inset(screenWidth / 15.11)
            make.width.equalTo(screenWidth / 3.74)
            make.height.equalTo(screenHeight / 20.78)
        }
        authResendButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailAddressTextField.snp.bottom).offset(screenHeight / 85.2)
            make.right.equalToSuperview().inset(screenWidth / 15.11)
            make.width.equalTo(screenWidth / 3.74)
            make.height.equalTo(screenHeight / 20.78)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(screenWidth / 14.03)
            make.bottom.equalToSuperview().inset(screenHeight / 16.7)
            make.height.equalTo(screenHeight / 16.7)
        }
        
        /* 인증번호 입력 */
        authNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(emailLabel.snp.bottom).offset(screenHeight / 6.17)
        }
        authNumTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.right.equalTo(authResendButton.snp.left).offset(-(screenWidth / 26.2))
            make.top.equalTo(authNumLabel.snp.bottom).offset(screenHeight / 42.6)
        }
        authCheckButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(screenWidth / 15.11)
            make.width.equalTo(screenWidth / 3.74)
            make.height.equalTo(screenHeight / 20.78)
            make.bottom.equalTo(authNumTextField.snp.bottom).offset(screenHeight / 94.66)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 9.82)
            make.top.equalTo(authNumTextField.snp.bottom).offset(screenHeight / 40.57)
        }
    }
    
    private func setAttributes() {
        /* labels attr */
        setMainLabelAttrs(schoolLabel, "학교 선택")
        setMainLabelAttrs(emailLabel, "학교 이메일 입력")
        
        /* textFields attr */
        setTextFieldAttrs(emailTextField, "입력하세요")
        emailTextField.autocapitalizationType = .none
        
        setTextFieldAttrs(emailAddressTextField, "@")
        emailAddressTextField.isUserInteractionEnabled = false  // 유저가 입력하는 것이 아니라 학교에 따라 자동 설정되는 것.
        
        /* buttons attr */
        authResendButton.setActivatedButton()
        authCheckButton.setDeactivatedButton()
        [authSendButton, nextButton].forEach {
            $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
            $0.isEnabled = false
        }
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ label: UILabel, _ text: String) {
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
    }
    
    /* 텍스트 필드 속성 설정 */
    private func setTextFieldAttrs(_ textField: UITextField, _ msg: String) {
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
        [ emailTextField, emailAddressTextField, authNumTextField ].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    private func setTapGestures() {
        /* universitySelectView에 탭 제스쳐를 추가 */
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapUnivSelectView))
        universitySelectView.addGestureRecognizer(viewTapGesture)
        
        /* 학교 이름 label에 탭 제스쳐 추가 */
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
    private func didChangeTextField(_ sender: UITextField) {
        if sender == authNumTextField {
            if authNumTextField.text?.count ?? 0 >= 1 {
                authCheckButton.setActivatedButton()
            } else {
                authCheckButton.setDeactivatedButton()
            }
        } else {
            if emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
                authSendButton.setActivatedButton()
            } else {
                authSendButton.setDeactivatedButton()
            }
        }
    }
    
    /* 학교 선택 탭하면 리스트 확장 */
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
    
    /* 학교 리스트에서 학교 이름 선택하면 실행 */
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
            MyLoadingView.shared.show()
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)

            let input = EmailAuthInput(email: email+emailAddress, university: univ, uuid: uuid.uuidString)
            print("DEBUG: ", uuid.uuidString)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(input) { model in
                MyLoadingView.shared.hide()
                
                if let model = model {
                    // 경우에 맞는 토스트 메세지 출력
                    switch model.code {
                    case 1802:
                        self.showToast(viewController: self, message: "인증번호가 전송되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                        // 이미 돌아가고 있는 타이머가 있으면 -> 재전송 버튼 누른 경우
                        if let timer = self.timer {
                            // 돌고 있는 타이머 종료하고 시간 재설정
                            timer.cancel()
                            self.currentSeconds = 300
                        }
                        // 타이머 시작
                        self.startTimer()
                        
                        self.authSendButton.isHidden = true
                        self.authResendButton.isHidden = false
                        self.remainTimeLabel.isHidden = false
                    case 2803:
                        self.showToast(viewController: self, message: "유효하지 않은 인증번호입니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 248, height: 40)
                    case 2804:
                        self.showToast(viewController: self, message: "이메일 인증은 하루 최대 10번입니다", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 248, height: 40)
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
            MyLoadingView.shared.show()
            
            let email = email + emailAddress
            print("DEBUG: ", email, authNum)
            EmailAuthCheckViewModel.requestCheckEmailAuth(EmailAuthCheckInput(email: email, key: authNum)) { isSuccess, emailId in
                MyLoadingView.shared.hide()
                
                if isSuccess {
                    // 인증 완료 텍스트 띄우기
                    self.remainTimeLabel.text = "성공적으로 인증이 완료되었습니다"
                    self.timer?.cancel()
                    self.timer = nil
                    
                    self.emailId = emailId
                    self.nextButton.setActivatedNextButton()
                } else {
                    self.showToast(viewController: self, message: "인증번호가 틀렸습니다", font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8), width: 179, height: 40)
                }
            }
        }
    }
    
    @objc
    private func tapNextButton() {
        if let idData = self.idData,
           let pwData = self.pwData,
           let pwCheckData = self.pwCheckData,
           let nickNameData = self.nickNameData,
           let university = self.selectYourUnivLabel.text,
           let emailId = self.emailId,
           let uuid = self.uuid {
            /* 인증번호 일치했을 때에만 휴대폰 번호 인증하는 화면 띄우기 */
            let phoneAuthVC = PhoneAuthViewController(idData: idData, pwData: pwData, pwCheckData: pwCheckData, nickNameData: nickNameData, university: university, emailId: emailId, uuid: uuid)
            
            phoneAuthVC.modalTransitionStyle = .crossDissolve
            phoneAuthVC.modalPresentationStyle = .fullScreen
            
            present(phoneAuthVC, animated: true)
        }
    }
}

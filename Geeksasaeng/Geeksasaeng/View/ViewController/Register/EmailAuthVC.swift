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
    
    let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    let remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    let progressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoTop"))
        return imageView
    }()
    
    let remainIcon: UIImageView = {
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
    let univNameLabel: UILabel = {
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
        let markUnivLabel: UILabel = {
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
    
    let schoolLabel = UILabel()
    let emailLabel = UILabel()
    let emailTextField = UITextField()
    let emailAddressTextField = UITextField()
    
    lazy var authSendButton: UIButton = {
        var button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.addTarget(self, action: #selector(tapAuthSendButton), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var idData: String?
    var pwData: String?
    var pwCheckData: String?
    var nickNameData: String?
    var uuid: UUID! = UUID()
    
    // 학교 선택 리스트가 열려있는지, 닫혀있는지 확인하기 위한 변수
    var isExpanded: Bool! = false
    let tempEmailAddress = "@gachon.ac.kr"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes() // 호출 순서 바꾸면 에러남
        addSubViews()
        setLayouts()
        setTextFieldTarget()
        setTapGesture()
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
            authSendButton,
            nextButton,
            universityListView  // 맨마지막에 addSubview를 해야 등장 시 맨 앞으로 옴
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 2)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(25)
        }
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.top.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).inset(15)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(36)
            make.top.equalTo(progressBar.snp.top).offset(-8)
            make.right.equalTo(remainBar.snp.right).offset(3)
        }
        
        /* labels */
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(27)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(81)
            make.left.equalToSuperview().inset(27)
        }
        
        /* universitySelectView */
        universitySelectView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(41)
        }
        /* universityListView -> DropDown으로 확장되는 뷰 */
        universityListView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(316)
        }
        
        /* text fields */
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(28)
        }
        emailAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(authSendButton.snp.left).offset(-15)
        }
        
        /* authSendButton */
        authSendButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(243)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
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
        [ emailTextField, emailAddressTextField ].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    private func setTapGesture() {
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

    @objc
    private func didChangeTextField(_ sender: UITextField) {
        if emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            authSendButton.setActivatedButton()
        } else {
            nextButton.setDeactivatedNextButton()
            authSendButton.setDeactivatedButton()
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
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)

            let input = EmailAuthInput(email: email+emailAddress, university: univ, uuid: uuid.uuidString)
            print("DEBUG: ", uuid.uuidString)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(input) { isSuccess, message in// // 경우에 맞는 토스트 메세지 출력
                self.showToast(viewController: self, message: message, font: .customFont(.neoMedium, size: 15), color: .mainColor)
                
                // 이메일 인증번호 전송까지 성공했을 때에 다음 버튼을 활성화
                if isSuccess {
                    self.nextButton.setActivatedNextButton()
                }
            }
        }
    }
    
    @objc
    private func tapNextButton() {
        //
        if let idData = self.idData,
           let pwData = self.pwData,
           let pwCheckData = self.pwCheckData,
           let nickNameData = self.nickNameData,
           let univ = selectYourUnivLabel.text,
           let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let uuid = uuid {
            // TODO: university name에 맞게 @뒤에 다른 값을 붙여줘야 함 - 일단은 가천대만
            let authNumVC = AuthNumViewController(idData: idData, pwData: pwData, pwCheckData: pwCheckData, nickNameData: nickNameData, university: univ, email: email + emailAddress, uuid: uuid)
            
            authNumVC.modalTransitionStyle = .crossDissolve
            authNumVC.modalPresentationStyle = .fullScreen
            
            present(authNumVC, animated: true)
        }
    }
    
}

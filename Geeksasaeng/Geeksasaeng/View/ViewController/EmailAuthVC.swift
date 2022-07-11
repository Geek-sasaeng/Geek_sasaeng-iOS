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
    var univNameLabel: UILabel = {
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
    
    var schoolLabel = UILabel()
    var emailLabel = UILabel()
    
    var emailTextField = UITextField()
    var emailAddressTextField = UITextField()
    
    var authSendButton: UIButton = {
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
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var idData: String!
    var pwData: String!
    var pwCheckData: String!
    var nickNameData: String!
    
    // 학교 선택 리스트가 열려있는지, 닫혀있는지 확인하기 위한 변수
    var isExpanded: Bool! = false
    var tempUnivName = "Gachon University"
    let tempEmailAddress = "@gachon.ac.kr"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setLayouts()
        setTextFieldTarget()
        setLabelTap()
        
        view.addSubview(universityListView)
        universityListView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(316)
        }
        // 학교 선택 리스트 탭
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapSelectUniv))
        universitySelectView.isUserInteractionEnabled = true
        universitySelectView.addGestureRecognizer(viewTapGesture)
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        /* progress Bar */
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 50) / 5 * 2)
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
            schoolLabel,
            emailLabel
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(27)
            }
        }
        /* schoolLabel */
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
        }
        /* emailLabel */
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(81)
        }
        
        view.addSubview(universitySelectView)
        universitySelectView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(41)
        }
        
        /* text fields */
        [
            emailTextField,
            emailAddressTextField
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(36)
            }
        }
        /* emailTextField */
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
        }
        /* emailAddressTextField */
        emailAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
        }
        
        /* authSendButton */
        view.addSubview(authSendButton)
        authSendButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(243)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    private func setAttributes() {
        /* labels attr */
        schoolLabel = setMainLabelAttrs("학교 선택")
        emailLabel = setMainLabelAttrs("학교 이메일 입력")
        
        /* textFields attr */
        emailTextField = setTextFieldAttrs(msg: "입력하세요", width: 307)
        emailAddressTextField = setTextFieldAttrs(msg: "@", width: 187)
        emailAddressTextField.isUserInteractionEnabled = false  // 유저가 입력하는 것이 아니라 학교에 따라 자동 설정되는 것.
        // TODO: emailAddress -> UILabel로 바뀌어야 할 듯
        emailAddressTextField.text = "@gachon.ac.kr"   //test
        
        /* authSendButton attr */
        //        authSendButton = setAuthSendButtonAttrs()
        //        makeButtonShadow(authSendButton)
    }
    
    // 공통 속성을 묶어놓은 함수
    private func setMainLabelAttrs(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }
    
    private func setTextFieldAttrs(msg: String, width: CGFloat) -> UITextField {
        let textField = UITextField()
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: msg,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoLight, size: 15)]
        )
        textField.makeBottomLine(width)
        return textField
    }
    
    private func setTextFieldTarget() {
        [ emailTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        }
    }
    
    /* 학교 이름 label에 탭 제스쳐 추가 */
    private func setLabelTap() {
        let labelTapGesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(tapUnivName(_:)))
        univNameLabel.isUserInteractionEnabled = true
        univNameLabel.addGestureRecognizer(labelTapGesture)
    }

    @objc func didChangeTextField(_ sender: UITextField) {
        if emailTextField.text?.count ?? 0 >= 1 && emailAddressTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
            authSendButton.setActivatedButton()
        } else {
            nextButton.setDeactivatedNextButton()
            authSendButton.setDeactivatedButton()
        }
    }
    
    /* 학교 선택 탭하면 리스트 확장 */
    @objc private func tapSelectUniv() {
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
    @objc private func tapUnivName(_ sender: UITapGestureRecognizer) {
        let univName = sender.view as! UILabel
        selectYourUnivLabel.text = univName.text
        selectYourUnivLabel.textColor = .init(hex: 0x636363)
    }
    
    @objc private func tapAuthSendButton() {
        if let email = emailTextField.text,
           let emailAddress = emailAddressTextField.text,
           let univ = univNameLabel.text {    // 값이 들어 있어야 괄호 안의 코드 실행 가능
            authSendButton.setDeactivatedButton()   // 비활성화
            
            print("DEBUG: ", email+emailAddress, univ)
            let uuid = UUID()
            let input = EmailAuthInput(email: email+emailAddress, university: univ, uuid: uuid.uuidString)
            print("DEBUG: ", uuid.uuidString)
            // 이메일로 인증번호 전송하는 API 호출
            EmailAuthViewModel.requestSendEmail(self, input)
        }
    }
    
    @objc func showNextView() {
        let authNumVC = AuthNumViewController()
        
        authNumVC.modalTransitionStyle = .crossDissolve
        authNumVC.modalPresentationStyle = .fullScreen
        
        // 학교 정보랑 학교 이메일 정보 넘겨줘야 한다 -> 재전송 하기 버튼 때문에
        authNumVC.university = selectYourUnivLabel.text
        authNumVC.email = emailTextField.text! + "@gachon.ac.kr"
        
        present(authNumVC, animated: true)
    }
    
    // TODO: 이거 마지막 화면으로 옮겨야 됨. 회원가입 완료하는 함수.
//    func sendRegisterRequest() {
//        // Request 생성.
//        guard let school = self.schoolTextField.text,
//              let email = self.emailTextField.text,
//              let emailAddress = self.emailAddressTextField.text
//        else { return }
//
//        let input = RegisterInput(checkPassword: pwCheckData,
//                                  email: email+emailAddress,
//                                  loginId: idData,
//                                  nickname: nickNameData,
//                                  password: pwData,
//                                  phoneNumber: "01012341234",
//                                  universityName: school)
//
//        RegisterAPI.registerUser(self, input)
//    }
}

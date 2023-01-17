//
//  EditMyInfoVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/11/08.
//

import UIKit
import SnapKit
import Then
import PhotosUI
import Kingfisher

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
    
    /* 유저 프로필 이미지 3개 components */
    lazy var userImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 83
    }
    let userImageBlurView = UIView().then {
        $0.backgroundColor = .init(hex: 0x5B5B5B, alpha: 0.66)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 83
    }
    let userImageViewIcon = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 72.5
        $0.image = UIImage(named: "EditProfileImage")
    }
    
    
    /* title labels */
    let dormitoryLabel = UILabel()
    let nicknameLabel = UILabel()
    
    /* Data TextField */
    lazy var nicknameDataTextField = UITextField().then {
        $0.textColor = .init(hex: 0xA8A8A8)
        $0.font = .customFont(.neoMedium, size: 15)
        $0.makeBottomLine()
        $0.delegate = self
    }
    
    /* TextField 아래 Notice Label*/
    let nicknameValidationLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .customFont(.neoMedium, size: 13)
        $0.isHidden = true
        $0.text = "3-8자 영문 혹은 한글로 입력해주세요"
    }
    
    /* 중복확인 버튼 (닉네임, 아이디) */
    lazy var nicknameCheckButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setDeactivatedCheckButton()
        $0.addTarget(self, action: #selector(tapCheckButton(sender: )), for: .touchUpInside)
    }
    
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
    
    lazy var changePasswordButton = UIButton().then {
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        $0.addTarget(self, action: #selector(tapChangePasswordButton), for: .touchUpInside)
    }
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    /* 회원정보 (수정 시 변경) */
    
    var dormitoryId: Int?
    var loginId: String?
    var nickname: String?
    var dormitoryList: [Dormitory]?
    
    var selectedDormitory: UIButton?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
        navigationItem.title = "나의 정보 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(hex: 0x2F2F2F)]
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
    }
    
    private func setAttributes() {
        /* 화면 터치 반응 설정 */
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapViewController))
        view.addGestureRecognizer(gesture)
        
        /* 프로필 이미지 뷰 설정 */
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapUserImageView))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
        
        /* 각 항목 타이틀 라벨 공통 설정 */
        [dormitoryLabel, nicknameLabel].forEach {
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
        }
        
        /* 각 항목 타이틀 설정 */
        dormitoryLabel.text = "기숙사"
        nicknameLabel.text = "닉네임"
    }
    
    private func addSubViews() {
        [
            userImageView,
            dormitoryLabel,
            nicknameLabel, nicknameDataTextField, nicknameCheckButton, nicknameValidationLabel,
            changePasswordButton
        ].forEach {
            view.addSubview($0)
        }
        
        [userImageBlurView, userImageViewIcon].forEach {
            userImageView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.width.height.equalTo(166)
            make.centerX.equalToSuperview()
        }
        userImageBlurView.snp.makeConstraints { make in
            make.center.equalTo(userImageView.snp.center)
            make.width.height.equalToSuperview()
        }
        userImageViewIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(145)
        }
        
        dormitoryLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(64)
            make.left.equalToSuperview().inset(23)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(dormitoryLabel.snp.bottom).offset(59)
            make.left.equalToSuperview().inset(23)
        }
        nicknameDataTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(nicknameCheckButton.snp.left).offset(-17)
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
        
        changePasswordButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(150)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(42)
        }
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
    
    private func setUserInfo() {
        /* textfield로 변경 */
        UserInfoAPI.getEditUserInfo { isSuccess, result in
            if isSuccess {
                let url = URL(string: result.imgUrl!)
                self.userImageView.kf.setImage(with: url)
                
                self.nicknameDataTextField.text = result.nickname
                
                self.dormitoryId = result.dormitoryId
                self.loginId = result.loginId
                self.nickname = result.nickname
                
                self.dormitoryList = result.dormitoryList
                
                self.setDormitoryList(dormitoryList: self.dormitoryList!)
            }
        }
    }
    
    private func setDormitoryList(dormitoryList: [Dormitory]) {
        var views: [UIView] = []
        
        dormitoryList.forEach { dormitory in
            let view = UIView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 5
                $0.snp.makeConstraints { make in
                    make.width.equalTo(86)
                    make.height.equalTo(33)
                }
            }
            
            let button = UIButton().then {
                $0.setTitle(dormitory.dormitoryName, for: .normal)
                $0.backgroundColor = .init(hex: 0xF8F8F8)
                $0.titleLabel?.font = .customFont(.neoMedium, size: 15)
                $0.addTarget(self, action: #selector(tapDormitoryButton(_:)), for: .touchUpInside)
                if dormitory.dormitoryId == self.dormitoryId {
                    $0.setTitleColor(.mainColor, for: .normal)
                    self.selectedDormitory = $0
                } else {
                    $0.setTitleColor(.init(hex: 0xA8A8A8), for: .normal)
                }
            }
            
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalToSuperview()
            }
            
            views.append(view)
        }
        
        let stackView = UIStackView(arrangedSubviews: views).then {
            $0.axis = .horizontal
            $0.spacing = 23
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(dormitoryLabel.snp.bottom).offset(12)
        }
    }
    
    private func activeRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRightBarButton))
        navigationItem.rightBarButtonItem?.tintColor = .mainColor
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("CorrectPassword"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                self.visualEffectView?.removeFromSuperview()
                self.visualEffectView = nil
            }
        }
    }
    
    
    // MARK: - objc Functions
    
    @objc
    private func tapUserImageView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
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
    private func tapEditConfirmButton() {
        let input = EditUserInput (
            checkPassword: "",
            dormitoryId: self.dormitoryId,
            loginId: self.loginId,
            nickname: self.nickname,
            password: ""
        )
        
        UserInfoAPI.editUser(input, imageData: userImageView.image!) { isSuccess, result in
            if isSuccess {
                print("회원정보 수정 완료")
                self.setUserInfo()
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
    private func tapXButton() {
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
        editConfirmView.removeFromSuperview()
    }
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    private func tapCheckButton(sender: UIButton) {
        if sender == nicknameCheckButton { // 닉네임 중복 확인 버튼일 경우
            guard let isValidNickname = nicknameDataTextField.text?.isValidNickname() else { return }
            if isValidNickname { // validation 적합한 경우 -> 닉네임 중복 확인 API 호출
                guard let newNickname = nicknameDataTextField.text else { return }
                let input = NickNameRepetitionInput(nickName: newNickname)
                RepetitionAPI.checkNicknameRepetition(input) { isSuccess, message in
                    switch isSuccess {
                    case .success:
                        self.nickname = newNickname
                        self.showToast(viewController: self, message: "사용 가능한 닉네임입니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                        self.activeRightBarButton()
                    case .onlyRequestSuccess:
                        self.showToast(viewController: self, message: "서버 오류입니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    case .failure:
                        self.showToast(viewController: self, message: "중복되는 닉네임입니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    }
                }
            } else { // validation 부적합한 경우 -> Alert
                self.showToast(viewController: self, message: "입력 조건을 확인해주세요", font: .customFont(.neoBold, size: 15), color: .red)
            }
        }
    }
    
    @objc
    private func tapDormitoryButton(_ sender: UIButton) {
        if sender != selectedDormitory {
            activeRightBarButton()
            
            selectedDormitory?.setTitleColor(.init(hex: 0xA8A8A8), for: .normal)
            selectedDormitory = sender
            selectedDormitory?.setTitleColor(.mainColor, for: .normal)
            
            dormitoryList?.forEach {
                if $0.dormitoryName == sender.titleLabel?.text {
                    self.dormitoryId = $0.dormitoryId
                }
            }
        }
    }
    
    @objc
    private func tapChangePasswordButton() {
        createBlurView()
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = PasswordCheckViewController().then {
                $0.dormitoryId = self.dormitoryId
                $0.loginId = self.loginId
                $0.nickname = self.nickname
                $0.profileImg = self.userImageView.image
            }
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapViewController() {
        if visualEffectView != nil {
            visualEffectView?.removeFromSuperview()
            visualEffectView = nil
            NotificationCenter.default.post(name: NSNotification.Name("ClosePasswordCheckVC"), object: "true")
        }
    }
}

extension EditMyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        
        switch textField {
        case nicknameDataTextField:
            nicknameValidationLabel.isHidden = false
            nicknameCheckButton.setActivatedCheckButton()
            nicknameDataTextField.subviews.first?.backgroundColor = .mainColor
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
            nicknameCheckButton.setDeactivatedCheckButton()
        default:
            return
        }
    }
}

extension EditMyInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.userImageView.image = image as? UIImage
                }
            }
        }
        
        self.activeRightBarButton()
    }
}

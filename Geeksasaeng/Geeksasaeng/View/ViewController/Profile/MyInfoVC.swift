//
//  MyInfoVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/17.
//

import UIKit
import SnapKit
import Then

class MyInfoViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - SubViews
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapContentView))
        $0.addGestureRecognizer(gesture)
    }
    
    let userImageView = UIImageView().then {
        $0.image = UIImage(named: "EditUserImage")
    }
    
    /* title labels */
    let dormitoryLabel = UILabel()
    let nicknameLabel = UILabel()
    let idLabel = UILabel()
    let emailLabel = UILabel()
    let phoneNumLabel = UILabel()
    
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
    lazy var nicknameDataLabel = UILabel()
    lazy var idDataLabel = UILabel()
    lazy var emailDataLabel = UILabel()
    lazy var phoneNumDataLabel = UILabel()
    
    lazy var logoutButton = UIButton().then {
        $0.setTitleColor(UIColor(hex: 0x2F2F2F), for: .normal)
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 15)
        $0.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
    }
    
    lazy var withdrawalMembershipButton = UIButton().then {
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.makeBottomLine(color: 0xA8A8A8, width: 48, height: 1, offsetToTop: -8)
        $0.setTitle("회원탈퇴", for: .normal)
    }
    
    lazy var logoutView = UIView().then {
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
            $0.text = "로그아웃"
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
            $0.text = "로그아웃 시 서비스 사용이 제한\n되며, 로그인이 필요합니다.\n계속하시겠습니까?"
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
            $0.addTarget(self, action: #selector(self.tapLogoutConfirmButton), for: .touchUpInside)
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
    
    
    // MARK: - Properties
    var naverLoginVM = naverLoginViewModel()
    
    
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
        navigationItem.title = "나의 정보"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(hex: 0x2F2F2F)]
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Pencil"), style: .plain, target: self, action: #selector(tapEditButton))
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    private func setAttributes() {
        [dormitoryLabel, nicknameLabel, idLabel, emailLabel, phoneNumLabel].forEach {
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
        }
        
        dormitoryLabel.text = "기숙사"
        nicknameLabel.text = "닉네임"
        idLabel.text = "아이디"
        emailLabel.text = "이메일"
        phoneNumLabel.text = "전화번호"
        
        [nicknameDataLabel, idDataLabel, emailDataLabel, phoneNumDataLabel].forEach {
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 15)
            $0.makeBottomLine(color: 0xF8F8F8, width: view.bounds.width - 56, height: 1, offsetToTop: 10)
        }
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            userImageView,
            dormitoryLabel, dormitoryDataLabel,
            nicknameLabel, nicknameDataLabel,
            idLabel, idDataLabel,
            emailLabel, emailDataLabel,
            phoneNumLabel, phoneNumDataLabel,
            logoutButton,
            withdrawalMembershipButton
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
            make.height.equalTo(UIScreen.main.bounds.height + 170)
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
        nicknameDataLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(33)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameDataLabel.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        idDataLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(33)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(idDataLabel.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        emailDataLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(33)
        }
        
        phoneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(emailDataLabel.snp.bottom).offset(55)
            make.left.equalToSuperview().inset(23)
        }
        phoneNumDataLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(33)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.width.equalTo(128)
            make.height.equalTo(42)
            make.top.equalTo(phoneNumDataLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
        }
        
        withdrawalMembershipButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUserInfo() {
        UserInfoAPI.getUserInfo { isSuccess, result in
            self.dormitoryDataLabel.text = result.dormitoryName
            self.nicknameDataLabel.text = result.nickname
            self.idDataLabel.text = result.loginId
            self.emailDataLabel.text = result.emailAddress
            self.phoneNumDataLabel.text = result.phoneNumber
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
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 내 정보 수정 버튼 (연필) 눌렀을 때 실행되는 함수 */
    @objc
    private func tapEditButton() {
        // 비밀번호 확인 창 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = PaaswordCheckViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }

    @objc
    private func tapLogoutButton() {
        if visualEffectView == nil {
            createBlurView()
            view.addSubview(logoutView)
            logoutView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(256)
                make.height.equalTo(236)
            }
        }
    }
    
    @objc
    private func tapXButton() {
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
        logoutView.removeFromSuperview()
    }
    
    @objc
    private func tapLogoutConfirmButton() {
        UserDefaults.standard.set("nil", forKey: "jwt") // delete local jwt
        naverLoginVM.resetToken() // delete naver login token
        
        let rootVC = LoginViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func tapContentView() {
        print("contentView Tapped")
        if visualEffectView != nil {
            visualEffectView?.removeFromSuperview()
            visualEffectView = nil
            logoutView.removeFromSuperview()
        }
    }
}

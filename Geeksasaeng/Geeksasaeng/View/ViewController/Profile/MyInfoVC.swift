//
//  MyInfoVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/17.
//

import UIKit
import SnapKit

class MyInfoViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - SubViews
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EditUserImage")
        return imageView
    }()
    
    /* title labels */
    let dormitoryLabel = UILabel()
    let nicknameLabel = UILabel()
    let idLabel = UILabel()
    let emailLabel = UILabel()
    let phoneNumLabel = UILabel()
    
    /* content labels */
    let dormitoryDataLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .init(hex: 0xEFEFEF)
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 15)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.paddingTop = 7
        label.paddingBottom = 7
        label.paddingLeft = 15
        label.paddingRight = 15
        return label
    }()
    lazy var nicknameDataLabel = UILabel()
    lazy var idDataLabel = UILabel()
    lazy var emailDataLabel = UILabel()
    lazy var phoneNumDataLabel = UILabel()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: 0x2F2F2F), for: .normal)
        button.backgroundColor = .init(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 15)
        button.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    lazy var withdrawalMembershipButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.makeBottomLine(color: 0xA8A8A8, width: 48, height: 1, offsetToTop: -8)
        button.setTitle("회원탈퇴", for: .normal)
        return button
    }()
    
    lazy var logoutView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
  
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "로그아웃"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoMedium, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(tapXButton), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "로그아웃 시 서비스 사용이 제한\n되며, 로그인이 필요합니다.\n계속하시겠습니까?"
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .init(hex: 0x2F2F2F)
        contentLabel.font = .customFont(.neoMedium, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapLogoutConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
        
        return view
    }()
    
    var visualEffectView: UIVisualEffectView?
    
    
    // MARK: - Properties
    var naverLoginVM = naverLoginViewModel()
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        setNavigationBar()
        setComponentsAttributes()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Pencil"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    private func setComponentsAttributes() {
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
    
    private func createBlueView() {
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

    @objc
    private func tapLogoutButton() {
        if visualEffectView == nil {
            createBlueView()
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

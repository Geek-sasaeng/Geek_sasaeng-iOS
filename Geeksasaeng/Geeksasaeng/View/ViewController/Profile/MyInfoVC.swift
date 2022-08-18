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
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EditUserImage")
        return imageView
    }()
    
    let dormitoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        label.text = "기숙사"
        return label
    }()
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
        label.text = "별별학사"
        return label
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        label.text = "닉네임"
        return label
    }()
    lazy var nicknameDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 15)
        label.makeBottomLine(color: 0xF8F8F8, width: view.bounds.width - 56, height: 1, offsetToTop: 10)
        label.text = "Neo01"
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        label.text = "아이디"
        return label
    }()
    lazy var idDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 15)
        label.makeBottomLine(color: 0xF8F8F8, width: view.bounds.width - 56, height: 1, offsetToTop: 10)
        label.text = "Neo01"
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        label.text = "이메일"
        return label
    }()
    lazy var emailDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 15)
        label.makeBottomLine(color: 0xF8F8F8, width: view.bounds.width - 56, height: 1, offsetToTop: 10)
        label.text = "Neo01@naver.com"
        return label
    }()
    
    let phoneNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        label.text = "전화번호"
        return label
    }()
    lazy var phoneNumDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 15)
        label.makeBottomLine(color: 0xF8F8F8, width: view.bounds.width - 56, height: 1, offsetToTop: 10)
        label.text = "010-0000-0000"
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: 0x2F2F2f), for: .normal)
        button.backgroundColor = .init(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("로그아웃", for: .normal)
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
    
    // MARK: - Properties
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        setNavigationBar()
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
            make.top.equalToSuperview().inset(97)
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
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    private func tapLogoutButton() {
        print("tapLogoutButton")
        UserDefaults.standard.set("nil", forKey: "jwt")
        let rootVC = LoginViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}

//
//  DormitoryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/10.
//

import UIKit
import SnapKit

/* 회원가입 후, 첫 로그인 성공 시에 나오게 되는 기숙사 선택 화면 */
class DormitoryViewController: UIViewController {
    
    // MARK: - Subviews
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        // TODO: 로그인 시 홍길동 말고 해당 유저의 닉네임으로 설정해야 함
        label.text = "홍길동님, 환영합니다"
        label.numberOfLines = 2
        label.font = .customFont(.neoBold, size: 32)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 어느 기숙사에 거주하고 계신가요?"
        label.numberOfLines = 2
        label.font = .customFont(.neoBold, size: 24)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "*추후 프로필에서 기숙사를 변경하실 수 있습니다"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var backgroundLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackgroundLogo")
        return imageView
    }()
    
    var dormitoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        // TODO: 학교 선택에 따른 기숙사 갯수 불러오기
//        pickerView.backgroundColor = .mainColor
        return pickerView
    }()
    
    var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(showHomeView), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        // addSubview
        [
            welcomeLabel,
            questionLabel,
            guideLabel,
            backgroundLogoImageView,
            dormitoryPickerView,
            startButton
        ].forEach { view.addSubview($0) }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalToSuperview().inset(23)
            make.width.equalTo(148)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(68)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(195)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
        }
        
        backgroundLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(19)
            make.right.equalToSuperview()
        }
        
        dormitoryPickerView.snp.makeConstraints { make in
            make.centerY.equalTo(guideLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
        }
        
        startButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    // 홈 화면으로
    @objc private func showHomeView() {
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
}

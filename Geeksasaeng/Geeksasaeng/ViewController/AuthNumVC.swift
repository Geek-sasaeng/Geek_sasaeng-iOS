//
//  AuthNumVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

class AuthNumViewController: UIViewController {
    
    // MARK: - Subviews
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        return view
    }()
    
    var authNumLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호 입력"
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }()
    
    var authNumTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
        )
        textField.makeBottomLine(187)
        return textField
    }()
    
    var reSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("재전송 하기", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 13)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00분 00초 남았어요"
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()

    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeRegister), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayouts()
        makeButtonShadow(reSendButton)
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        [
            progressBar,
            remainBar
        ].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(3)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            }
        }
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.width.equalTo(186)
            make.left.equalToSuperview().inset(25)
        }
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
            
        [
            authNumLabel,
            authNumTextField,
            remainTimeLabel,
            reSendButton,
            nextButton
        ].forEach { view.addSubview($0) }
        
        /* authNumLabel */
        authNumLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(27)
        }
        
        /* authNumTextField */
        authNumTextField.snp.makeConstraints { make in
            make.top.equalTo(authNumLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(36)
        }
        
        /* remainTimeLabel */
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalTo(authNumTextField.snp.bottom).offset(21)
        }
        
        /* reSendButton */
        reSendButton.snp.makeConstraints { make in
            make.top.equalTo(remainBar.snp.bottom).offset(80)
            make.right.equalToSuperview().inset(26)
            make.width.equalTo(105)
            make.height.equalTo(41)
        }
        
        /* nextButton */
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    // 버튼 뒤의 mainColor의 Shadow를 만드는 함수
    private func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    // 다음 버튼을 누르면 -> 회원 가입 완료 & 로그인 화면 띄우기
    @objc func completeRegister() {
        let loginVC = LoginViewController()
        loginVC.modalTransitionStyle = .coverVertical
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
        
}

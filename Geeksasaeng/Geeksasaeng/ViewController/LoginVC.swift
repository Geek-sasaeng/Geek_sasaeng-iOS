//
//  ViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/06/28.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
  
  // MARK: Variables
  let logoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "AppLogo"))
    return imageView
  }()

  var idTextField: UITextField = {
    var textField = UITextField()
    textField.font = .customFont(.neoLight, size: 14)
    textField.attributedPlaceholder = NSAttributedString(
        string: "아이디",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
    )
    textField.makeBottomLine(335)
    return textField
  }()
  
  var passwordTextField: UITextField = {
    var textField = UITextField()
    textField.font = .customFont(.neoLight, size: 14)
    textField.attributedPlaceholder = NSAttributedString(
        string: "비밀번호",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8)]
    )
    textField.makeBottomLine(335)
    return textField
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .customFont(.neoBold, size: 20)
    button.titleLabel?.textColor = .white
    button.backgroundColor = UIColor.init(hex: 0x29ABE2)
    button.setTitleColor(UIColor.white, for: .normal)
    button.layer.cornerRadius = 5
    return button
  }()
  
  let naverLoginButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "naverLogo"), for: .normal)
    button.adjustsImageWhenHighlighted = false
    button.setTitle("  네이버 로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .customFont(.neoBold, size: 20)
    button.titleLabel?.textColor = .white
    button.backgroundColor = UIColor.init(hex: 0x00C73C)
    button.setTitleColor(UIColor.white, for: .normal)
    button.layer.cornerRadius = 5
    return button
  }()
  
  var automaticLoginButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "rectangle"), for: .normal)
    button.imageView?.tintColor = UIColor(hex: 0x5B5B5B)
    button.setTitle(" 자동 로그인", for: .normal)
    button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
    button.titleLabel?.font = .customFont(.neoLight, size: 15)
    return button
  }()
  
  var signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("회원가입", for: .normal)
    button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
    button.titleLabel?.font = .customFont(.neoLight, size: 15)
    button.makeBottomLine(55)
    button.addTarget(self, action: #selector(showRegisterView), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    addSubViews()
    configLayouts()
  }
  
  // MARK: Config Methods
  func addSubViews() {
    view.addSubview(logoImageView)
    view.addSubview(idTextField)
    view.addSubview(passwordTextField)
    view.addSubview(loginButton)
    view.addSubview(naverLoginButton)
    view.addSubview(automaticLoginButton)
    view.addSubview(signUpButton)
  }
  
  func configLayouts() {
    logoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(133)
      make.centerX.equalTo(self.view.center)
      make.top.equalToSuperview().offset(150)
    }
    
    idTextField.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.logoImageView.snp.bottom).offset(50)
      make.left.equalTo(23)
      make.width.equalTo(314)
    }
    
    passwordTextField.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.idTextField.snp.bottom).offset(30)
      make.left.equalTo(23)
      make.width.equalTo(314)
    }
    
    loginButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.width.equalTo(314)
      make.top.equalTo(self.passwordTextField.snp.bottom).offset(50)
      make.height.equalTo(51)
    }
    
    naverLoginButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.width.equalTo(314)
      make.top.equalTo(self.loginButton.snp.bottom).offset(10)
      make.height.equalTo(51)
    }

    automaticLoginButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.naverLoginButton.snp.bottom).offset(15)
    }

    signUpButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.automaticLoginButton.snp.bottom).offset(45)
    }
  }
    
    @objc func showRegisterView(sender: UIButton!) {
        // registerVC로 화면 전환.
        let registerVC = RegisterViewController()
        
        registerVC.modalTransitionStyle = .coverVertical
        registerVC.modalPresentationStyle = .fullScreen
        
        present(registerVC, animated: true)
    }
   
}


// Extensions
extension UIView {

  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
      let border = CALayer()
      border.backgroundColor = color.cgColor
      border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
      self.layer.addSublayer(border)
  }
}

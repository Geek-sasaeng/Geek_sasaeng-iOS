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
    textField.placeholder = "아이디"
    return textField
  }()
  
  var passwordTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "비밀번호"
    return textField
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()
  
  let naverLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("네이버 로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()
  
  var automaticLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("자동 로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()
  
  var signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("회원가입", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()
  
  
  // MARK: viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    addSubViews()
    configLayout()
  }
  
  // MARK: Config Methods
  func addSubViews() {
    self.view.addSubview(logoImageView)
    self.view.addSubview(idTextField)
    self.view.addSubview(passwordTextField)
    self.view.addSubview(loginButton)
    self.view.addSubview(naverLoginButton)
    self.view.addSubview(automaticLoginButton)
    self.view.addSubview(signUpButton)
  }
  
  func configLayout() {
    logoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(133)
      make.centerX.equalTo(self.view.center)
      make.top.equalToSuperview().offset(150)
    }
    
    idTextField.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.logoImageView.snp.bottom).offset(50)
      make.left.equalTo(23)
      make.right.equalTo(-23)
    }
    
    passwordTextField.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.top.equalTo(self.idTextField.snp.bottom).offset(30)
      make.left.equalTo(23)
      make.right.equalTo(-23)
    }
    
    loginButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.width.equalTo(314)
      make.top.equalTo(self.passwordTextField.snp.bottom).offset(50)
    }
    
    naverLoginButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.logoImageView)
      make.width.equalTo(314)
      make.top.equalTo(self.loginButton.snp.bottom).offset(10)
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
}


//extension UITextField {
//
//  func useUnderline() -> Void {
//    let border = CALayer()
//    let borderWidth = CGFloat(2.0) // Border Width
//    border.borderColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1).cgColor
//    border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
//    border.borderWidth = borderWidth
//    self.layer.addSublayer(border)
//    self.layer.masksToBounds = true
//  }
//
//}

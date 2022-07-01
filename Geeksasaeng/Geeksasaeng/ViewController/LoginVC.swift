//
//  ViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/06/28.
//

import UIKit

class LoginViewController: UIViewController {
  
//  var titleLabel: UILabel = {
//    let label = UILabel()
//    label.text = "Test"
//    label.textColor = UIColor.black
//    label.textAlignment = .center
//    label.font = UIFont(name: "GmarketSansMedium", size: 100)
//    return label
//  }()
  
  var logoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "AppLogo"))
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    addSubViews()
    configLayout()
  }
  
  func addSubViews() {
    self.view.addSubview(logoImageView)
  }
  
  func configLayout() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

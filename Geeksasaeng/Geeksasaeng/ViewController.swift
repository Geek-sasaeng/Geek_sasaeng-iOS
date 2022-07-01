//
//  ViewController.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/06/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Test"
    label.textColor = UIColor.black
    label.textAlignment = .center
    label.font = UIFont(name: "GmarketSansMedium", size: 100)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    self.view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
}

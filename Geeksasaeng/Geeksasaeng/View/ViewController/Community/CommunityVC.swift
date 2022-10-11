//
//  CommunityViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/18.
//

import UIKit

import SnapKit
import Then

class CommunityViewController: UIViewController {

    let readyView = UIView().then {
        $0.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "ReadyImage"))
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(143)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(readyView)
        readyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

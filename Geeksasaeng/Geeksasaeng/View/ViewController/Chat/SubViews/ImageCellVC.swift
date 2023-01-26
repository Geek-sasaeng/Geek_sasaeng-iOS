//
//  ImageCellVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/25.
//

import UIKit
import SnapKit
import Then

class ImageCellViewController: UIViewController {
    // MARK: - Properties
    var blurView: UIVisualEffectView?
    var nickname: String?
    var date: String?
    var imageUrl: URL?
    
    // MARK: - SubViews
    
    let imageMessageExpansionNicknameLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .white
    }
    
    let imageMessageExpansionDateLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 12)
        $0.textColor = .white
    }
    
    let imageMessageExpansionTimeLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 12)
        $0.textColor = .white
    }
    
    let imageMessageExpansionImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView = setMoreDarkBlurView()
        setAttributes()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapVisualEffectView))
        blurView?.isUserInteractionEnabled = true
        blurView?.addGestureRecognizer(gesture)
        
        imageMessageExpansionNicknameLabel.text = nickname
        
        let str = date
        let dateEndIdx = str?.index(str!.startIndex, offsetBy: 10)
//        let timeStartIdx = str?.index(str!.startIndex, offsetBy: 11)
        imageMessageExpansionDateLabel.text = str![...dateEndIdx!] + "\n" + str![dateEndIdx!...]
        imageMessageExpansionTimeLabel.text = "오후 9:00" // 더미
        
        imageMessageExpansionImageView.kf.setImage(with: imageUrl)
    }
    
    private func addSubViews() {
        [ imageMessageExpansionNicknameLabel, imageMessageExpansionDateLabel, imageMessageExpansionTimeLabel,
          imageMessageExpansionImageView ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        imageMessageExpansionNicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(78)
            make.centerX.equalToSuperview()
        }
        
        imageMessageExpansionDateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageMessageExpansionNicknameLabel.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        imageMessageExpansionTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageMessageExpansionDateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        imageMessageExpansionImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(331)
        }
    }
    
    
    // MARK: - objc Functions
    
    @objc private func tapVisualEffectView() {
        dismiss(animated: true)
    }
}

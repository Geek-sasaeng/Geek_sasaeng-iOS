//
//  PartyVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

class PartyViewController: UIViewController {

    // MARK: - Subviews
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "ProfileImage")
        return imageView
    }()
    
    var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "네오"
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var postingTime: UILabel = {
        let label = UILabel()
        label.text = "05/15 23:57"
        label.font = .customFont(.neoRegular, size: 11)
        label.textColor = .init(hex: 0xD8D8D8)
        return label
    }()
    
    var hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "# 같이 먹고 싶어요"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "중식 같이 먹어요 같이 먹자"
        label.font = .customFont(.neoBold, size: 20)
        label.textColor = .black
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구."
        label.font = .customFont(.neoLight, size: 15)
        label.textColor = .init(hex: 0x5B5B5B)
        label.numberOfLines = 0
        return label
    }()
    
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    var orderReserveTimeLabel = UILabel()
    var matchingLabel = UILabel()
    var category = UILabel()
    var infoStackView = UIStackView()
    
    var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    var matchingStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var peopleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "People")
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayouts()
        setAttributes()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        [
            profileImageView,
            nickNameLabel,
            postingTime,
            hashTagLabel,
            titleLabel,
            contentLabel,
            separateView,
            matchingStatusView,
            peopleImage
        ].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(105)
            make.left.equalToSuperview().inset(23)
            make.width.height.equalTo(26)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        postingTime.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel.snp.right).offset(15)
            make.centerY.equalTo(nickNameLabel.snp.centerY)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(hashTagLabel.snp.bottom).offset(9)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.right.equalToSuperview().inset(23)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(34)
            make.height.equalTo(8)
            make.width.equalToSuperview()
        }
        
        matchingStatusView.snp.makeConstraints { make in
            let constant = tabBarController?.tabBar.frame.size.height
            make.bottom.equalToSuperview().inset(constant!)
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        peopleImage.snp.makeConstraints { make in
            make.centerY.equalTo(matchingStatusView.snp.centerY)
            make.left.equalToSuperview().inset(29)
        }
    }
    
    private func setAttributes() {
        profileImageView.layer.cornerRadius = 1
    }
    
//    private func setupHorizontalStackView() {
//        horizontalStackView = UIStackView(arrangedSubviews: [lbl1, lbl2])
//        horizontalStackView.axis = .horizontal
//        horizontalStackView.alignment = .fill
//        horizontalStackView.distribution = .fill
//        horizontalStackView.spacing = 2
//    }
}

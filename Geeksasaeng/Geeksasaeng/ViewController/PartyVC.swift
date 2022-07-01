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
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        return button
    }()
    
    var reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Report"), for: .normal)
        return button
    }()
    
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
    
    var orderLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 예정 시간"
        return label
    }()
    var orderReserveDateLabel: UILabel = {
        let label = UILabel()
        label.text = "05월 15일"
        return label
    }()
    var orderReserveTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "23시 00분"
        return label
    }()
    
    var matchingLabel: UILabel = {
        let label = UILabel()
        label.text = "매칭 현황"
        return label
    }()
    var matchingDataLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        return label
    }()
    var categoryDataLabel: UILabel = {
        let label = UILabel()
        label.text = "중식"
        return label
    }()
    
    var pickupLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "수령 장소"
        return label
    }()
    var pickupLocationDataLabel: UILabel = {
        let label = UILabel()
        label.text = "제1기숙사 후문"
        return label
    }()
    
    var horizontalStackView1: UIStackView!
    var horizontalStackView2: UIStackView!
    var horizontalStackView3: UIStackView!
    var horizontalStackView4: UIStackView!
    
    var verticalStackView: UIStackView!

    var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
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
    
    var matchingDataWhiteLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.textColor = .white
        return label
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .white
        return label
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("신청하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 16)
        return button
    }()
    
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Arrow")
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        horizontalStackView1 = UIStackView(arrangedSubviews: [orderLabel, orderReserveDateLabel, orderReserveTimeLabel])
        horizontalStackView2 = UIStackView(arrangedSubviews: [matchingLabel, matchingDataLabel])
        horizontalStackView3 = UIStackView(arrangedSubviews: [categoryLabel, categoryDataLabel])
        horizontalStackView4 = UIStackView(arrangedSubviews: [pickupLocationLabel, pickupLocationDataLabel])
        verticalStackView = UIStackView(arrangedSubviews: [
            horizontalStackView1,
            horizontalStackView2,
            horizontalStackView3,
            horizontalStackView4
            ])
        setLayouts()
        setAttributes()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        [
            backButton,
            reportButton,
            profileImageView,
            nickNameLabel,
            postingTime,
            hashTagLabel,
            titleLabel,
            contentLabel,
            separateView,
            matchingStatusView,
            peopleImage,
            verticalStackView,
            mapView,
            matchingDataWhiteLabel,
            remainTimeLabel,
            signUpButton,
            arrowImageView
        ].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(52)
            make.left.equalToSuperview().inset(24)
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(24)
        }
        
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
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(28)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(13)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(122)
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
        
        matchingDataWhiteLabel.snp.makeConstraints { make in
            make.left.equalTo(peopleImage.snp.right).offset(12)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(matchingDataWhiteLabel.snp.right).offset(33)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            make.left.equalTo(remainTimeLabel.snp.right).offset(62)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { make in
            make.left.equalTo(signUpButton.snp.right).offset(11)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        
    }
    
    private func setAttributes() {
        profileImageView.layer.cornerRadius = 1
        
        [
            orderLabel,
            orderReserveDateLabel,
            orderReserveTimeLabel,
            matchingLabel,
            matchingDataLabel,
            categoryLabel,
            categoryDataLabel,
            pickupLocationLabel,
            pickupLocationDataLabel
        ].forEach {
            $0.font = .customFont(.neoMedium, size: 13)
        }
        
        [
            horizontalStackView1,
            horizontalStackView2,
            horizontalStackView3,
            horizontalStackView4
        ].forEach {
            $0!.axis = .horizontal
            $0!.alignment = .fill
            $0!.distribution = .fill
            $0!.spacing = 20
        }
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 24
        
        mapView.layer.cornerRadius = 5
    }
}

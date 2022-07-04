//
//  DeliveryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import UIKit
import SnapKit

class DeliveryViewController: UIViewController {
    // MARK: Subviews
    let leftBarButtonItem: UIBarButtonItem = {
        var schoolImageView = UIImageView(image: UIImage(systemName: "book"))
        schoolImageView.tintColor = .black
        schoolImageView.snp.makeConstraints { make in
            make.width.height.equalTo(31)
        }
        
        let dormitoryLabel = UILabel()
        dormitoryLabel.text = "제1기숙사"
        dormitoryLabel.font = .customFont(.neoBold, size: 20)
        dormitoryLabel.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [schoolImageView, dormitoryLabel])
        stackView.spacing = 10
        
        
        let barButton = UIBarButtonItem(customView: stackView)
        
        return barButton
    }()
    
    let rightBarButtonItem: UIBarButtonItem = {
        let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.titleLabel?.font = .customFont(.neoBold, size: 20)
        
        let barButton = UIBarButtonItem(customView: searchButton)
        
        return barButton
    }()
    
    let categoryStackView: UIStackView = {
        let deliveryPartyLabel = UILabel()
        let marketLabel = UILabel()
        let helperLabel = UILabel()
        for label in [deliveryPartyLabel, marketLabel, helperLabel] {
            label.font = .customFont(.neoMedium, size: 14)
        }
        deliveryPartyLabel.textColor = .black
        deliveryPartyLabel.text = "배달파티"
        marketLabel.textColor = UIColor(hex: 0xCBCBCB)
        marketLabel.text = "마켓"
        helperLabel.textColor = UIColor(hex: 0xCBCBCB)
        helperLabel.text = "헬퍼"
        
        let stackView = UIStackView(arrangedSubviews: [deliveryPartyLabel, marketLabel, helperLabel])
        stackView.spacing = 75
        
        return stackView
    }()
    
    var deliveryPartyBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var marketBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF2F2F2)
        return view
    }()
    
    var helperBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF2F2F2)
        return view
    }()
    
    var adImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "BannerAd"))
        
        return imageView
    }()
    
    let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal.decrease.circle"))
        imageView.tintColor = UIColor(hex: 0x2F2F2F)
        
        return imageView
    }()
    
    var peopleFilterView: UIView = {
        var uiView = UIView()
        uiView.layer.borderColor = UIColor(hex: 0xD8D8D8).cgColor
        uiView.layer.borderWidth = 1
        uiView.layer.cornerRadius = 3
        
        var label = UILabel()
        label.text = "2명 이하"
        label.font = .customFont(.neoLight, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        uiView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xA8A8A8)
        uiView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(label.snp.right).offset(5)
        }
        
        return uiView
    }()
    
    var timeFilterView: UIView = {
        var uiView = UIView()
        uiView.layer.borderColor = UIColor(hex: 0xD8D8D8).cgColor
        uiView.layer.borderWidth = 1
        uiView.layer.cornerRadius = 3
        
        var label = UILabel()
        label.text = "아침   -   점심"
        label.font = .customFont(.neoLight, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        uiView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xA8A8A8)
        uiView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(label.snp.right).offset(5)
        }
        
        return uiView
    }()
    
    var partyTableView: UITableView = {
        var uiTableView = UITableView()
        
        return uiTableView
    }()
    
    var createPartyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CreatePartyMark"), for: .normal)
        button.layer.cornerRadius = 31
        button.backgroundColor = .white
        
        return button
    }()
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setTableView()
        makeButtonShadow(createPartyButton)
    }
    
    
    // MARK: viewDidLayoutSubviews()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    // MARK: Set Methods
    func addSubViews() {
        [categoryStackView, deliveryPartyBar, marketBar, helperBar, adImageView, filterImageView, peopleFilterView, timeFilterView, partyTableView, createPartyButton].forEach { view.addSubview($0) }
    }
    
    func setLayouts() {
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self.view.center)
        }
        
        deliveryPartyBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(110)
            make.top.equalTo(categoryStackView.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(25)
        }
        
        marketBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(categoryStackView.snp.bottom).offset(5)
            make.left.equalTo(deliveryPartyBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        
        helperBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(categoryStackView.snp.bottom).offset(5)
            make.left.equalTo(marketBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        
        adImageView.snp.makeConstraints { make in
            make.width.equalTo(324)
            make.height.equalTo(86)
            make.top.equalTo(deliveryPartyBar.snp.bottom).offset(10)
            make.centerX.equalTo(view.center)
        }
        
        filterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(10)
            make.left.equalTo(adImageView.snp.left)
        }
        
        peopleFilterView.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(10)
            make.left.equalTo(filterImageView.snp.right).offset(10)
        }
        
        timeFilterView.snp.makeConstraints { make in
            make.width.equalTo(93)
            make.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(10)
            make.left.equalTo(peopleFilterView.snp.right).offset(10)
        }
        
        partyTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(500)
            make.top.equalTo(timeFilterView.snp.bottom).offset(20)
        }
        
        createPartyButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalToSuperview().offset(-100)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func setTableView() {
        partyTableView.dataSource = self
        partyTableView.delegate = self
        partyTableView.register(PartyTableViewCell.self, forCellReuseIdentifier: "PartyTableViewCell")
        partyTableView.rowHeight = 118
    }
    
    
    // MARK: Methods
    func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor(hex: 0xA8A8A8).cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    func setNav() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.image = UIImage(named: "Back")
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}


// MARK: Extensions
extension DeliveryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PartyTableViewCell", for: indexPath) as? PartyTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PartyViewController()
        print("DEBUG: 셀 선택 화면 전환 성공")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

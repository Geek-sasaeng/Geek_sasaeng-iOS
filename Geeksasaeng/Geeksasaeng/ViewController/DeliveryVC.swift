//
//  DeliveryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import UIKit
import SnapKit

class DeliveryViewController: UIViewController {

    // MARK: - Subviews
    
    /* Navigation Bar Buttons */
    var leftBarButtonItem: UIBarButtonItem = {
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
    
    var rightBarButtonItem: UIBarButtonItem = {
        let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        
        let barButton = UIBarButtonItem(customView: searchButton)
        return barButton
    }()
    
    /* Category */
    var deliveryPartyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.text = "배달파티"
        return label
    }()
    var marketLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xCBCBCB)
        label.text = "마켓"
        return label
    }()
    var helperLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0xCBCBCB)
        label.text = "헬퍼"
        return label
    }()
    
    var deliveryPartyBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var marketBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xCBCBCB)
        return view
    }()
    
    var helperBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xCBCBCB)
        return view
    }()
    
    /* Ad */
    var adImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "BannerAd"))
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /* Filter */
    let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal.decrease.circle"))
        imageView.tintColor = UIColor(hex: 0x2F2F2F)
        return imageView
    }()
    
    var peopleFilterView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor(hex: 0xD8D8D8).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        
        var label = UILabel()
        label.text = "2명 이하"
        label.font = .customFont(.neoLight, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(label.snp.right).offset(5)
        }
        return view
    }()
    
    var timeFilterView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor(hex: 0xD8D8D8).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        
        var label = UILabel()
        label.text = "아침   -   점심"
        label.font = .customFont(.neoLight, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(label.snp.right).offset(5)
        }
        
        return view
    }()
    
    var partyTableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    var createPartyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CreatePartyMark"), for: .normal)
        button.layer.cornerRadius = 31
        button.backgroundColor = .white
        return button
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setTableView()
        setLabelTap()
        makeButtonShadow(createPartyButton)
    }
    
    // MARK: - viewDidLayoutSubviews()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            deliveryPartyLabel, marketLabel, helperLabel,
            deliveryPartyBar, marketBar, helperBar,
            adImageView,
            filterImageView, peopleFilterView, timeFilterView,
            partyTableView,
            createPartyButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        
        /* Category Tap */
        deliveryPartyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(deliveryPartyBar.snp.centerX)
        }
        marketLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(marketBar.snp.centerX)
        }
        helperLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(helperBar.snp.centerX)
        }
        deliveryPartyBar.snp.makeConstraints { make in
            make.top.equalTo(deliveryPartyLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(18)
            make.height.equalTo(3)
            make.width.equalTo(110)
        }
        marketBar.snp.makeConstraints { make in
            make.top.equalTo(marketLabel.snp.bottom).offset(5)
            make.left.equalTo(deliveryPartyBar.snp.right)
            make.height.equalTo(3)
            make.width.equalTo(110)
        }
        helperBar.snp.makeConstraints { make in
            make.top.equalTo(helperLabel.snp.bottom).offset(5)
            make.left.equalTo(marketBar.snp.right)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(3)
        }
        
        /* Ad */
        adImageView.snp.makeConstraints { make in
            make.top.equalTo(deliveryPartyBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(18)
            make.centerX.equalTo(view.center)
            make.height.equalTo(86)
        }
        
        /* Filter */
        filterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(13)
            make.left.equalTo(adImageView.snp.left)
        }
        peopleFilterView.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(13)
            make.left.equalTo(filterImageView.snp.right).offset(10)
        }
        timeFilterView.snp.makeConstraints { make in
            make.width.equalTo(93)
            make.height.equalTo(30)
            make.top.equalTo(adImageView.snp.bottom).offset(13)
            make.left.equalTo(peopleFilterView.snp.right).offset(10)
        }
        
        /* TableView */
        partyTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(500)
            make.top.equalTo(timeFilterView.snp.bottom).offset(20)
        }
        
        /* Button */
        createPartyButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalToSuperview().offset(-100)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func setTableView() {
        partyTableView.dataSource = self
        partyTableView.delegate = self
        partyTableView.register(PartyTableViewCell.self, forCellReuseIdentifier: "PartyTableViewCell")
        partyTableView.rowHeight = 118
    }
    
    private func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor(hex: 0xA8A8A8).cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    private func setLabelTap() {
        for label in [deliveryPartyLabel, marketLabel, helperLabel] {
            label.font = .customFont(.neoMedium, size: 14)
            
            // 탭 제스쳐를 label에 추가 -> label을 클릭했을 때 액션이 발생하도록.
            let labelTapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(clickCategoryLabel(sender:)))
            labelTapGesture.numberOfTapsRequired = 1
            labelTapGesture.numberOfTouchesRequired = 1
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(labelTapGesture)
        }
    }
    
    @objc private func clickCategoryLabel(sender: UIGestureRecognizer) {
        // 해당하는 카테고리의 내용으로 리스트를 변경
        let thisLabel = sender.view as! UILabel

        if let category = thisLabel.text {
            switch category {
            case "배달파티":
                print("DEBUG: 배달파티")
                // 바 색깔 파란색으로 활성화
                deliveryPartyBar.backgroundColor = .mainColor
                marketBar.backgroundColor = .init(hex: 0xCBCBCB)
                helperBar.backgroundColor = .init(hex: 0xCBCBCB)
                // 텍스트 색깔 활성화
                deliveryPartyLabel.textColor = .init(hex: 0x2F2F2F)
                marketLabel.textColor = .init(hex: 0xCBCBCB)
                helperLabel.textColor = .init(hex: 0xCBCBCB)
                // 배달파티 리스트 보여주기
                break
            case "마켓":
                print("DEBUG: 마켓")
                // 바 색깔 파란색으로 활성화
                deliveryPartyBar.backgroundColor = .init(hex: 0xCBCBCB)
                marketBar.backgroundColor = .mainColor
                helperBar.backgroundColor = .init(hex: 0xCBCBCB)
                // 텍스트 색깔 활성화
                deliveryPartyLabel.textColor = .init(hex: 0xCBCBCB)
                marketLabel.textColor = .init(hex: 0x2F2F2F)
                helperLabel.textColor = .init(hex: 0xCBCBCB)
                // 마켓 리스트 보여주기
                break
            case "헬퍼":
                print("DEBUG: 헬퍼")
                // 바 색깔 파란색으로 활성화
                deliveryPartyBar.backgroundColor = .init(hex: 0xCBCBCB)
                marketBar.backgroundColor = .init(hex: 0xCBCBCB)
                helperBar.backgroundColor = .mainColor
                // 텍스트 색깔 활성화
                deliveryPartyLabel.textColor = .init(hex: 0xCBCBCB)
                marketLabel.textColor = .init(hex: 0xCBCBCB)
                helperLabel.textColor = .init(hex: 0x2F2F2F)
                // 헬퍼 리스트 보여주기
                break
            default:
                return
            }
        }
    }
}


// MARK: - Extensions

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

//
//  DeliveryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import UIKit
import SnapKit

class DeliveryViewController: UIViewController {
    
    // MARK: - Properties
    // 광고 배너 이미지 데이터 배열
    let adCellDataArray = AdCarouselModel.adCellDataArray
    // 광고 배너의 현재 페이지를 체크하는 변수 (자동 스크롤할 때 필요)
    var nowPage: Int = 0
    
    // 필터뷰가 DropDown 됐는지 안 됐는지 확인하기 위한 변수
    var isDropDownPeople = false
    var isDropDownTime = false
    
    var loginVM: LoginViewModel?
    
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
    
    /* Category Labels */
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
    
    /* Category Bars */
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
    
    /* Ad Collection View */
    private lazy var adCollectionView: UICollectionView = {
        // 셀 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // 광고 셀 크기 설정
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 85)  // 높이를 확정해야 cornerRadius가 적용됨.

        // 광고 이미지 사이 간격 설정
        layout.minimumLineSpacing = 0
        
        // 위에서 만든 레이아웃을 따르는 collection view 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        // 직접 페이징 가능하도록
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    /* Filter Icon */
    let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal.decrease"))
        imageView.tintColor = UIColor(hex: 0x2F2F2F)
        return imageView
    }()
    
    /* People Filter */
    var peopleFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "2명 이하"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        return label
    }()
    var peopleFilterToggleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xD8D8D8)
        return imageView
    }()
    lazy var peopleFilterView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor.init(hex: 0xD8D8D8).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        
        [
            peopleFilterLabel,
            peopleFilterToggleImageView
        ].forEach { view.addSubview($0) }
        
        peopleFilterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        peopleFilterToggleImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(peopleFilterLabel.snp.right).offset(9)
        }
        return view
    }()
   
    /* Time Filter */
    var timeFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "아침   -   점심"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        return label
    }()
    var timeFilterToggleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xD8D8D8)
        return imageView
    }()
    lazy var timeFilterView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor.init(hex: 0xD8D8D8).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        
        [
            timeFilterLabel,
            timeFilterToggleImageView
        ].forEach { view.addSubview($0) }
        
        timeFilterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        timeFilterToggleImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(timeFilterLabel.snp.right).offset(9)
        }
        return view
    }()
    
    /* Expanded Filter Views */
    /* peopleFilterView 눌렀을 때 확장되는 부분의 뷰 */
    lazy var peopleDropDownView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        
        // stackView 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 10
        
        // stackView label 내용 구성
        setVLabelList(["2명 이하", "4명 이하", "6명 이하", "8명 이하", "10명 이하"], stackView)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(11)
        }
        return view
    }()
    /* timeFilterView 눌렀을 때 확장되는 부분의 뷰 */
    lazy var timeDropDownView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        
        // Horizontal StackView 1개 생성
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 20
        
        // Vertical StackView 두개 생성
        let leftLabelStackView = UIStackView()
        let rightLabelStackView = UIStackView()
        // stackView 내용 구성
        setVLabelList(["아침", "점심", "저녁", "야식"], leftLabelStackView)
        setVLabelList(["아침", "점심", "저녁", "야식"], rightLabelStackView)
        // 속성
        [leftLabelStackView, rightLabelStackView].forEach({ stack in
            stack.axis = .vertical
            stack.spacing = 10
        })
        
        // Horizontal StackView에 Vertical StackView 2개를 추가
        stackView.addArrangedSubview(leftLabelStackView)
        stackView.addArrangedSubview(rightLabelStackView)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(11)
        }
        return view
    }()
    
    /* peopleFilterView가 dropdown 됐을 때 테두리를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var peopleFilterContainerView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.isHidden = true
        [peopleFilterView, peopleDropDownView].forEach { view.addSubview($0) }
        return view
    }()
    /* timeFilterView가 dropdown 됐을 때 테두리를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var timeFilterContainerView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.isHidden = true
        [timeFilterView, timeDropDownView].forEach { view.addSubview($0) }
        return view
    }()
    
    /* Table View */
    var partyTableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    var createPartyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CreatePartyMark"), for: .normal)
        button.layer.cornerRadius = 31
        button.backgroundColor = .mainColor
        return button
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        
        setTableView()
        setCollectionView()
        
        setLabelTap()
        setAdCollectionViewTimer()
        setFilterViewTap()
        
        makeButtonShadow(createPartyButton)
        
        print("====\(LoginModel.jwt)====")
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
            adCollectionView,
            filterImageView, peopleFilterView, timeFilterView,
            peopleDropDownView, timeDropDownView,
            peopleFilterContainerView, timeFilterContainerView,
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
        adCollectionView.snp.makeConstraints { make in
            make.top.equalTo(deliveryPartyBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(86)
        }
        
        /* Filter */
        filterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(23)
            make.centerY.equalTo(peopleFilterView.snp.centerY)
            make.left.equalTo(adCollectionView.snp.left).offset(28)
        }
        peopleFilterView.snp.makeConstraints { make in
            make.width.equalTo(79)
            make.height.equalTo(30)
            make.top.equalTo(adCollectionView.snp.bottom).offset(13)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        timeFilterView.snp.makeConstraints { make in
            make.width.equalTo(102)
            make.height.equalTo(30)
            make.top.equalTo(adCollectionView.snp.bottom).offset(13)
            make.left.equalTo(peopleFilterView.snp.right).offset(10)
        }
        peopleDropDownView.snp.makeConstraints { make in
            make.width.equalTo(peopleFilterView)
            make.height.equalTo(140)
            make.top.equalTo(peopleFilterView.snp.bottom)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        timeDropDownView.snp.makeConstraints { make in
            make.width.equalTo(timeFilterView)
            make.height.equalTo(116)
            make.top.equalTo(timeFilterView.snp.bottom)
            make.left.equalTo(peopleFilterView.snp.right).offset(10)
        }
        peopleFilterContainerView.snp.makeConstraints { make in
            make.width.equalTo(79)
            make.height.equalTo(170)
            make.top.equalTo(adCollectionView.snp.bottom).offset(13)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        timeFilterContainerView.snp.makeConstraints { make in
            make.width.equalTo(102)
            make.height.equalTo(146)
            make.top.equalTo(adCollectionView.snp.bottom).offset(13)
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
    
    /* collection view 등록 */
    private func setCollectionView() {
        adCollectionView.delegate = self
        adCollectionView.dataSource = self
        adCollectionView.clipsToBounds = true
        adCollectionView.register(AdCollectionViewCell.self,
                                  forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
    }
    
    /* Vertical Label list의 label을 구성한다 */
    func setVLabelList(_ passedArray: [String], _ stackView: UIStackView) {
          for i in 0..<passedArray.count {
              /* Filter Label */
              let filterLabel = UILabel()
              let filterText = passedArray[i]
              filterLabel.textColor = .init(hex: 0xA8A8A8)
              filterLabel.font = .customFont(.neoMedium, size: 11)
              filterLabel.text = filterText
              
              /* Stack View */
              stackView.addArrangedSubview(filterLabel)
          }
    }
    
    /* 버튼 뒤에 색 번지는 효과 추가 */
    private func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    /* label에 탭 제스쳐 추가 */
    private func setLabelTap() {
        for label in [deliveryPartyLabel, marketLabel, helperLabel] {
            label.font = .customFont(.neoMedium, size: 14)
            
            // 탭 제스쳐를 label에 추가 -> label을 탭했을 때 액션이 발생하도록.
            let labelTapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(tapCategoryLabel(sender:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(labelTapGesture)
        }
    }
    
    /* 카테고리 탭의 label을 탭하면 실행되는 함수 */
    @objc private func tapCategoryLabel(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel

        if let category = label.text {
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
    
    /* 광고 배너 자동 스크롤 기능 */
    /* 3초마다 실행되는 타이머를 세팅 */
    private func setAdCollectionViewTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
            self.moveToNextAd()
        }
    }
    
    /* 다음 광고로 자동 스크롤 */
    private func moveToNextAd() {
        print("DEBUG: ", nowPage)
        // 현재 페이지가 마지막 페이지일 경우,
        if nowPage == adCellDataArray.count - 1 {
            // 맨 처음 페이지로 돌아가도록
            adCollectionView.isPagingEnabled = false    // 자동 스크롤을 위해서 잠시 수동 스크롤 기능을 끈 것.
            adCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            adCollectionView.isPagingEnabled = true
            nowPage = 0
            return
        }
        
        // 다음 페이지로 전환
        nowPage += 1
        adCollectionView.isPagingEnabled = false
        adCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        adCollectionView.isPagingEnabled = true
    }
    
    /* 필터뷰에 탭 제스처 추가 */
    private func setFilterViewTap() {
        [peopleFilterView, timeFilterView].forEach { view in
            let viewTapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(tapFilterView(sender:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(viewTapGesture)
        }
    }
    
    /* 필터뷰 탭하면 실행되는 함수 */
    @objc private func tapFilterView(sender: UIGestureRecognizer) {
        print("DEBUG: filter view tap")
        let filterView = sender.view
        
        if filterView == peopleFilterView {
            // 필터뷰 확장
            isDropDownPeople = !isDropDownPeople
            peopleDropDownView.isHidden = !isDropDownPeople
            peopleFilterContainerView.isHidden = !isDropDownPeople
            
            self.view.bringSubviewToFront(peopleDropDownView)   // 테이블뷰에 가리지 않도록 dropdown view를 앞으로 가져옴.
            self.view.bringSubviewToFront(peopleFilterContainerView)    // 주위 테두리 보이게 하려고 view를 앞으로 가져옴.
            self.view.bringSubviewToFront(peopleFilterView) // peopleFilterView의 탭 제스쳐를 감지해야 하므로 view를 앞으로 가져옴.
            if isDropDownPeople {
                peopleFilterView.layer.borderWidth = 0
                peopleFilterLabel.textColor = .mainColor
                peopleFilterToggleImageView.image =  UIImage(named: "ToggleDownMark")
            } else {
                peopleFilterView.layer.borderWidth = 1
                peopleFilterLabel.textColor = .init(hex: 0xD8D8D8)
                peopleFilterToggleImageView.image =  UIImage(named: "ToggleMark")
            }
            
        } else {
            isDropDownTime = !isDropDownTime
            timeDropDownView.isHidden = !isDropDownTime
            timeFilterContainerView.isHidden = !isDropDownTime
            
            self.view.bringSubviewToFront(timeDropDownView)
            self.view.bringSubviewToFront(timeFilterContainerView)
            self.view.bringSubviewToFront(timeFilterView)
            
            if isDropDownTime {
                timeFilterView.layer.borderWidth = 0
                timeFilterLabel.textColor = .mainColor
                timeFilterToggleImageView.image =  UIImage(named: "ToggleDownMark")
            } else {
                timeFilterView.layer.borderWidth = 1
                timeFilterLabel.textColor = .init(hex: 0xD8D8D8)
                timeFilterToggleImageView.image =  UIImage(named: "ToggleMark")
            }
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DeliveryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* cell(광고) 몇 개 넣을지 설정 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adCellDataArray.count
    }
    
    /* cell에 어떤 이미지의 광고를 넣을지 설정 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // AdCollectionViewCell 타입의 cell 생성
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
        
        // cell의 이미지(광고 이미지) 설정
        cell.cellImageView.image = UIImage(named: adCellDataArray[indexPath.item].cellImagePath)
        print("DEBUG: ", adCellDataArray[indexPath.item].cellImagePath)
        
        return cell
    }
    
    /* 수동 스크롤이 끝났을 때 실행되는 함수 */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if adCollectionView == scrollView {
            // 현재 보이는 셀(광고)의 row로 nowPage 값을 변경한다
            for cell in adCollectionView.visibleCells {
                /* 원래 collection view면 한번에 여러 개의 셀이 보일 수도 있으므로 visibleCells은 배열의 형태를 가지고 있지만,
                   우리 어플에서는 한번에 하나씩의 광고만 보여지므로 이 for문은 한번만 실행됨 */
                if let row = adCollectionView.indexPath(for: cell)?.item {
                    nowPage = row
                }
            }
        }
    }
    
}

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
    
    var deliveryCellDataArray: [DeliveryListModelResult]? = nil {
        didSet
        {
            partyTableView.reloadData()
            print(deliveryCellDataArray)
        }
    }
    
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
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tapSearchButton))
        searchButton.tintColor = .init(hex: 0x2F2F2F)
        return searchButton
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
        collectionView.backgroundColor = .white
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
        label.text = "인원 선택"
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
        view.backgroundColor = .init(hex: 0xF8F8F8)
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
    // 아침
    var breakfastFilterView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 3
        view.snp.makeConstraints { make in
            make.width.equalTo(41)
            make.height.equalTo(28)
        }
        
        let label = UILabel()
        label.text = "아침"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    // 점심
    var launchFilterView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 3
        view.snp.makeConstraints { make in
            make.width.equalTo(41)
            make.height.equalTo(28)
        }
        
        let label = UILabel()
        label.text = "점심"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    // 저녁
    var dinnerFilterView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 3
        view.snp.makeConstraints { make in
            make.width.equalTo(41)
            make.height.equalTo(28)
        }
        
        let label = UILabel()
        label.text = "저녁"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    // 야식
    var midnightSnackFilterView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 3
        view.snp.makeConstraints { make in
            make.width.equalTo(41)
            make.height.equalTo(28)
        }
        
        let label = UILabel()
        label.text = "야식"
        label.font = .customFont(.neoMedium, size: 11)
        label.textColor = UIColor(hex: 0xA8A8A8)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    /* 시간 관련 필터뷰들을 묶어놓는 스택뷰 */
    lazy var timeOptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [breakfastFilterView, launchFilterView, dinnerFilterView, midnightSnackFilterView])
        stackView.spacing = 10
        return stackView
    }()
    
    /* Expanded Filter Views */
    /* DropDown뷰의 데이터가 들어갈 stackView 생성 */
    lazy var peopleOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 10
        
        // stackView label 내용 구성
        setVLabelList(["2명 이하", "4명 이하", "6명 이하", "8명 이하", "10명 이하"], stackView)
        
        return stackView
    }()
    
    /* peopleFilterView 눌렀을 때 확장되는 부분의 뷰 */
    lazy var peopleDropDownView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.isHidden = true
        
        view.addSubview(peopleOptionStackView)
        peopleOptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(11)
        }
        return view
    }()
    
    /* peopleFilterView가 dropdown 됐을 때 테두리 그림자를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var peopleFilterContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.isHidden = true
        
        // 테두리 그림자 생성
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.masksToBounds = false
        
        [peopleFilterView, peopleDropDownView].forEach { view.addSubview($0) }
        
        return view
    }()
    
    /* Table View */
    var partyTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var createPartyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "CreatePartyMark")
        button.setImage(image, for: .normal)
        
        // imageEdgeInsets 값을 줘서 버튼과 안의 이미지 사이 간격을 조정
        let imageInset: CGFloat = 14
        button.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        
        button.layer.cornerRadius = 31
        button.backgroundColor = .mainColor
        button.addTarget(self, action: #selector(tapCreatePartyButton), for: .touchUpInside)
        return button
    }()
    
    /* 테이블뷰 셀 하단에 블러뷰 */
    lazy var blurView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
        // 그라데이션 적용
        view.setGradient(startColor: .init(hex: 0xFFFFFF, alpha: 0.0), endColor: .init(hex: 0xFFFFFF, alpha: 1.0))
        view.isUserInteractionEnabled = false // 블러뷰에 가려진 테이블뷰 셀이 선택 가능하도록 하기 위해
        return view
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
        setFilterViewTap()
        setAdCollectionViewTimer()
        
        makeButtonShadow(createPartyButton)
        
        print("====\(LoginModel.jwt)====")
        
        /* 배달 목록 데이터 로딩 */
        getDeliveryList()
        /* 1분마다 시간 재설정 */
        changeOrderTimeByMinute()
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
            filterImageView, peopleFilterView,
            timeOptionStackView,
            peopleDropDownView, peopleFilterContainerView,
            partyTableView,
            blurView,   // 적은 순서에 따라 view가 추가됨 = 순서에 따라앞뒤의 뷰가 달라짐
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
        timeOptionStackView.snp.makeConstraints { make in
            make.centerY.equalTo(peopleFilterView.snp.centerY)
            make.left.equalTo(peopleFilterView.snp.right).offset(10)
        }
        peopleDropDownView.snp.makeConstraints { make in
            make.width.equalTo(peopleFilterView)
            make.height.equalTo(140)
            make.top.equalTo(peopleFilterView.snp.bottom)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        peopleFilterContainerView.snp.makeConstraints { make in
            make.width.equalTo(79)
            make.height.equalTo(170)
            make.top.equalTo(adCollectionView.snp.bottom).offset(13)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        
        /* TableView */
        partyTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(500)
            make.top.equalTo(peopleFilterView.snp.bottom).offset(8)
        }
        
        /* Button */
        createPartyButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalToSuperview().offset(-100)
            make.right.equalToSuperview().offset(-20)
        }
        
        /* blur view */
        blurView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(140)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setTableView() {
        partyTableView.dataSource = self
        partyTableView.delegate = self
        partyTableView.register(PartyTableViewCell.self, forCellReuseIdentifier: "PartyTableViewCell")
        
        partyTableView.rowHeight = 125
    }
    
    /* 배달 목록 정보 API로 불러오기 */
    private func getDeliveryList() {
        DeliveryListViewModel.requestGetDeliveryList(self, cursor: 0, dormitoryId: 1)
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
              filterLabel.textColor = .init(hex: 0xD8D8D8)
              filterLabel.font = .customFont(.neoMedium, size: 11)
              filterLabel.text = filterText
              
              /* Stack View */
              stackView.addArrangedSubview(filterLabel)
          }
    }
    
    /* 버튼 뒤에 색 번지는 효과 추가 */
    private func makeButtonShadow(_ button: UIButton) {
        button.layer.shadowRadius = 3
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = true
    }
    
    /* 검색 버튼 눌렀을 때 검색 화면으로 전환 */
    @objc func tapSearchButton() {
        let searchVC = SeachViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
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
        
        // 필터뷰 DropDown의 데이터에게 탭 제스쳐를 추가한다.
        peopleOptionStackView.subviews.forEach { view in
            let label = view as! UILabel
            print(label.text!)
            // 탭 제스쳐를 label에 추가 -> label을 탭했을 때 액션이 발생하도록.
            let labelTapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(tapPeopleOption(sender:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(labelTapGesture)
        }
        
        // timeOptionStackView의 서브뷰 안의 label에게 탭 제스쳐를 추가한다.
        timeOptionStackView.subviews.forEach { view in
            view.subviews.forEach { sub in
                let label = sub as! UILabel
                print(label.text!)
                // 탭 제스쳐를 label에 추가 -> label을 탭했을 때 액션이 발생하도록.
                let labelTapGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(tapTimeOption(sender:)))
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(labelTapGesture)
            }
        }
    }
    
    /* peopleFilterView에 탭 제스처 추가 */
    private func setFilterViewTap() {
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(showDropDown))
        peopleFilterView.isUserInteractionEnabled = true
        peopleFilterView.addGestureRecognizer(viewTapGesture)
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
    
    /* peopleFilterView 탭하면 실행되는 함수 -> DropDown */
    @objc private func showDropDown() {
        print("DEBUG: filter view tap")
        
        // 필터뷰 확장
        isDropDownPeople = !isDropDownPeople
        peopleDropDownView.isHidden = !isDropDownPeople
        peopleFilterContainerView.isHidden = !isDropDownPeople
        
        self.view.bringSubviewToFront(peopleFilterContainerView)    // 테두리 그림자 보이게 하려고 view를 앞으로 가져옴.
        self.view.bringSubviewToFront(peopleDropDownView)   // 테이블뷰에 가리지 않도록 dropdown view를 앞으로 가져옴.
        self.view.bringSubviewToFront(peopleFilterView) // peopleFilterView의 탭 제스쳐를 감지해야 하므로 view를 앞으로 가져옴.
        if isDropDownPeople {
            peopleFilterView.layer.cornerRadius = 0
            peopleFilterLabel.textColor = .mainColor
            peopleFilterToggleImageView.image =  UIImage(named: "ToggleDownMark")
        } else {
            peopleFilterView.layer.cornerRadius = 3     // 원래대로 돌려놓기
            peopleFilterToggleImageView.image =  UIImage(named: "ToggleMark")
        }
    }
    
    /* peopleFilterView의 Option으로 있는 label을 탭하면 실행되는 함수 */
    @objc private func tapPeopleOption(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // label 색 변경 - 진하게
        label.textColor = .init(hex: 0x636363)
        // peopleFilterView의 텍스트를 label로 변경함
        peopleFilterLabel.text = label.text
        
        for view in peopleOptionStackView.subviews {
            let label = view as! UILabel
            if label.text != peopleFilterLabel.text {
                label.textColor = .init(hex: 0xD8D8D8)
            }
        }
    }
    
    /* 시간 필터를 탭하면 mainColor로 색깔 바뀌도록 */
    @objc private func tapTimeOption(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // label 색 변경 - mainColor로
        if label.textColor != .mainColor {
            label.textColor = .mainColor
        } else {
            // 원래 색깔로 되돌려 놓는다
            label.textColor = .init(hex: 0xD8D8D8)
        }
    }
    
    @objc func tapCreatePartyButton() {
        let viewController = CreatePartyViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    /* 1분에 한번씩 테이블뷰 자동 리로드 -> 스크롤 하지 않아도 남은 시간이 바뀜 */
    private func changeOrderTimeByMinute() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (Timer) in
            self.partyTableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension DeliveryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let deliveryCellDataArray = deliveryCellDataArray {
            return deliveryCellDataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PartyTableViewCell", for: indexPath) as? PartyTableViewCell else { return UITableViewCell() }
        
        // cellDataArray에 값이 있으면 괄호 안의 코드를 실행
        if let cellDataArray = deliveryCellDataArray {
            // 현재 row의 셀 데이터 -> DeliveryListModelResult 형식
            let nowData = cellDataArray[indexPath.row]
            
            // TODO: - hashTags는 디자인 확정된 후에 추가
            // API를 통해 받아온 데이터들이 다 있으면, 데이터를 컴포넌트에 각각 할당해 준다
            if let currentMatching = nowData.currentMatching,
               let maxMatching = nowData.maxMatching,
               let orderTime = nowData.orderTime,
               let title = nowData.title {
                cell.peopleLabel.text = String(currentMatching)+"/"+String(maxMatching)
                cell.titleLabel.text = title
                
                // TODO: - 추후에 모델이나 뷰모델로 위치 옮기면 될 듯
                // 서버에서 받은 데이터의 형식대로 날짜 포맷팅
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                
                let nowDate = Date()
                let nowDateString = formatter.string(from: nowDate)
                print("DEBUG: 현재 시간", nowDateString)
                
                let orderDate = formatter.date(from: orderTime)
                if let orderDate = orderDate {
                    let orderDateString = formatter.string(from: orderDate)
                    print("DEBUG: 주문 예정 시간", orderDateString)
                    
                    // (주문 예정 시간 - 현재 시간) 의 값을 초 단위로 받아온다
                    let intervalSecs = Int(orderDate.timeIntervalSince(nowDate))
                    
                    // 각각 일, 시간, 분 단위로 변환
                    let dayTime = intervalSecs / 60 / 60 / 24
                    let hourTime = intervalSecs / 60 / 60 % 24
                    let minuteTime = intervalSecs / 60 % 60
//                    let secondTime = intervalSecs % 60
                    
                    // 각 값이 0이면 텍스트에서 제외한다
                    var dayString: String? = nil
                    var hourString: String? = nil
                    var minuteString: String? = nil
                    
                    if dayTime != 0 {
                        dayString = "\(dayTime)일 "
                    }
                    if hourTime != 0 {
                        hourString = "\(hourTime)시간 "
                    }
                    if minuteTime != 0 {
                        minuteString = "\(minuteTime)분 "
                    }
                    
                    cell.timeLabel.text = (dayString ?? "") + (hourString ?? "") + (minuteString ?? "") + "남았어요"
                }
            }
        }
        
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

extension UIView{
    
    /* view에 그라데이션 적용 -> vertical style */
    func setGradient(startColor: UIColor, endColor: UIColor){
        let gradient = CAGradientLayer()
        // startColor가 더 연한 색깔
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}

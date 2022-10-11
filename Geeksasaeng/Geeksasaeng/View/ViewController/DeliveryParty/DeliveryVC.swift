//
//  DeliveryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import UIKit

import Kingfisher
import SnapKit
import Then

/* Delegate Pattern을 구현하기 위한 프로토콜 */
protocol UpdateDeliveryDelegate {
    // 배달 목록을 새로고침 해준다.
   func updateDeliveryList()
}

class DeliveryViewController: UIViewController {
    
    // MARK: - Properties
    
    // 유저의 기숙사 정보 -> id랑 name 들어있음!
    var dormitoryInfo: DormitoryNameResult?
    // userImageUrl -> 채팅, 내 프로필 등에서 사용
    var userImageUrl: String?
    
    // 배달목록, 마켓, 헬퍼 중에 지금 선택된 카테고리가 무엇인지 저장
    var nowCategory = "배달파티"
    
    // 광고 배너 이미지 데이터 배열
    var adCellDataArray: [AdModelResult] = [] {
        didSet {
            print("광고!", adCellDataArray)
            // 새 값을 받으면 컬렉션뷰 리로드!
            adCollectionView.reloadData()
        }
    }
    // 광고 배너의 현재 페이지를 체크하는 변수 (자동 스크롤할 때 필요)
    var nowPage: Int = 0
    
    // 시간 필터 배열
    let timeDataArray = ["아침", "점심", "저녁", "야식"]
    
    // 필터뷰가 DropDown 됐는지 안 됐는지 확인하기 위한 변수
    var isDropDownPeople = false
    
    // 배달 목록의 마지막 페이지인지 여부 확인
    var isFinalPage = false
    
    // 현재 설정되어 있는 인원수 필터값이 뭔지 가져오기 위해
    var nowPeopleFilter: Int? = nil
    // 현재 설정되어 있는 시간 필터값
    var nowTimeFilter: String? = nil
    
    // 현재 설정되어 있는 인원수 필터 label
    var selectedPeopleLabel: UILabel? = nil
    // 현재 설정되어 있는 시간 필터 label
    var selectedTimeLabel: UILabel? = nil

    // 목록에서 현재 커서 위치
    var cursor = 0
    // 배달 목록 데이터가 저장되는 배열
    var deliveryCellDataArray: [DeliveryListModelResult] = []
    
    // MARK: - Subviews
    
    lazy var dormitoryLabel = UILabel().then {
        if let name = dormitoryInfo?.name {
            $0.text = "제" + name
        }
        $0.font = .customFont(.neoBold, size: 20)
        $0.textColor = .black
    }
    
    // TODO: - 학교 API 연동 후 학교 사진으로 변경
    lazy var schoolImageView = UIImageView(image: UIImage(named: "GachonLogo")).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 31 / 2
    }
    
    /* Navigation Bar Buttons으로 들어갈 스택뷰 생성 */
    lazy var stackView = UIStackView(arrangedSubviews: [schoolImageView, dormitoryLabel]).then {
        $0.spacing = 10
    }
    
    /* Navigation Bar Buttons */
    lazy var leftBarButtonItem = UIBarButtonItem(customView: stackView)
    
    lazy var rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SearchMark"), style: .plain, target: self, action: #selector(tapSearchButton)).then {
        $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13)
        $0.tintColor = .init(hex: 0x2F2F2F)
    }
    
    /* Category Labels */
    let deliveryPartyLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoBold, size: 16)
        $0.text = "배달파티"
    }
    let marketLabel = UILabel().then {
        $0.textColor = .init(hex: 0xCBCBCB)
        $0.font = .customFont(.neoMedium, size: 16)
        $0.text = "마켓"
    }
    let helperLabel: UILabel = UILabel().then {
        $0.textColor = .init(hex: 0xCBCBCB)
        $0.font = .customFont(.neoMedium, size: 16)
        $0.text = "헬퍼"
    }
    
    /* Category Bars */
    let deliveryPartyBar = UIView().then {
        $0.backgroundColor = .mainColor
    }
    let marketBar: UIView = UIView().then {
        $0.backgroundColor = .init(hex: 0xCBCBCB)
    }
    let helperBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xCBCBCB)
    }
    
    // Ad Collection View 셀 레이아웃 설정
    let adCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        
        // 광고 셀 크기 설정
        let width = UIScreen.main.bounds.width
        $0.itemSize = CGSize(width: width, height: 85)  // 높이를 확정해야 cornerRadius가 적용됨.

        // 광고 이미지 사이 간격 설정
        $0.minimumLineSpacing = 0
    }
    
    /* Ad Collection View */
    // 위에서 만든 레이아웃을 따르는 collection view 생성
    lazy var adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: adCollectionViewLayout).then {
        $0.backgroundColor = .white
        // indicator 숨김
        $0.showsHorizontalScrollIndicator = false
        // 직접 페이징 가능하도록
        $0.isPagingEnabled = true
        $0.tag = 1
    }
    
    /* Filter Icon */
    let filterImageView = UIImageView(image: UIImage(named: "FilterImage")).then {
        $0.tintColor = UIColor(hex: 0x2F2F2F)
    }
    
    /* People Filter */
    let peopleFilterLabel = UILabel().then {
        $0.text = "인원 선택"
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = UIColor(hex: 0xA8A8A8)
    }
    let peopleFilterToggleImageView = UIImageView(image: UIImage(named: "ToggleMark")).then {
        $0.tintColor = UIColor(hex: 0xA8A8A8)
    }
    lazy var peopleFilterView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 5
        
        [
            peopleFilterLabel,
            peopleFilterToggleImageView
        ].forEach { view.addSubview($0) }
        
        peopleFilterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(14)
        }
        peopleFilterToggleImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(6)
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(peopleFilterLabel.snp.right).offset(7)
        }
    }
   
    /* Expanded Filter Views */
    /* DropDown뷰의 데이터가 들어갈 stackView 생성 */
    lazy var peopleOptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.sizeToFit()
        $0.layoutIfNeeded()
        $0.distribution = .fillProportionally
        $0.alignment = .leading
        $0.spacing = 22
        
        // stackView label 내용 구성
        setVLabelList(["2명 이하", "4명 이하", "6명 이하", "8명 이하", "10명 이하"], $0)
    }
    
    /* peopleFilterView 눌렀을 때 확장되는 부분의 뷰 */
    lazy var peopleDropDownView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
        
        // 왼쪽, 오른쪽 하단의 코너에만 cornerRadius를 적용
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 5
        $0.isHidden = true
        
        $0.addSubview(peopleOptionStackView)
        peopleOptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(14)
        }
    }
    
    /* peopleFilterView가 dropdown 됐을 때 테두리 그림자를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var peopleFilterContainerView = UIView().then { view in
        view.backgroundColor = .none
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.isHidden = true
        
        // 테두리 그림자 생성
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.masksToBounds = false
        
        [peopleFilterView, peopleDropDownView].forEach { view.addSubview($0) }
    }
    
    // timeCollectionView 레이아웃 설정
    let timeCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        // 셀 크기 설정
        $0.itemSize = CGSize(width: 54, height: 34)
        // 셀 사이 좌우 간격 설정
        $0.minimumInteritemSpacing = 9
    }
    
    /* Time Filter -> 컬렉션뷰로 생성 */
    lazy var timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout).then {
        $0.backgroundColor = .white
        $0.tag = 2
        // indicator 숨김
        $0.showsHorizontalScrollIndicator = false
    }
    
    /* Table View */
    let partyTableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    lazy var createPartyButton = UIButton().then {
        let image = UIImage(named: "CreatePartyMark")
        $0.setImage(image, for: .normal)
        
        // imageEdgeInsets 값을 줘서 버튼과 안의 이미지 사이 간격을 조정
        let imageInset: CGFloat = 14
        $0.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        
        $0.layer.cornerRadius = 31
        $0.backgroundColor = .mainColor
        $0.addTarget(self, action: #selector(tapCreatePartyButton), for: .touchUpInside)
    }
    
    /* 테이블뷰 셀 하단에 블러뷰 */
    let blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)).then {
        // 그라데이션 적용
        $0.setGradient(startColor: .init(hex: 0xFFFFFF, alpha: 0.0), endColor: .init(hex: 0xFFFFFF, alpha: 1.0))
        $0.isUserInteractionEnabled = false // 블러뷰에 가려진 테이블뷰 셀이 선택 가능하도록 하기 위해
    }
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        
        setTableView()
        // collection view 설정
        [ adCollectionView, timeCollectionView ].forEach { setCollectionView($0) }
        
        setTapGestures()
        setAdCollectionViewTimer()
        
        makeButtonShadow(createPartyButton)
        if let jwt = LoginModel.jwt {
            print("DEBUG: jwt \(jwt)")
        }
        
        /* 광고 목록 데이터 로딩 */
        getAdList()
        
        /* 배달 목록 데이터 로딩 */
        getDeliveryList(DeliveryListInput())
        /* 1분마다 시간 재설정 */
        changeOrderTimeByMinute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이 뷰가 보여지면 네비게이션바를 나타나게 해야한다
        self.navigationController?.isNavigationBarHidden = false
        // 하단 탭바가 나타나게 해야한다
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
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
            timeCollectionView,
            peopleDropDownView, peopleFilterContainerView,
            partyTableView,
            blurView,   // 적은 순서에 따라 view가 추가됨 = 순서에 따라 앞뒤의 뷰가 달라짐
            createPartyButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        
        /* Category Tap */
        deliveryPartyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(deliveryPartyBar.snp.centerX)
        }
        schoolImageView.snp.makeConstraints { make in
            make.width.height.equalTo(31)
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
            make.top.equalTo(deliveryPartyLabel.snp.bottom).offset(13)
            make.left.equalToSuperview().inset(18)
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 36) / 3)
        }
        marketBar.snp.makeConstraints { make in
            make.top.equalTo(marketLabel.snp.bottom).offset(13)
            make.left.equalTo(deliveryPartyBar.snp.right)
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 36) / 3)
        }
        helperBar.snp.makeConstraints { make in
            make.top.equalTo(helperLabel.snp.bottom).offset(13)
            make.left.equalTo(marketBar.snp.right)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(3)
            make.width.equalTo((UIScreen.main.bounds.width - 36) / 3)
        }
        
        /* Ad */
        adCollectionView.snp.makeConstraints { make in
            make.top.equalTo(deliveryPartyBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(86)
        }
        
        /* Filter */
        // 인원수 필터
        filterImageView.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(15)
            make.centerY.equalTo(peopleFilterView.snp.centerY)
            make.left.equalTo(adCollectionView.snp.left).offset(28)
        }
        peopleFilterView.snp.makeConstraints { make in
            make.top.equalTo(adCollectionView.snp.bottom).offset(16)
            make.left.equalTo(filterImageView.snp.right).offset(16)
            make.width.equalTo(101)
            make.height.equalTo(34)
        }
        peopleDropDownView.snp.makeConstraints { make in
            make.width.equalTo(peopleFilterView)
            make.height.equalTo(219)
            make.top.equalTo(peopleFilterView.snp.bottom)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        peopleFilterContainerView.snp.makeConstraints { make in
            make.width.equalTo(peopleFilterView)
            make.height.equalTo(253)
            make.top.equalTo(adCollectionView.snp.bottom).offset(16)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        // 시간 필터
        timeCollectionView.snp.makeConstraints { make in
            make.left.equalTo(peopleFilterView.snp.right).offset(9)
            make.right.equalToSuperview().inset(9)
            make.centerY.equalTo(peopleFilterView)
            make.height.equalTo(34)
        }
        
        /* TableView */
        partyTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
        partyTableView.register(PartyTableViewCell.self, forCellReuseIdentifier: PartyTableViewCell.identifier)
        
        partyTableView.rowHeight = 125
        partyTableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        /* 새로고침 기능 */
        // refresh 기능을 위해 tableView의 UIRefreshControl 객체를 초기화
        partyTableView.refreshControl = UIRefreshControl()
        // refresh로 위에 생기는 부분 배경색 설정
        partyTableView.refreshControl?.backgroundColor = .white
        // refresh 모양 색깔 설정
        partyTableView.refreshControl?.tintColor = .mainColor
        // refresh 하면 실행될 함수 연결
        partyTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    /* collection view 등록 */
    private func setCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        
        if collectionView.tag == 1 {
            collectionView.register(AdCollectionViewCell.self,
                                    forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        } else {
            collectionView.register(TimeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
        }
    }
    
    /* Vertical Label list의 label을 구성한다 */
    private func setVLabelList(_ passedArray: [String], _ stackView: UIStackView) {
          for i in 0..<passedArray.count {
              /* Filter Label */
              let filterLabel = UILabel()
              let filterText = passedArray[i]
              filterLabel.textColor = .init(hex: 0xA8A8A8)
              filterLabel.font = .customFont(.neoMedium, size: 14)
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
    
    /* 광고 목록 데이터 API로 불러오기 */
    private func getAdList() {
        AdViewModel.requestAd() { result in
            print("DEBUG: 광고 불러오기 성공")
            guard let result = result else { return }
            self.adCellDataArray = result
        }
    }
    
    /* 배달 목록 정보 API로 불러오기 */
    private func getDeliveryList(_ input: DeliveryListInput) {
        // 푸터뷰(= 데이터 받아올 때 테이블뷰 맨 아래 새로고침 표시 뜨는 거) 생성
        self.partyTableView.tableFooterView = createSpinnerFooter()
        
        // 기숙사 id가 nil일 경우, 배달파티 목록을 불러올 수 없기 때문에 로그 띄우기
        guard let dormitoryId = dormitoryInfo?.id else {
            print("DEBUG: 기숙사id가 nil값입니다.")
            return
        }
        print("DEBUG: 제\(dormitoryId)기숙사의 배달파티 리스트 데이터입니다")
        
        /* 필터에 따른 배달목록 불러오기 API 요청 */
        DeliveryListViewModel.requestGetDeliveryList(cursor: cursor, dormitoryId: dormitoryId, input: input) { [weak self] result in
            
            guard let data = result.deliveryPartiesVoList,
                  let isFinalPage = result.finalPage else { return }
            print("DEBUG: 마지막 페이지인가?", isFinalPage)
            
            // 마지막 페이지인지 아닌지 전달
            self!.isFinalPage = isFinalPage
            // 셀에 데이터 추가
            self?.addCellData(result: data)
        }
    }
    
    /* peopleFilter를 사용하여 데이터 가져오기 */
    private func getPeopleFilterList(text: String?) {
        removeCellData()
        
        enum peopleOption: String {
            case two = "2명 이하"
            case four = "4명 이하"
            case six = "6명 이하"
            case eight = "8명 이하"
            case ten = "10명 이하"
        }
        
        print("TEST: ", text ?? "")
        var num: Int? = nil
        switch text {
        case peopleOption.two.rawValue:
            num = 2
        case peopleOption.four.rawValue:
            num = 4
        case peopleOption.six.rawValue:
            num = 6
        case peopleOption.eight.rawValue:
            num = 8
        case peopleOption.ten.rawValue:
            num = 10
        default:
            num = nil
        }
        print("TEST: ", num ?? -1)

        if let num = num {
            nowPeopleFilter = num
            // 값에 따른 API 호출
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getDeliveryList(input)
        }
    }

    /* timeFilter를 사용하여 데이터 가져오기 */
    private func getTimeFilterList(text: String?) {
        removeCellData()

        // label에 따라 다른 값을 넣어 시간으로 필터링된 배달 목록을 불러온다
        enum TimeOption: String {
            case breakfast = "BREAKFAST"
            case lunch = "LUNCH"
            case dinner = "DINNER"
            case midnightSnacks = "MIDNIGHT_SNACKS"
        }
        
        var orderTimeCategory: String? = nil
        switch text {
        case "아침" :
            orderTimeCategory = TimeOption.breakfast.rawValue
        case "점심" :
            orderTimeCategory = TimeOption.lunch.rawValue
        case "저녁" :
            orderTimeCategory = TimeOption.dinner.rawValue
        case "야식" :
            orderTimeCategory = TimeOption.midnightSnacks.rawValue
        default :
            orderTimeCategory = ""
        }
        
        if let orderTimeCategory = orderTimeCategory {
            // 현재 시간 필터 설정
            nowTimeFilter = orderTimeCategory
            
            // 값에 따른 API 호출
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getDeliveryList(input)
        }
    }
    
    /* 서버로부터 받아온 response를 처리하는 함수. res가 성공이면 셀에 데이터를 추가해준다 */
    private func addCellData(result: [DeliveryListModelResult]) {
        // 데이터 로딩 표시 제거
        DispatchQueue.main.async {
            self.partyTableView.tableFooterView = nil
        }
        
        result.forEach {
            // 데이터를 배열에 추가
            self.deliveryCellDataArray.append($0)
            print("DEBUG: 받아온 배달 데이터", $0)
            print("DEBUG: 배달 데이터 배열 현황", deliveryCellDataArray)
        }
        
        // 테이블뷰 리로드
        DispatchQueue.main.async {
            self.partyTableView.reloadData()
        }
    }
    
    /* 배달파티 목록, 커서 초기화 함수 */
    private func removeCellData() {
        deliveryCellDataArray.removeAll()
        cursor = 0
    }
    
    /* 무한 스크롤로 마지막 데이터까지 가면 나오는(= FooterView) 데이터 로딩 표시 생성 */
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        spinner.color = .mainColor
        
        return footerView
    }
    
    /* 탭 제스쳐 추가하는 함수 */
    private func setTapGestures() {
        /* label에 탭 제스쳐 추가 */
        for label in [deliveryPartyLabel, marketLabel, helperLabel] {
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
        
        /* peopleFilterView에 탭 제스처 추가 */
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapPeopleFilterView))
        peopleFilterView.isUserInteractionEnabled = true
        peopleFilterView.addGestureRecognizer(viewTapGesture)
    }
    
    /* 카테고리 탭을 한 번 더 누를 때, 목록의 맨 위로 스크롤 이동 */
    private func scrollToListTop() {
        partyTableView.beginUpdates()
        if #available(iOS 11.0, *) {
            partyTableView.setContentOffset(CGPoint(x: 0, y: -partyTableView.adjustedContentInset.top), animated: true)
        } else {
            partyTableView.setContentOffset(CGPoint(x: 0, y: -partyTableView.contentInset.top), animated: true)
        }
        partyTableView.endUpdates()
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
        if adCellDataArray.count > 1 {
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
    }
    
    /* 1분에 한번씩 테이블뷰 자동 리로드 -> 스크롤 하지 않아도 남은 시간이 바뀜 */
    private func changeOrderTimeByMinute() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (Timer) in
            self.partyTableView.reloadData()
        }
    }
    
    /* 테이블뷰 셀의 마지막 데이터까지 스크롤 했을 때 이를 감지해주는 함수 */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 하는 게 배달 파티 목록일 때, 데이터가 존재할 때에만 실행
        if scrollView == partyTableView, deliveryCellDataArray.count != 0 {
            let position = scrollView.contentOffset.y
            print("pos", position)
            
            // 현재 화면에 테이블뷰 셀이 몇개까지 들어가는지
            let maxCellNum = partyTableView.bounds.size.height / partyTableView.rowHeight
            // '몇 번째 셀'이 위로 사라질 때 다음 데이터를 불러올지
            let boundCellNum = 10 - maxCellNum
            
            // 마지막 데이터에 도달했을 때 다음 데이터 10개를 불러온다
            if position > ((partyTableView.rowHeight) * (boundCellNum + (10 * CGFloat(cursor)))) {
                // 마지막 페이지가 아니라면, 다음 커서의 배달 목록을 불러온다
                if !isFinalPage {
                    cursor += 1
                    print("DEBUG: cursor", cursor)
                    // 값에 따른 API 호출
                    let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
                    getDeliveryList(input)
                }
            }
        }
    }
    
    private func showReadyView() {
        view.addSubview(readyView)
        readyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(peopleFilterView.snp.bottom).offset(8)
        }
    }
    
    private func removeReadyView() {
        readyView.removeFromSuperview()
    }
    
    // MARK: - @objc Functions
    
    /* 검색 버튼 눌렀을 때 검색 화면으로 전환 */
    @objc
    private func tapSearchButton() {
        let searchVC = SearchViewController()
        searchVC.dormitoryInfo = self.dormitoryInfo
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    /* 카테고리 탭의 label을 탭하면 실행되는 함수 */
    @objc
    private func tapCategoryLabel(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel

        if let category = label.text {
            if category == nowCategory {
                // 눌렀던 카테고리를 또 누르면 목록의 맨 위로 스크롤 이동
                scrollToListTop()
            } else {
                // 카테고리 값 저장
                nowCategory = category
                
                switch category {
                case "배달파티":
                    print("DEBUG: 배달파티")
                    // 바 색깔 파란색으로 활성화
                    deliveryPartyBar.backgroundColor = .mainColor
                    marketBar.backgroundColor = .init(hex: 0xCBCBCB)
                    helperBar.backgroundColor = .init(hex: 0xCBCBCB)
                    // 텍스트 색깔 활성화
                    deliveryPartyLabel.textColor = .init(hex: 0x2F2F2F)
                    deliveryPartyLabel.font = .customFont(.neoBold, size: 16)
                    marketLabel.textColor = .init(hex: 0xCBCBCB)
                    marketLabel.font = .customFont(.neoMedium, size: 16)
                    helperLabel.textColor = .init(hex: 0xCBCBCB)
                    helperLabel.font = .customFont(.neoMedium, size: 16)
                    // 배달파티 리스트 보여주기
                    removeReadyView()
                    break
                case "마켓":
                    print("DEBUG: 마켓")
                    // 바 색깔 파란색으로 활성화
                    deliveryPartyBar.backgroundColor = .init(hex: 0xCBCBCB)
                    marketBar.backgroundColor = .mainColor
                    helperBar.backgroundColor = .init(hex: 0xCBCBCB)
                    // 텍스트 색깔 활성화
                    deliveryPartyLabel.textColor = .init(hex: 0xCBCBCB)
                    deliveryPartyLabel.font = .customFont(.neoMedium, size: 16)
                    marketLabel.textColor = .init(hex: 0x2F2F2F)
                    marketLabel.font = .customFont(.neoBold, size: 16)
                    helperLabel.textColor = .init(hex: 0xCBCBCB)
                    helperLabel.font = .customFont(.neoMedium, size: 16)
                    showReadyView()
                    break
                case "헬퍼":
                    print("DEBUG: 헬퍼")
                    // 바 색깔 파란색으로 활성화
                    deliveryPartyBar.backgroundColor = .init(hex: 0xCBCBCB)
                    marketBar.backgroundColor = .init(hex: 0xCBCBCB)
                    helperBar.backgroundColor = .mainColor
                    // 텍스트 색깔 활성화
                    deliveryPartyLabel.textColor = .init(hex: 0xCBCBCB)
                    deliveryPartyLabel.font = .customFont(.neoMedium, size: 16)
                    marketLabel.textColor = .init(hex: 0xCBCBCB)
                    marketLabel.font = .customFont(.neoMedium, size: 16)
                    helperLabel.textColor = .init(hex: 0x2F2F2F)
                    helperLabel.font = .customFont(.neoBold, size: 16)
                    showReadyView()
                    break
                default:
                    return
                }
            }
        }
    }
    
    /* peopleFilterView 탭하면 DropDown 뷰를 보여준다 */
    @objc
    private func tapPeopleFilterView() {
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
            peopleFilterView.layer.cornerRadius = 5     // 원래대로 돌려놓기
            peopleFilterToggleImageView.image =  UIImage(named: "ToggleMark")
        }
    }
    
    /* peopleFilterView의 Option으로 있는 label을 탭하면 실행되는 함수 */
    @objc
    private func tapPeopleOption(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // 눌렀던 거 또 눌렀을 때
        if label == selectedPeopleLabel {
            // 색깔 원상복귀
            label.textColor = .init(hex: 0xA8A8A8)
            // peopleFilterView의 텍스트도 원상복귀
            peopleFilterLabel.text = "인원 선택"
            peopleFilterLabel.textColor = .init(hex: 0xA8A8A8)
            
            // 필터 초기화
            selectedPeopleLabel = nil
            nowPeopleFilter = nil
            removeCellData()
            
            // 값에 따른 API 호출
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getDeliveryList(input)
        } else {
            selectedPeopleLabel = label
            // label 색 변경 - 진하게
            label.textColor = .init(hex: 0x636363)
            // peopleFilterView의 텍스트를 label로 변경함
            peopleFilterLabel.text = label.text
            // 인원수 필터링 호출
            self.getPeopleFilterList(text: label.text)
        }
        
        for view in peopleOptionStackView.subviews {
            let label = view as! UILabel
            if label.text != peopleFilterLabel.text {
                label.textColor = .init(hex: 0xA8A8A8)
            }
        }
        tapPeopleFilterView()
        
        // 필터가 변경되면 스크롤 맨 위로
        partyTableView.reloadData()
    }
    
    /* 시간 필터를 탭하면 mainColor로 색깔 바뀌도록 */
    @objc
    private func tapTimeOption(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // label 색 변경
        // 선택돼있던 label이 아니었다면, mainColor로 바꿔준다
        if label.textColor != .mainColor {
            // 원래 선택돼있던 label 색깔은 해제한다. -> 시간 필터 1개만 선택 가능
            if selectedTimeLabel != nil {
                // 색깔 원상복귀
                selectedTimeLabel?.textColor = .init(hex: 0xD8D8D8)
            }
            label.textColor = .mainColor
            selectedTimeLabel = label
            
            // 시간 필터링 호출
            getTimeFilterList(text: label.text)
        } else {
            // 선택돼있던 label이 재선택된 거면, 원래 색깔로 되돌려 놓는다 - 현재 선택된 시간 필터 0개
            label.textColor = .init(hex: 0xD8D8D8)
            
            // 시간 필터 초기화
            nowTimeFilter = nil
            removeCellData()
            
            // 값에 따른 API 호출
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getDeliveryList(input)
        }
        
        // 필터가 변경되면 스크롤 맨 위로
        partyTableView.reloadData()
    }
    
    /* CreatePartyButton을 누르면 파티 생성 화면으로 전환 */
    @objc
    private func tapCreatePartyButton() {
        let createPartyVC = CreatePartyViewController()
        createPartyVC.dormitoryInfo = dormitoryInfo
        createPartyVC.delegate = self
        self.navigationController?.pushViewController(createPartyVC, animated: true)
    }
    
    /* 새로고침 기능 */
    @objc
    private func pullToRefresh() {
        // 데이터가 적재된 상황에서 맨 위로 올려 새로고침을 했다면, 배열을 초기화시켜서 처음 10개만 다시 불러온다
        print("DEBUG: 적재된 데이터 \(deliveryCellDataArray.count)개 삭제")
        removeCellData()
        
        // 값에 따른 API 호출
        let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
        getDeliveryList(input)
        
        // 테이블뷰 새로고침
        partyTableView.reloadData()
        // 당기는 게 끝나면 refresh도 끝나도록
        partyTableView.refreshControl?.endRefreshing()
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension DeliveryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryCellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PartyTableViewCell.identifier, for: indexPath) as? PartyTableViewCell else { return UITableViewCell() }
        
        // 현재 row의 셀 데이터 -> DeliveryListModelResult 형식
        let nowData = deliveryCellDataArray[indexPath.row]
        print(nowData)
        
        // API를 통해 받아온 데이터들이 다 있으면, 데이터를 컴포넌트에 각각 할당해 준다
        if let currentMatching = nowData.currentMatching,
           let maxMatching = nowData.maxMatching,
           let orderTime = nowData.orderTime,
           let title = nowData.title,
           let hasHashTag = nowData.hasHashTag,
           let foodCategory = nowData.foodCategory {
            cell.peopleLabel.text = String(currentMatching) + "/" + String(maxMatching)
            cell.titleLabel.text = title
            cell.hashtagLabel.textColor = (hasHashTag) ? UIColor(hex: 0x636363) : UIColor(hex: 0xEFEFEF)
            cell.categoryLabel.text = foodCategory
            
            // TODO: - 추후에 모델이나 뷰모델로 위치 옮기면 될 듯
            // 서버에서 받은 데이터의 형식대로 날짜 포맷팅
            let formatter = FormatCreater.sharedLongFormat
            let nowDate = Date()
            let orderDate = formatter.date(from: orderTime)
            
            if let orderDate = orderDate {
                // (주문 예정 시간 - 현재 시간) 의 값을 초 단위로 받아온다
                let intervalSecs = Int(orderDate.timeIntervalSince(nowDate))
                
                // 각각 일, 시간, 분 단위로 변환
                let dayTime = intervalSecs / 60 / 60 / 24
                let hourTime = intervalSecs / 60 / 60 % 24
                let minuteTime = intervalSecs / 60 % 60
                
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let partyId = deliveryCellDataArray[indexPath.row].id,
              let dormitoryInfo = dormitoryInfo else { return }
        let partyVC = PartyViewController(partyId: partyId, dormitoryInfo: dormitoryInfo)
        
        // delegate로 자기 자신(DeliveryVC)를 넘겨줌
        partyVC.delegate = self
        self.navigationController?.pushViewController(partyVC, animated: true)
        
        // 클릭된 셀 배경색 제거 & separator 다시 나타나게 하기 위해서
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DeliveryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* cell을 몇 개 넣을지 설정 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 광고
        if collectionView.tag == 1 {
            return adCellDataArray.count
        } else {
            // 시간 필터
            return timeDataArray.count
        }
    }
    
    /* cell의 내용 설정 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell에 어떤 이미지의 광고를 넣을지 설정
        if collectionView.tag == 1 {
            // AdCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
            
            // cell의 이미지(광고 이미지) 설정
            // url에 정확한 이미지 url 주소를 넣는다
            if let imgString = adCellDataArray[indexPath.item].imgUrl {
                let url = URL(string: imgString)
                cell.cellImageView.kf.setImage(with: url)
            }
            
            return cell
        } else {
            // 시간 필터 셀 구성
            // TimeCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.identifier, for: indexPath) as? TimeCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 설정
            cell.timeLabel.text = timeDataArray[indexPath.item]
            
            // 탭 제스쳐를 label에 추가 -> label을 탭했을 때 액션이 발생하도록
            let labelTapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(tapTimeOption(sender:)))
            cell.timeLabel.isUserInteractionEnabled = true
            cell.timeLabel.addGestureRecognizer(labelTapGesture)
            return cell
        }
    }
    
    /* 수동 스크롤이 끝났을 때 실행되는 함수 */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == adCollectionView {
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

// MARK: - UpdateDeliveryDelegate

extension DeliveryViewController: UpdateDeliveryDelegate {
    /* PartyVC에서 배달 파티가 생성/수정/삭제되면,
     DeliveryVC의 배달 목록을 새로고침 시키는 함수 */
    func updateDeliveryList() {
        print("DEBUG: 파티가 업데이트됐으니 테이블뷰 리로드 할게요")
        pullToRefresh()
    }
}

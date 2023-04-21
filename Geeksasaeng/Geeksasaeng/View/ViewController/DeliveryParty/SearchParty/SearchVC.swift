//
//  SearchVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit

import RealmSwift
import SnapKit
import Then

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var recentSearchDataArray: Results<SearchRecord>?
    var timeDataArray = ["아침", "점심", "저녁", "야식"]
    
    // 필터뷰가 DropDown 됐는지 안 됐는지 확인하기 위한 변수
    var isDropDownPeople = false
    
    // 현재 설정되어 있는 인원수 필터값이 뭔지 가져오기 위해
    var nowPeopleFilter: Int? = nil
    // 현재 설정되어 있는 시간 필터값
    var nowTimeFilter: String? = nil
    
    // 현재 설정되어 있는 시간 필터 label
    var selectedTimeLabel: UILabel? = nil
    // 현재 설정되어 있는 인원수 필터 label
    var selectedPeopleLabel: UILabel? = nil
    
    // 기숙사 정보 -> id랑 name 다 있음
    var dormitoryInfo: DormitoryNameResult?
    // 목록에서 현재 커서 위치
    var cursor = 0
    
    // 배달 목록의 마지막 페이지인지 여부 확인
    var isFinalPage = false
    
    // 배달 목록 데이터가 저장되는 배열
    var deliveryCellDataArray: [DeliveryListModelResult] = []
    // 현재 검색하고 있는 키워드를 저장 (구별을 위해)
    var nowSearchKeyword: String = ""
    
    // 로컬에 데이터를 저장하기 위해 Realm 객체 생성
    let localRealm = try! Realm()
    
    // MARK: - Subviews
    
    /* 검색창 textField */
    lazy var searchTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEFEFEF),
                NSAttributedString.Key.font: UIFont.customFont(.neoMedium, size: 20)
            ]
        )
        $0.makeBottomLine()
        $0.returnKeyType = .done
        $0.delegate = self
    }
    
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(named: "SearchMark"), for: .normal)
        $0.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        $0.contentMode = .scaleAspectFit
    }
    
    let recentSearchLabel = UILabel().then {
        $0.text = "최근 검색어"
    }
    
    lazy var dormitoryWeeklyTopLabel = UILabel().then {
        if let name = dormitoryInfo?.name {
            $0.text = "\("제" + name) Weekly TOP 10"
        }
    }
    
    var noSearchRecordsLabel = UILabel().then {
        $0.text = "검색어 기록이 없어요"
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = UIColor(hex: 0x5B5B5B)
    }
    
    // 최근 검색어 기록 Collection View의 레이아웃 설정
    let recentSearchCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        // 셀 사이 좌우 간격 설정
        $0.minimumInteritemSpacing = 20
    }
    
    /* 최근 검색어 기록 Collection View */
    lazy var recentSearchCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: recentSearchCollectionViewLayout).then {
        $0.backgroundColor = .white
        $0.tag = 1
        // indicator 숨김
        $0.showsHorizontalScrollIndicator = false
    }
    
    /* 배경에 있는 로고 이미지 */
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "SearchBackLogo")
    }
    
    /* 여기서부터 있는 서브뷰들은 다 '검색 결과 화면'에 쓰이는 서브뷰 */
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
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
        $0.layer.cornerRadius = 5
        $0.isHidden = true
        
        $0.addSubview(peopleOptionStackView)
        peopleOptionStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
    }
    
    /* peopleFilterView가 dropdown 됐을 때 테두리 그림자를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var peopleFilterContainerView = UIView().then {
        $0.backgroundColor = .none
        $0.layer.borderWidth = 5
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.isHidden = true
        
        // 테두리 그림자 생성
        $0.layer.shadowRadius = 5
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.masksToBounds = false
        
        [peopleFilterView, peopleDropDownView].forEach { view.addSubview($0) }
    }
    
    // timeCollectionView 레이아웃 설정
    let timeCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        // 셀 사이 좌우 간격 설정
        $0.minimumInteritemSpacing = 9
    }
    
    /* Time Filter -> 컬렉션뷰로 */
    lazy var timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout).then {
        $0.backgroundColor = .white
        $0.tag = 2
        // indicator 숨김
        $0.showsHorizontalScrollIndicator = false
    }
    
    /* Table View */
    lazy var partyTableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    /* 테이블뷰 셀 하단에 블러뷰 */
    lazy var blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)).then {
        // 그라데이션 적용
        $0.setGradient(startColor: .init(hex: 0xFFFFFF, alpha: 0.0), endColor: .init(hex: 0xFFFFFF, alpha: 1.0))
        $0.isUserInteractionEnabled = false // 블러뷰에 가려진 테이블뷰 셀이 선택 가능하도록 하기 위해
    }
    
    /* 검색 결과 없을 때 띄울 뷰 */
    lazy var noSearchResultView = UIView().then { view in
        let noResultLabel = UILabel().then {
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.text = "요청하신 검색 결과가 없습니다."
            $0.font = .customFont(.neoRegular, size: 14)
        }
        let resultImageView = UIImageView(image: UIImage(named: "NoSearchResult"))
        let guideLabel = UILabel().then {
            $0.text = "보다 일반적인 단어로 입력해보세요.\n검색어의 철자 혹은 띄어쓰기를 다시 확인해보세요."
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
            $0.numberOfLines = 0
        }
        let attrString = NSMutableAttributedString(string: guideLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 7
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        guideLabel.attributedText = attrString
        let flagImageView = UIImageView(image: UIImage(named: "Flag"))
        let questionLabel = UILabel().then {
            $0.text = "다른 태그로 검색해보셨나요?"
            $0.textColor = .init(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 12)
        }
        [
            resultImageView,
            noResultLabel,
            guideLabel,
            flagImageView,
            questionLabel
        ].forEach { view.addSubview($0) }
        
        resultImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).inset(self.view.bounds.height / 5.3)
        }
        noResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultImageView.snp.bottom).offset(screenHeight / 23.52)
        }
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noResultLabel.snp.bottom).offset(screenHeight / 33.33)
        }
        flagImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel.snp.bottom).offset(screenHeight / 20)
        }
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(flagImageView.snp.bottom).offset(screenHeight / 57.14)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // setAttributes
        [recentSearchLabel, dormitoryWeeklyTopLabel].forEach {
            setMainTextAttributes($0)
        }
        
        addSubViews()
        setLayouts()
        
        // collection view 설정
        [
            recentSearchCollectionView,
            timeCollectionView
        ].forEach { setCollectionView($0) }
        
        setTableView()
        
        // 검색 결과 화면 숨기기 - 초기화
        showSearchMainView()
        setTapGestures()
        
        // 최근 검색어 기록 불러오기
        loadSearchRecords()
        
        // Realm 파일 위치
        print("DEBUG: 최근 검색어 경로", Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Back 버튼 숨기기 & 상단에 위치한 텍스트 필드에 탭이 가능하게 하기 위해
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // 하단 탭바 숨기기
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    
    /* 공통 속성 설정 */
    private func setMainTextAttributes(_ label: UILabel) {
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 18)
    }
    
    private func addSubViews() {
        [
            noSearchRecordsLabel,
            searchTextField,
            searchButton,
            recentSearchLabel, dormitoryWeeklyTopLabel,
            recentSearchCollectionView,
            logoImageView,
            // 이 아래는 검색 결과 화면에 쓰이는 서브뷰들
            filterImageView, peopleFilterView,
            timeCollectionView,
            peopleDropDownView, peopleFilterContainerView,
            partyTableView,
            blurView,
            noSearchResultView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalToSuperview().inset(30)
            make.right.equalTo(searchButton.snp.left).offset(-10)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField).offset(-(screenHeight / 266.66))
            make.right.equalToSuperview().inset(screenWidth / 10.9)
            make.width.height.equalTo(screenWidth / 12)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 15.65)
            make.top.equalTo(searchTextField.snp.bottom).offset(screenHeight / 17.77)
        }
        recentSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(screenHeight / 72.72)
            make.left.right.equalToSuperview().inset(screenWidth / 12.85)
            make.height.equalTo(screenHeight / 28.57)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(screenHeight / 6.25)
            make.centerX.equalToSuperview()
            make.width.equalTo(screenWidth / 3.95)
            make.height.equalTo(screenHeight / 8.51)
        }
        
        /* 검색 결과 화면 서브뷰들 */
        /* Filter */
        filterImageView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(23)
            make.height.equalTo(15)
        }
        peopleFilterView.snp.makeConstraints { make in
            make.centerY.equalTo(filterImageView)
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
            make.top.equalTo(peopleFilterView)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
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
        
        /* blur view */
        blurView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 5.71)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        /* 검색 결과가 없을 때 */
        noSearchResultView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(peopleFilterView.snp.bottom).offset(screenHeight / 100)
        }
    }
    
    /* collection view 등록 */
    private func setCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        
        if collectionView.tag == 1 {
            collectionView.register(RecentSearchCollectionViewCell.self,
                                    forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        } else {
            collectionView.register(TimeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
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
    
    /* Vertical Label list의 label을 구성한다 */
    private func setVLabelList(_ passedArray: [String], _ stackView: UIStackView) {
        for i in 0..<passedArray.count {
            /* Filter Label */
            let filterLabel = UILabel()
            let filterText = passedArray[i]
            filterLabel.textColor = .init(hex: 0xD8D8D8)
            filterLabel.font = .customFont(.neoMedium, size: 14)
            filterLabel.text = filterText
            
            /* Stack View */
            stackView.addArrangedSubview(filterLabel)
        }
    }
    
    /* 로컬에서 최근 검색어 기록 불러오기 */
    private func loadSearchRecords() {
        self.recentSearchDataArray = localRealm.objects(SearchRecord.self).sorted(byKeyPath: "createdAt", ascending: false)
        recentSearchCollectionView.reloadData()
        print("[TEST] 최근 검색어 몇개?", self.recentSearchDataArray?.count)
        
        // 최근 검색어 갯수 점검
        checkSearchRecordsNum()
    }
    
    /* 배달 파티 검색 */
    private func getSearchedDeliveryList(_ input: DeliveryListInput) {
        guard let keyword = searchTextField.text,
              let dormitoryInfo = dormitoryInfo,
              let dormitoryId = dormitoryInfo.id else { return }
        print("DEBUG:", keyword, dormitoryInfo)
        if keyword.isEmpty { return }
        
        print("DEBUG: 검색어 내용 \(keyword) 기숙사 정보 \(dormitoryInfo)")
        
        // 푸터뷰(= 데이터 받아올 때 테이블뷰 맨 아래 새로고침 표시 뜨는 거) 생성
        self.partyTableView.tableFooterView = createSpinnerFooter()
        
        // 1. 필터링 없는 전체 배달 목록 조회
        SearchViewModel.requestDeliveryListByKeyword(cursor: cursor, dormitoryId: dormitoryId, keyword: keyword, input: input) { [weak self] result in
            guard let data = result.deliveryPartiesVoList,
                  let isFinalPage = result.finalPage else { return }
            
            print("DEBUG: 마지막 페이지인가?", isFinalPage)
            // 마지막 페이지인지 아닌지 전달
            self!.isFinalPage = isFinalPage
            // 셀에 데이터 추가
            self?.addCellData(result: data)
        }
    }
    
    /* 검색 메인 화면을 숨겨서 검색 결과 화면을 보여준다! */
    private func showSearchResultView(isEmpty: Bool) {
        if isEmpty { // 검색결과가 없을 때
            noSearchResultView.isHidden = false
            partyTableView.isHidden = true
            blurView.isHidden = true
        } else {
            noSearchResultView.isHidden = true
            partyTableView.isHidden = false
            blurView.isHidden = false
        }
        
        [
            noSearchRecordsLabel,
            recentSearchLabel,
            dormitoryWeeklyTopLabel,
            recentSearchCollectionView,
            logoImageView
        ].forEach { $0.isHidden = true }
        
        [
            filterImageView,
            peopleFilterView,
            peopleFilterLabel,
            peopleFilterToggleImageView,
            timeCollectionView,
            blurView
        ].forEach { $0.isHidden = false }
    }
    
    /* 검색 결과 화면을 숨겨서 검색 메인 화면을 보여준다! */
    private func showSearchMainView() {
        [
            noSearchRecordsLabel,
            recentSearchLabel,
            dormitoryWeeklyTopLabel,
            recentSearchCollectionView,
            logoImageView
        ].forEach { $0.isHidden = false }
        
        [
            filterImageView,
            peopleFilterView,
            peopleFilterLabel,
            peopleFilterToggleImageView,
            timeCollectionView,
            partyTableView,
            blurView,
            noSearchResultView
        ].forEach { $0.isHidden = true }
        
        // 검색 메인 화면 보여줄 때마다 최근 검색어 기록 불러오기 (업데이트)
        loadSearchRecords()
    }
    
    // 최근 검색어 기록의 개수에 따라 알맞은 동작 실행
    private func checkSearchRecordsNum() {
        guard let searchRecords = recentSearchDataArray else { return }
        // 0개이면 컬렉션뷰 숨기고 안내 text 띄우기
        if searchRecords.isEmpty {
            recentSearchCollectionView.isHidden = true
            noSearchRecordsLabel.isHidden = false
            noSearchRecordsLabel.snp.makeConstraints { make in
                make.top.equalTo(recentSearchLabel.snp.bottom).offset(screenHeight / 53.33)
                make.left.equalToSuperview().inset(screenWidth / 12.85)
            }
        } else {
            // 데이터가 있으면 컬렉션뷰 보이게 하고 안내 text 숨기기
            recentSearchCollectionView.isHidden = false
            noSearchRecordsLabel.isHidden = true
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
            print("DEBUG:", nowPeopleFilter as Any, nowTimeFilter as Any)
            
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getSearchedDeliveryList(input)
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
            nowTimeFilter = orderTimeCategory
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getSearchedDeliveryList(input)
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
        
        // 검색 결과에 해당하는 데이터가 없으면
        showSearchResultView(isEmpty: deliveryCellDataArray.isEmpty)
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
    
    /* 서브뷰에 제스쳐 추가 */
    private func setTapGestures() {
        // peopleFilterView에 탭 제스처 추가
        let viewTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapPeopleFilterView))
        peopleFilterView.isUserInteractionEnabled = true
        peopleFilterView.addGestureRecognizer(viewTapGesture)
        
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
    }
    
    /* 테이블뷰 셀의 마지막 데이터까지 스크롤 했을 때 이를 감지해주는 함수 */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 하는 게 배달 파티 목록일 때, 데이터가 존재할 때에만 실행
        if scrollView == partyTableView, deliveryCellDataArray.count != 0 {
            let position = scrollView.contentOffset.y
            print("pos", position)
            
            // 현재 화면에 테이블뷰 셀이 몇개까지 들어가는지
            let maxCellNum = partyTableView.bounds.size.height / partyTableView.rowHeight
            let boundCellNum = 10 - maxCellNum
            
            // 마지막 데이터에 도달했을 때 다음 데이터 10개를 불러온다
            if position > ((partyTableView.rowHeight) * (boundCellNum + (10 * CGFloat(cursor)))) {
                // 마지막 페이지가 아니라면, 다음 커서의 배달 목록을 불러온다
                if !isFinalPage {
                    cursor += 1
                    let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
                    getSearchedDeliveryList(input)
                }
            }
        }
    }
    
    // 최근 검색어 객체 생성 후 로컬에 저장하는 함수.
    private func saveSearchRecords(_ data: String) {
        if !(data.isEmpty) {
            // 로컬에 최근 검색어 객체 저장.
            let searchRecord = SearchRecord(content: data)
            
            print("[TEST]", data)
            try! localRealm.write {
                localRealm.add(searchRecord)
            }
        }
    }
    
    /* 설정해둔 인원수 필터 뷰 초기화 */
    private func resetPeopleFilterView() {
        // 색깔 원상복귀
        selectedPeopleLabel?.textColor = .init(hex: 0xA8A8A8)
        // peopleFilterView의 텍스트도 원상복귀
        peopleFilterLabel.text = "인원 선택"
        peopleFilterLabel.textColor = .init(hex: 0xA8A8A8)
        
        // 필터 해제
        selectedPeopleLabel = nil
        nowPeopleFilter = nil
    }
    
    /* 설정해둔 시간 필터 뷰 초기화 */
    private func resetTimeFilterView() {
        // 선택돼있던 label이 재선택된 거면, 원래 색깔로 되돌려 놓는다 - 현재 선택된 시간 필터 0개
        selectedTimeLabel?.textColor = .init(hex: 0xD8D8D8)
        
        // 시간 필터 초기화
        selectedTimeLabel = nil
        nowTimeFilter = nil
    }
    
    // MARK: - @objc Functions
    
    /*
     검색 버튼을 눌렀을 때 실행되는 함수
     - 최근 검색어 목록에 항목 추가됨
     - API를 통해 검색어가 들어간 배달 파티 리스트를 불러옴
     - 검색 결과 화면을 보여줌
     */
    @objc
    private func tapSearchButton() {
        if nowSearchKeyword != searchTextField.text {
            // 필터, 데이터 초기화
            resetPeopleFilterView()
            resetTimeFilterView()
            removeCellData()
            
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getSearchedDeliveryList(input)
            
            nowSearchKeyword = searchTextField.text!
            print("DEBUG: 검색 키워드", nowSearchKeyword)
            
            saveSearchRecords(nowSearchKeyword)
        }
    }
    
    /* 최근 검색어 목록에서 X 버튼 클릭시 실행되는 함수 */
    @objc
    private func tapXButton(_ sender: UIButton) {
        guard let searchRecords = recentSearchDataArray else { return }
        // 클릭된 X 버튼이 컬렉션뷰 내에서 몇 번째 셀이었는지 변환
        let hitPoint = sender.convert(CGPoint.zero, to: recentSearchCollectionView)
        // 해당 위치의 indexPath 값
        if let indexPath = recentSearchCollectionView.indexPathForItem(at: hitPoint) {
            // 그 위치에 해당하는 로컬 데이터를 삭제
            try! localRealm.write {
                localRealm.delete(searchRecords[indexPath.item])
            }
            // 컬렉션뷰를 리로드
            recentSearchCollectionView.reloadData()
            // 최근 검색어 기록 점검 -> 빈 값 없는지
            checkSearchRecordsNum()
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
            // 인원수 필터 뷰, 데이터 초기화
            resetPeopleFilterView()
            removeCellData()
            
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getSearchedDeliveryList(input)
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
        // DropDown뷰 접기
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
        } else { // 눌렀던 거 또 눌렀을 때
            // 시간 필터 뷰, 데이터 초기화
            resetTimeFilterView()
            removeCellData()
            
            let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
            getSearchedDeliveryList(input)
        }
        
        // 필터가 변경되면 스크롤 맨 위로
        partyTableView.reloadData()
    }
    
    /* 새로고침 기능 */
    @objc
    private func pullToRefresh() {
        // 데이터가 적재된 상황에서 맨 위로 올려 새로고침을 했다면, 배열을 초기화시켜서 처음 10개만 다시 불러온다
        print("DEBUG: 적재된 데이터 \(deliveryCellDataArray.count)개 삭제")
        removeCellData()
        
        // API 호출
        let input = DeliveryListInput(maxMatching: nowPeopleFilter, orderTimeCategory: nowTimeFilter)
        getSearchedDeliveryList(input)
        
        // 테이블뷰 새로고침
        partyTableView.reloadData()
        // 당기는 게 끝나면 refresh도 끝나도록
        partyTableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // cell 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            guard let searchRecords = recentSearchDataArray else { return 0 }
            return searchRecords.count
        } else {
            return timeDataArray.count
        }
    }
    
    // cell 내용 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchRecords = recentSearchDataArray else { return UICollectionViewCell() }
        if collectionView.tag == 1 {
            // RecentSearchCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 텍스트(검색어 기록) 설정
            cell.recentSearchLabel.text = searchRecords[indexPath.item].content
            cell.xButton.addTarget(self, action: #selector(tapXButton), for: .touchUpInside)
            return cell
        } else {
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
    
    // cell 클릭시 실행할 동작 정의
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? RecentSearchCollectionViewCell else { return }
            // 검색 텍스트 필드 값을 클릭한 셀의 text 내용으로 설정
            self.searchTextField.text = selectedCell.recentSearchLabel.text
        }
    }
    
    // 각 cell의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return .zero }
            // 들어간 검색어 텍스트 + 20만큼 셀의 width를 설정한다. -> 최근 검색어 text 길이 제한 없음
            cell.recentSearchLabel.text = recentSearchDataArray?[indexPath.item].content
            cell.recentSearchLabel.sizeToFit()
            
            let cellWidth = cell.recentSearchLabel.frame.width + 20
            return CGSize(width: cellWidth, height: 28)
        } else {
            return CGSize(width: 54, height: 34)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryCellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PartyTableViewCell.identifier, for: indexPath) as? PartyTableViewCell else { return UITableViewCell() }
        
        // 현재 row의 셀 데이터 -> DeliveryListModelResult 형식
        let nowData = deliveryCellDataArray[indexPath.row]
        
        // API를 통해 받아온 데이터들이 다 있으면, 데이터를 컴포넌트에 각각 할당해 준다
        if let currentMatching = nowData.currentMatching,
           let maxMatching = nowData.maxMatching,
           let orderTime = nowData.orderTime,
           let title = nowData.title,
           let hasHashTag = nowData.hasHashTag,
           let foodCategory = nowData.foodCategory {
            cell.peopleLabel.text = String(currentMatching)+"/"+String(maxMatching)
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
        guard let partyId = deliveryCellDataArray[indexPath.row].id else { return }
        let partyVC = PartyViewController(partyId: partyId, dormitoryInfo: dormitoryInfo)
        self.navigationController?.pushViewController(partyVC, animated: true)
        
        // 클릭된 셀 배경색 제거 & separator 다시 나타나게 하기 위해서
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    /* 텍스트 필드 내용이 변경될 때 호출되는 함수 */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text else { return true }
        let newLength = str.count + string.count - range.length
        
        // 검색 결과 보고난 후에 검색어를 다 지우면 원래 검색 화면을 다시 보여준다
        if newLength == 0 {
            nowSearchKeyword = ""   // 초기화
            // 필터 dropdown뷰가 확장 돼있으면 접고 원래 화면으로
            if isDropDownPeople {
                tapPeopleFilterView()
            }
            showSearchMainView()
        }
        
        // 100자 제한
        return newLength <= 100
    }
    
    // 키보드의 return 버튼 누르면 내려가게, 검색 실행되게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tapSearchButton()
        return true
    }
    
    // 스크린의 어디든 터치하면 키보드가 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
}

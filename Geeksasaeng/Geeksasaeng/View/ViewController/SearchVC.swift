//
//  SearchVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit
import SnapKit

// TODO: - 서버로부터 검색 결과 가져오면 최근 검색어부터 뷰 싹 다 밀고 테이블뷰 가져와야 함...
class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    // TODO: - 추후에 서버에서 가져온 값으로 변경해야 함
    var recentSearchDataArray = ["중식", "한식", "이야기", "이야기", "이야기",
                                 "중식", "한식", "이야기", "이야기", "이야기"]
    var weeklyTopDataArray = ["치킨", "마라샹궈", "마라탕", "탕수육", "피자",
                              "족발", "빵", "냉면", "커피", "떡볶이"]
    var timeDataArray = ["아침", "점심", "저녁", "야식"]
    
    // 필터뷰가 DropDown 됐는지 안 됐는지 확인하기 위한 변수
    var isDropDownPeople = false
    
    // 배달 목록 화면 처음 킨 건지 여부 확인
    var isInitial = true
    
    // 필터링이 설정되어 있는지/아닌지 여부 확인
    var isPeopleFilterOn = false
    var isTimeFilterOn = false
    
    // 현재 설정되어 있는 인원수 필터값이 뭔지 가져오기 위해
    var nowPeopleFilter: Int? = nil
    // 현재 설정되어 있는 시간 필터값
    var nowTimeFilter: String? = nil

    // 목록에서 현재 커서 위치
    var cursor = 0
    // 배달 목록 데이터가 저장되는 배열
    var deliveryCellDataArray: [DeliveryListModelResult] = []
    
    // MARK: - Subviews
    
    /* 검색창 textField */
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .init(hex: 0x2F2F2F)
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEFEFEF),
                NSAttributedString.Key.font: UIFont.customFont(.neoMedium, size: 20)
            ]
        )
        textField.makeBottomLine(323)
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SearchMark"), for: .normal)
        // TODO: - 검색 API 연동 후 수정
        button.addTarget(self, action: #selector(hideSearchMainView), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    var recentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        return label
    }()
    
    var dormitoryWeeklyTopLabel: UILabel = {
        let label = UILabel()
        // TODO: - 추후에 기숙사 정보 받아와서 넣기
        label.text = "제1기숙사 Weekly TOP 10"
        return label
    }()
    
    /* 최근 검색어 기록 Collection View */
    var recentSearchCollectionView: UICollectionView = {
        // 레이아웃 설정
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // 셀 사이 좌우 간격 설정
        layout.minimumInteritemSpacing = 20
        
        // 컬렉션뷰 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.tag = 1
        
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    /* Weekly Top 10 Collection View */
    var weeklyTopCollectionView: UICollectionView = {
        // 레이아웃 설정
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // 셀 사이 좌우 간격 설정
        layout.minimumLineSpacing = 70
        layout.minimumInteritemSpacing = 3
        
        // 컬렉션뷰 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.tag = 2
        
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    /* 구분선 View */
    var firstSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    /* 배경에 있는 로고 이미지 */
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: - svg 파일로 하니까 색이 너무너무 연하다... 네오한테 말 해봐야 될 듯
        imageView.image = UIImage(named: "SearchBackLogo")
        return imageView
    }()
    
    /* 여기서부터 있는 서브뷰들은 다 '검색 결과 화면'에 쓰이는 서브뷰 */
    /* Filter Icon */
    let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "FilterImage"))
        imageView.tintColor = UIColor(hex: 0x2F2F2F)
        imageView.isHidden = true
        return imageView
    }()
    
    /* People Filter */
    var peopleFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "인원 선택"
        label.font = .customFont(.neoMedium, size: 14)
        label.textColor = UIColor(hex: 0xA8A8A8)
        label.isHidden = true
        return label
    }()
    var peopleFilterToggleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleMark"))
        imageView.tintColor = UIColor(hex: 0xD8D8D8)
        imageView.isHidden = true
        return imageView
    }()
    lazy var peopleFilterView: UIView = {
        var view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        view.layer.cornerRadius = 5
        view.isHidden = true
        
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
        return view
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
        
        // 왼쪽, 오른쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
        view.isHidden = true
        
        view.addSubview(peopleOptionStackView)
        peopleOptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.left.equalToSuperview().inset(11)
        }
        return view
    }()
    
    /* peopleFilterView가 dropdown 됐을 때 테두리 그림자를 활성화 시켜주기 위해 생성한 컨테이너 뷰 */
    lazy var peopleFilterContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.isHidden = true
        
        // 테두리 그림자 생성
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.masksToBounds = false
        
        [peopleFilterView, peopleDropDownView].forEach { view.addSubview($0) }
        
        return view
    }()
   
    /* Time Filter -> 컬렉션뷰로 */
    var timeCollectionView: UICollectionView = {
        // 레이아웃 설정
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // 셀 사이 좌우 간격 설정
        layout.minimumInteritemSpacing = 9
        
        // 컬렉션뷰 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.tag = 3
        
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//    // 아침
//    var breakfastFilterView = UIView()
//    // 점심
//    var lunchFilterView = UIView()
//    // 저녁
//    var dinnerFilterView = UIView()
//    // 야식
//    var midnightSnackFilterView = UIView()
//
//    /* 시간 관련 필터뷰들을 묶어놓는 스택뷰 */
//    lazy var timeOptionStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [breakfastFilterView, lunchFilterView, dinnerFilterView, midnightSnackFilterView])
//        stackView.spacing = 10
//        return stackView
//    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [recentSearchLabel, dormitoryWeeklyTopLabel].forEach {
            setMainTextAttributes($0)
        }
        
        addSubViews()
        setLayouts()
        
        [
            recentSearchCollectionView,
            weeklyTopCollectionView,
            timeCollectionView
        ].forEach { setCollectionView($0) }
        
        [
            filterImageView,
            peopleFilterView,
            peopleFilterLabel,
            peopleFilterToggleImageView,
            timeCollectionView
        ].forEach { $0.isHidden = true }
        
        addGestures()
    }
    
    // MARK: - viewWillAppear()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Back 버튼 숨기기 & 상단에 위치한 텍스트 필드에 탭이 가능하게 하기 위해
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Functions
    
    /* 공통 속성 설정 */
    private func setMainTextAttributes(_ label: UILabel) {
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 18)
    }
    
    private func addSubViews() {
        [
            searchTextField,
            searchButton,
            recentSearchLabel, dormitoryWeeklyTopLabel,
            recentSearchCollectionView,
            weeklyTopCollectionView,
            firstSeparateView,
            logoImageView,
            // 이 아래는 검색 결과 화면에 쓰이는 서브뷰들
            filterImageView, peopleFilterView,
            timeCollectionView,
            peopleDropDownView, peopleFilterContainerView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalToSuperview().inset(30)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.right.equalToSuperview().inset(33)
            make.width.height.equalTo(30)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(searchTextField.snp.bottom).offset(45)
        }
        dormitoryWeeklyTopLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(firstSeparateView.snp.bottom).offset(21)
        }
        
        recentSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalTo(firstSeparateView.snp.top).offset(-17)
        }
        
        weeklyTopCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dormitoryWeeklyTopLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(170)
        }
        
        firstSeparateView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(61)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(143)
            make.height.equalTo(80)
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
            make.height.equalTo(124)
            make.top.equalTo(peopleFilterView.snp.bottom)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        peopleFilterContainerView.snp.makeConstraints { make in
            make.width.equalTo(peopleFilterView)
            make.height.equalTo(158)
            make.top.equalTo(peopleFilterView)
            make.left.equalTo(filterImageView.snp.right).offset(16)
        }
        timeCollectionView.snp.makeConstraints { make in
            make.left.equalTo(peopleFilterView.snp.right).offset(9)
            make.right.equalToSuperview().inset(9)
            make.centerY.equalTo(peopleFilterView)
            make.height.equalTo(34)
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
        } else if collectionView.tag == 2 {
            collectionView.register(WeeklyTopCollectionViewCell.self,
                                      forCellWithReuseIdentifier: WeeklyTopCollectionViewCell.identifier)
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
              filterLabel.textColor = .init(hex: 0xD8D8D8)
              filterLabel.font = .customFont(.neoMedium, size: 11)
              filterLabel.text = filterText
              
              /* Stack View */
              stackView.addArrangedSubview(filterLabel)
          }
    }
    
    /* 검색 메인 화면을 숨긴다 -> 검색 결과 화면을 보여주려고! */
    @objc
    private func hideSearchMainView() {
        [
            recentSearchLabel,
            dormitoryWeeklyTopLabel,
            recentSearchCollectionView,
            weeklyTopCollectionView,
            firstSeparateView,
            logoImageView
        ].forEach { $0.isHidden = true }
        
        [
            filterImageView,
            peopleFilterView,
            peopleFilterLabel,
            peopleFilterToggleImageView,
            timeCollectionView
        ].forEach { $0.isHidden = false }
    }
    
    /* 서브뷰에 제스쳐 추가 */
    private func addGestures() {
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
    
    /* peopleFilterView 탭하면 DropDown 뷰를 보여준다 */
    @objc private func tapPeopleFilterView() {
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
    @objc private func tapPeopleOption(sender: UIGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // label 색 변경 - 진하게
        label.textColor = .init(hex: 0x636363)
        // peopleFilterView의 텍스트를 label로 변경함
        peopleFilterLabel.text = label.text
        
        // 인원수 필터링 호출
//        self.getPeopleFilterList(text: label.text)
        
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
        
        // label 색 변경 - mainColor로 -> 필터가 선택된 것
        if label.textColor != .mainColor {
            label.textColor = .mainColor
            // 시간 필터링 호출
//            getTimeFilterList(text: label.text)
        } else {
            // 원래 색깔로 되돌려 놓는다
            label.textColor = .init(hex: 0xD8D8D8)
            
            // 시간 필터 해제
            isTimeFilterOn = false
            nowTimeFilter = nil
            
            cursor = 0
            if nowPeopleFilter == nil {
//                getDeliveryList()
            } else {
//                getDeliveryList(maxMatching: nowPeopleFilter)
            }
        }
    }
    
    // 이전 화면으로 돌아가기
//    @objc func back(sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
//    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // cell 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return recentSearchDataArray.count
        } else if collectionView.tag == 2 {
            return weeklyTopDataArray.count
        } else {
            return timeDataArray.count
        }
    }
    
    // cell 내용 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            // RecentSearchCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 텍스트(검색어 기록) 설정
            cell.recentSearchLabel.text = recentSearchDataArray[indexPath.item]
            return cell
        } else if collectionView.tag == 2 {
            // WeeklyTopCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyTopCollectionViewCell.identifier, for: indexPath) as? WeeklyTopCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 텍스트(검색어 순위, 검색어) 설정
            cell.rankLabel.text = String(indexPath.item + 1)
            cell.searchLabel.text = weeklyTopDataArray[indexPath.item]
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
    
    // 각 cell의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: recentSearchDataArray[indexPath.item].size(withAttributes: nil).width + 25, height: 28)
        } else if collectionView.tag == 2 {
            return CGSize(width: 75, height: 28)
        } else {
            return CGSize(width: 54, height: 34)
        }
    }
}

//
//  EditPartyVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import UIKit
import SnapKit
import CoreLocation
import Then

/* 이전 뷰로 수정되었음을 전달해주기 위한 Protocol (delegate pattern) */
protocol EdittedDelegate: AnyObject { // delegate pattern을 위한 protocol 정의
  func checkEditted(isEditted: Bool)
}

class EditPartyViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - SubViews
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    // 콘텐츠뷰
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        $0.addGestureRecognizer(gesture)
    }
    
    /* 우측 상단 완료 버튼 */
    var deactivatedRightBarButtonItem = UIBarButtonItem().then {
        let registerButton = UIButton().then {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        }
        $0.customView = registerButton
        $0.isEnabled = false
    }
    
    /* 타이틀 위 같이 먹고 싶고 싶어요 버튼 */
    lazy var eatTogetherButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        $0.tintColor = UIColor(hex: 0xD8D8D8)
        $0.setTitle("  같이 먹고 싶어요", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoLight, size: 13)
        $0.addTarget(self, action: #selector(tapEatTogetherButton), for: .touchUpInside)
    }
    
    /* 타이틀 텍스트 필드 */
    lazy var titleTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xA8A8A8)]
        )
        $0.font = .customFont(.neoMedium, size: 20)
        $0.textColor = .black
        
        // backgroundColor를 설정해 줬더니 borderStyle의 roundRect이 적용되지 않아서 따로 layer를 custom함
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0xEFEFEF).cgColor
        
        // placeholder와 layer 사이에 간격 설정
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
    }
    
    /* 내용 텍스트 필드 */
    var contentsTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .customFont(.neoRegular, size: 15)
        $0.refreshControl?.contentVerticalAlignment = .top
        $0.text = "내용을 입력하세요"
        $0.textColor = .black
    }
    
    /* 구분선 */
    var separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    
    /* Option labels */
    var orderForecastTimeLabel = UILabel()
    var matchingPersonLabel = UILabel()
    var categoryLabel = UILabel()
    var urlLabel = UILabel()
    var locationLabel = UILabel()
    
    /* selected Button & labels */
    lazy var orderForecastTimeButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.contentHorizontalAlignment = .left
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        $0.addTarget(self, action: #selector(tapOrderForecastTimeButton), for: .touchUpInside)
    }
        
    var selectedPersonLabel = UILabel()
    var selectedCategoryLabel = UILabel()
    var selectedUrlLabel = UILabel()
    var selectedLocationLabel = UILabel()
    
    /* Edit imageView */
    let orderEditImageView = UIImageView()
    let matchingEditImageView = UIImageView()
    let categoryEditImageView = UIImageView()
    let urlEditImageView = UIImageView()
    let locationEditImageView = UIImageView()
    
    /* 서브뷰 나타났을 때 뒤에 블러뷰 */
    var visualEffectView: UIVisualEffectView?
    
    let mapSubView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    let blockedView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    
    // MARK: - Properties
    
    weak var isEdittiedDelegate: EdittedDelegate?
    var isEditedContentsTextView = false // 내용이 수정되었는지
    var mapView: MTMapView? // 카카오맵
    var marker: MTMapPOIItem = {
        let marker = MTMapPOIItem()
        marker.showAnimationType = .dropFromHeaven
        marker.markerType = .redPin
        marker.itemName = "요기?"
        marker.showDisclosureButtonOnCalloutBalloon = false
        marker.draggable = true
        return marker
    }()
    var dormitoryInfo: DormitoryNameResult? // dormitory id, name
    var detailData: DeliveryListDetailModelResult?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNotificationCenter()
        setAttributeOfOptionLabel()
        setAttributeOfSelectedLabel()
        setEditImageViews()
        setDelegate()
        setNavigationBar()
        setTapGestureToLabels()
        setDefaultValue()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapEditOrderTimeButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapEditPersonButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapEditCategoryButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapEditUrlButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapEditLocationButton"), object: nil)
        
        mapView = nil // 맵뷰 초기화
        
        // 전역변수 초기화
        CreateParty.orderForecastTime = nil
        CreateParty.matchingPerson = nil
        CreateParty.category = nil
        CreateParty.url = nil
        CreateParty.address = nil
        CreateParty.latitude = nil
        CreateParty.longitude = nil
    }
    
    // MARK: - Functions
    
    private func setMapView() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        
        if let mapView = mapView {
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            mapView.isUserInteractionEnabled = false
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: CreateParty.latitude ?? 37.456518177069526,
                                                                    longitude: CreateParty.longitude ?? 126.70531256589555)), zoomLevel: 5, animated: true)
            // 마커의 좌표 설정
            self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: CreateParty.latitude ?? 37.456518177069526, longitude: CreateParty.longitude ?? 126.70531256589555))
            
            mapView.addPOIItems([marker])
            mapSubView.addSubview(mapView)
        }
        
        view.addSubview(mapSubView)
        mapSubView.snp.makeConstraints { make in
            make.top.equalTo(selectedLocationLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(28)
            make.width.equalTo(314)
            make.height.equalTo(144)
        }
        
        view.layoutSubviews()
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditOrderTimeButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                if let orderForecastTime = CreateParty.orderForecastTime {
                    self.orderForecastTimeButton.layer.shadowRadius = 0
                    self.orderForecastTimeButton.setTitle("      \(orderForecastTime)", for: .normal)
                    self.orderForecastTimeButton.titleLabel?.font = .customFont(.neoMedium, size: 13)
                    self.orderForecastTimeButton.backgroundColor = UIColor(hex: 0xF8F8F8)
                    self.orderForecastTimeButton.setTitleColor(.black, for: .normal)
                }
                self.visualEffectView?.removeFromSuperview()
                self.children.first?.view.removeFromSuperview()
                self.children.first?.removeFromParent()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditPersonButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                if let matchingPerson = CreateParty.matchingPerson {
                    self.selectedPersonLabel.text = "      \(matchingPerson)"
                    self.selectedPersonLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedPersonLabel.textColor = .black
                    self.selectedPersonLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                self.visualEffectView?.removeFromSuperview()
                self.children.first?.view.removeFromSuperview()
                self.children.first?.removeFromParent()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditCategoryButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                if let category = CreateParty.category {
                    self.selectedCategoryLabel.text = "      \(category)"
                    self.selectedCategoryLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedCategoryLabel.textColor = .black
                    self.selectedCategoryLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                self.visualEffectView?.removeFromSuperview()
                self.children.first?.view.removeFromSuperview()
                self.children.first?.removeFromParent()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditUrlButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                if let url = CreateParty.url {
                    self.selectedUrlLabel.text = "      \(url)"
                    self.selectedUrlLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedUrlLabel.textColor = .black
                    self.selectedUrlLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                self.visualEffectView?.removeFromSuperview()
                self.children.first?.view.removeFromSuperview()
                self.children.first?.removeFromParent()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditLocationButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                if let address = CreateParty.address {
                    self.selectedLocationLabel.text = "      \(address)"
                    self.selectedLocationLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedLocationLabel.textColor = .black
                    self.selectedLocationLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                self.visualEffectView?.removeFromSuperview()
                self.children.first?.view.removeFromSuperview()
                self.children.first?.removeFromParent()
                self.blockedView.removeFromSuperview()
                self.setMapView()
            }
        }
    }
    
    @objc func tapContentView() {
        view.endEditing(true)
        
        visualEffectView?.removeFromSuperview()
        children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    private func setAttributeOfOptionLabel() {
        [orderForecastTimeLabel, matchingPersonLabel, categoryLabel, urlLabel, locationLabel].forEach {
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .init(hex: 0x2F2F2F)
        }
        orderForecastTimeLabel.text = "주문 예정 시간"
        matchingPersonLabel.text = "매칭 인원 선택"
        categoryLabel.text = "카테고리 선택"
        urlLabel.text = "식당 링크"
        locationLabel.text = "수령장소"
    }
    
    private func setAttributeOfSelectedLabel() {
        [selectedPersonLabel, selectedCategoryLabel, selectedUrlLabel, selectedLocationLabel].forEach {
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .black
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 3
        }
        selectedPersonLabel.text = "      0/0"
        selectedCategoryLabel.text = "      한식"
        selectedUrlLabel.text = "      url"
        selectedLocationLabel.text = "      제1기숙사 정문"
    }
    
    private func setEditImageViews() {
        [orderEditImageView, matchingEditImageView, categoryEditImageView, urlEditImageView, locationEditImageView].forEach {
            $0.image = UIImage(named: "PartyEdit")
        }
    }
    
    private func setDelegate() {
        scrollView.delegate = self
        contentsTextView.delegate = self
        titleTextField.delegate = self
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRegisterButton))
        navigationItem.rightBarButtonItem?.tintColor = .mainColor
        self.navigationItem.title = "파티 수정하기"
        self.navigationItem.titleView?.tintColor = .init(hex: 0x2F2F2F)
        
        // set barButtonItem
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(tapBackButton(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setTapGestureToLabels() {
        let personTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectedPersonLabel))
        selectedPersonLabel.isUserInteractionEnabled = true
        selectedPersonLabel.addGestureRecognizer(personTapGesture)
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectedCategoryLabel))
        selectedCategoryLabel.isUserInteractionEnabled = true
        selectedCategoryLabel.addGestureRecognizer(categoryTapGesture)
        
        let urlTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectedUrlLabel))
        selectedUrlLabel.isUserInteractionEnabled = true
        selectedUrlLabel.addGestureRecognizer(urlTapGesture)
        
        let placeTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectedLocationLabel))
        selectedLocationLabel.isUserInteractionEnabled = true
        selectedLocationLabel.addGestureRecognizer(placeTapGesture)
    }
    
    /* 상세 조회 화면으로부터 받은 데이터로 각 컴포넌트 초기화 */
    private func setDefaultValue() {
        if let detailData = detailData {
            titleTextField.text = detailData.title
            contentsTextView.text = detailData.content
            selectedPersonLabel.text = "      \(detailData.maxMatching!)명"
            selectedCategoryLabel.text = "      \(detailData.foodCategory!)"
            selectedUrlLabel.text = "      \(detailData.storeUrl!)"
            
            if detailData.hashTag ?? false {
                eatTogetherButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                eatTogetherButton.tintColor = .mainColor
                eatTogetherButton.setTitleColor(.mainColor, for: .normal)
            }
            
            /* 날짜, 시간 포맷팅 */
            let str = detailData.orderTime!.replacingOccurrences(of: " ", with: "")
            let startIdx = str.index(str.startIndex, offsetBy: 5)
            let middleIdx = str.index(startIdx, offsetBy: 5)
            let endIdx = str.index(middleIdx, offsetBy: 5)
            let dateRange = startIdx..<middleIdx // 월, 일
            let timeRange = middleIdx..<endIdx // 시, 분
            let dateStr = str[dateRange].replacingOccurrences(of: "-", with: "월 ") + "일"
            let timeStr = str[timeRange].replacingOccurrences(of: ":", with: "시 ") + "분"
            orderForecastTimeButton.setTitle("      \(dateStr)        \(timeStr)", for: .normal)
            
            /* 서브뷰에 default value를 띄우기 위함 */
            CreateParty.orderForecastTime = "\(dateStr)        \(timeStr)"
            CreateParty.matchingPerson = "\(detailData.maxMatching!)명"
            CreateParty.category = detailData.foodCategory
            CreateParty.url = detailData.storeUrl
            CreateParty.latitude = detailData.latitude
            CreateParty.longitude = detailData.longitude
            
            /* 수정하기 API를 호출하기 위함 */
            CreateParty.orderTime = detailData.orderTime
            CreateParty.maxMatching = detailData.maxMatching
            CreateParty.hashTag = detailData.hashTag
            switch detailData.foodCategory {
            case "한식":
                CreateParty.foodCategory = 1
            case "양식":
                CreateParty.foodCategory = 2
            case "중식":
                CreateParty.foodCategory = 3
            case "일식":
                CreateParty.foodCategory = 4
            case "분식":
                CreateParty.foodCategory = 5
            case "치킨/피자":
                CreateParty.foodCategory = 6
            case "회/돈까스":
                CreateParty.foodCategory = 7
            case "패스트 푸드":
                CreateParty.foodCategory = 8
            case "디저트/음료":
                CreateParty.foodCategory = 9
            case "기타":
                CreateParty.foodCategory = 10
            default:
                print("category ERROR")
            }
            
            /* 현재 위치를 한글 데이터로 받아오기 */
            let locationNow = CLLocation(latitude: detailData.latitude ?? 37.456518177069526, longitude: detailData.longitude ?? 126.70531256589555)
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ko_kr")
            // 위치 받기 (국적, 도시, 동&구, 상세 주소)
            geocoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { (placemarks, error) in
                if let address = placemarks {
                    if let administrativeArea = address.last?.administrativeArea,
                       let locality = address.last?.locality,
                       let name = address.last?.name {
                        self.selectedLocationLabel.text = "      \(administrativeArea) \(locality) \(name)"
                    }
                }
            }
        }
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [eatTogetherButton, titleTextField, contentsTextView, separateView,
         orderForecastTimeLabel, matchingPersonLabel, categoryLabel, urlLabel, locationLabel,
         orderForecastTimeButton, selectedPersonLabel, selectedCategoryLabel, selectedUrlLabel, selectedLocationLabel,
         orderEditImageView, matchingEditImageView, categoryEditImageView, urlEditImageView, locationEditImageView,
         blockedView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        // 컨텐츠뷰
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        eatTogetherButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.left.equalToSuperview().inset(28)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(eatTogetherButton.snp.bottom).offset(11)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(314)
            make.height.equalTo(45)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(38)
            make.width.equalTo(294)
            make.height.equalTo(157)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(16)
            make.height.equalTo(8)
            make.width.equalToSuperview()
        }
        
        orderForecastTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(28)
        }
        
        matchingPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeLabel.snp.bottom).offset(38)
            make.left.equalToSuperview().inset(28)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(matchingPersonLabel.snp.bottom).offset(38)
            make.left.equalToSuperview().inset(28)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(38)
            make.left.equalToSuperview().inset(28)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(38)
            make.left.equalToSuperview().inset(28)
        }
        
        orderForecastTimeButton.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(20)
            make.left.equalTo(orderForecastTimeLabel.snp.right).offset(45)
            make.width.equalTo(188)
            make.height.equalTo(38)
        }
        
        selectedPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeButton.snp.bottom).offset(16)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(38)
        }
        
        selectedCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedPersonLabel.snp.bottom).offset(16)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(38)
        }
        
        selectedUrlLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedCategoryLabel.snp.bottom).offset(16)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(38)
        }
        
        selectedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedUrlLabel.snp.bottom).offset(16)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(38)
        }
        
        /* Edit Pencil imageView */
        orderEditImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(orderForecastTimeButton.snp.top).offset(14)
            make.right.equalTo(orderForecastTimeButton.snp.right).inset(14)
        }
        matchingEditImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(selectedPersonLabel.snp.top).offset(14)
            make.right.equalTo(selectedPersonLabel.snp.right).inset(14)
        }
        categoryEditImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(selectedCategoryLabel.snp.top).offset(14)
            make.right.equalTo(selectedCategoryLabel.snp.right).inset(14)
        }
        urlEditImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(selectedUrlLabel.snp.top).offset(14)
            make.right.equalTo(selectedUrlLabel.snp.right).inset(14)
        }
        locationEditImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(selectedLocationLabel.snp.top).offset(14)
            make.right.equalTo(selectedLocationLabel.snp.right).inset(14)
        }
        
        blockedView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(selectedLocationLabel.snp.bottom).offset(16)
            make.width.equalTo(314)
            make.height.equalTo(144)
        }
    }
    
    private func createBlurView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        visualEffectView.isUserInteractionEnabled = false
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    @objc func tapEatTogetherButton() {
        if eatTogetherButton.currentImage == UIImage(systemName: "checkmark.circle") {
            eatTogetherButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            eatTogetherButton.tintColor = .mainColor
            eatTogetherButton.setTitleColor(.mainColor, for: .normal)
            CreateParty.hashTag = true
        } else {
            eatTogetherButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            eatTogetherButton.tintColor = UIColor(hex: 0xD8D8D8)
            eatTogetherButton.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            CreateParty.hashTag = false
        }
    }
    
    @objc func changeValueTitleTextField() {
        if isEditedContentsTextView
            && contentsTextView.text.count >= 1
            && titleTextField.text?.count ?? 0 >= 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.tapRegisterButton))
            self.navigationItem.rightBarButtonItem?.tintColor = .mainColor
            self.view.layoutSubviews()
        } else if isEditedContentsTextView {
            self.navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
            self.view.layoutSubviews()
        }
    }
    
    @objc func tapOrderForecastTimeButton() {
        view.endEditing(true)
        createBlurView()
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = EditOrderForecastTimeViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc func tapSelectedPersonLabel() {
        createBlurView()
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = EditMatchingPersonViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }

    @objc func tapSelectedCategoryLabel() {
        createBlurView()
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = EditCategoryViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc func tapSelectedUrlLabel() {
        createBlurView()
        // selectedUrlLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = EditUrlViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc func tapSelectedLocationLabel() {
        createBlurView()
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC, UrlVC,receiptPlaceVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = EditReceiptPlaceViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    /* 이전 화면으로 돌아가기 */
    @objc func tapBackButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc func tapRegisterButton() {
        /* 파티 수정하기 API 호출 */
        // CreateParty를 통해 초기화해야 하는 속성: foodCategory, orderTime, maxMatching, storeUrl, latitude, longtitude, hashTag
        if let foodCategory = CreateParty.foodCategory,
           let orderTime = CreateParty.orderTime,
           let maxMatching = CreateParty.maxMatching,
           let storeUrl = CreateParty.url,
           let latitude = CreateParty.latitude,
           let longitude = CreateParty.longitude,
           let hashTag = CreateParty.hashTag,
           let partyId = detailData?.id,
           let title = titleTextField.text,
           let content = contentsTextView.text {
            EditPartyViewModel.editParty(dormitoryId: dormitoryInfo?.id ?? 1, partyId: partyId,
                EditPartyInput(foodCategory: foodCategory,
                               title: title, content: content,
                               orderTime: orderTime,
                               maxMatching: maxMatching,
                               storeUrl: storeUrl,
                               latitude: latitude,
                               longitude: longitude,
                               hashTag: hashTag)
            ) { success in
                if success {
                    /* 수정된 정보로 이전 뷰 내용 업데이트 */
                    NotificationCenter.default.post(name: NSNotification.Name("TapEditCompleteButton"), object: "true")
                    
                    /* 수정되었음을 알림 -> 토스트 메시지 띄우기 (Delegate pattern) */
                    self.isEdittiedDelegate?.checkEditted(isEditted: true)
                    self.navigationController?.popViewController(animated: true) // 수정된 정보로 나타내야 함, Alert 띄우기
                } else {
                    self.showToast(viewController: self, message: "파티 수정을 실패하였습니다", font: .customFont(.neoBold, size: 13), color: .mainColor)
                }
            }
        }
    }
}

extension EditPartyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text else { return true }
        let newLength = str.count + string.count - range.length
        
        return newLength <= 20
    }
}

extension EditPartyViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor(hex: 0xD8D8D8)
            isEditedContentsTextView = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isEditedContentsTextView = true
        if isEditedContentsTextView
            && contentsTextView.text.count >= 1
            && titleTextField.text?.count ?? 0 >= 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRegisterButton))
            navigationItem.rightBarButtonItem?.tintColor = .mainColor
            view.layoutSubviews()
        } else if isEditedContentsTextView {
            navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
            view.layoutSubviews()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        
        return newLength <= 100
    }
}

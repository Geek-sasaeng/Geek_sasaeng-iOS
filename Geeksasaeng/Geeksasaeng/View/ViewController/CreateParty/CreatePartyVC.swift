//
//  CreatePartyVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/11.
//

/* 파티 생성하기 API 구현 이후: 등록버튼 누를 때 전역변수 모두 초기화 */

import UIKit
import SnapKit
import QuartzCore

class CreatePartyViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - SubViews
    
    // 스크롤뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    // 콘텐츠뷰
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    /* 우측 상단 다음 버튼 */
    var deactivatedRightBarButtonItem: UIBarButtonItem = {
        let registerButton = UIButton()
        registerButton.setTitle("다음", for: .normal)
        registerButton.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        let barButton = UIBarButtonItem(customView: registerButton)
        barButton.isEnabled = false
        return barButton
    }()
    
    /* 타이틀 위 같이 먹고 싶고 싶어요 버튼 */
    lazy var eatTogetherButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = UIColor(hex: 0xD8D8D8)
        button.setTitle("  같이 먹고 싶어요", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 13)
        button.addTarget(self, action: #selector(tapEatTogetherButton), for: .touchUpInside)
        return button
    }()
    
    /* 타이틀 텍스트 필드 */
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xA8A8A8)]
        )
        textField.font = .customFont(.neoMedium, size: 20)
        textField.textColor = .black
        
        // backgroundColor를 설정해 줬더니 borderStyle의 roundRect이 적용되지 않아서 따로 layer를 custom함
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: 0xEFEFEF).cgColor
        
        // placeholder와 layer 사이에 간격 설정
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        
        textField.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        return textField
    }()
    
    /* 내용 텍스트 필드 */
    var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = .customFont(.neoRegular, size: 15)
        textView.refreshControl?.contentVerticalAlignment = .top
        textView.text = "내용을 입력하세요"
        textView.textColor = UIColor(hex: 0xD8D8D8)
        return textView
    }()
    
    /* 구분선 */
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    /* Option labels */
    var orderForecastTimeLabel = UILabel()
    var matchingPersonLabel = UILabel()
    var categoryLabel = UILabel()
    var urlLabel = UILabel()
    var locationLabel = UILabel()
    
    /* selected Button & labels */
    lazy var orderForecastTimeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .customFont(.neoRegular, size: 13)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.setActivatedButton()
        button.addTarget(self, action: #selector(tapOrderForecastTimeButton), for: .touchUpInside)
        return button
    }()
        
    var selectedPersonLabel = UILabel()
    var selectedCategoryLabel = UILabel()
    var selectedUrlLabel = UILabel()
    var selectedLocationLabel = UILabel()
    
    let mapSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let blockedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    /* 서브뷰 나타났을 때 뒤에 블러뷰 */
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    var isSettedOptions = false // 옵션이 모두 설정되었는지
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
    var dormitoryInfo: DormitoryNameResult?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /* 기숙사 좌표 불러오기 */
        LocationAPI.getLocation(dormitoryInfo?.id ?? 1)
        
        setAttributeOfOptionLabel()
        setAttributeOfSelectedLabel()
        setDelegate()
        setNavigationBar()
        setDefaultDate()
        setNotificationCenter()
        setTapGestureToLabels()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("파티생성 뷰 윌 디스어피어 호출")
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapConfirmButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapBackButtonFromBankAccountVC"), object: nil)
        mapView = nil // 맵뷰 초기화
        
        // 전역변수 초기화
        CreateParty.orderForecastTime = nil
        CreateParty.matchingPerson = nil
        CreateParty.category = nil
        CreateParty.url = nil
        CreateParty.address = nil
        CreateParty.latitude = nil
        CreateParty.longitude = nil
        CreateParty.bank = nil
        CreateParty.accountNumber = nil
        CreateParty.chatRoomName = nil
    }
    
    // MARK: - Functions
    
    private func setMapView() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
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
    
    @objc
    private func tapContentView() {
        view.endEditing(true)
        
        // 다음 버튼 누른 VC에 대한 데이터 저장, 표시
        if let orderForecastTime = CreateParty.orderForecastTime {
            self.orderForecastTimeButton.layer.shadowRadius = 0
            self.orderForecastTimeButton.setTitle("      \(orderForecastTime)", for: .normal)
            self.orderForecastTimeButton.titleLabel?.font = .customFont(.neoMedium, size: 13)
            self.orderForecastTimeButton.backgroundColor = UIColor(hex: 0xF8F8F8)
            self.orderForecastTimeButton.setTitleColor(.black, for: .normal)
        }
        
        if let matchingPerson = CreateParty.matchingPerson {
            self.selectedPersonLabel.text = "      \(matchingPerson)"
            self.selectedPersonLabel.font = .customFont(.neoMedium, size: 13)
            self.selectedPersonLabel.textColor = .black
            self.selectedPersonLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        
        if let url = CreateParty.url {
            self.selectedUrlLabel.text = "      \(url)"
            self.selectedUrlLabel.font = .customFont(.neoMedium, size: 13)
            self.selectedUrlLabel.textColor = .black
            self.selectedUrlLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        
        if let category = CreateParty.category {
            self.selectedCategoryLabel.text = "      \(category)"
            self.selectedCategoryLabel.font = .customFont(.neoMedium, size: 13)
            self.selectedCategoryLabel.textColor = .black
            self.selectedCategoryLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        
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
            $0.font = .customFont(.neoRegular, size: 13)
            $0.textColor = UIColor(hex: 0xD8D8D8)
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 3
        }
        selectedPersonLabel.text = "      0/0"
        selectedCategoryLabel.text = "      한식"
        selectedUrlLabel.text = "      url"
        selectedLocationLabel.text = "      제1기숙사 정문"
    }
    
    private func setDelegate() {
        scrollView.delegate = self
        contentsTextView.delegate = self
        titleTextField.delegate = self
    }
    
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
        self.navigationItem.title = "파티 생성하기"
        self.navigationItem.titleView?.tintColor = .init(hex: 0x2F2F2F)
        
        // set barButtonItem
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(tapBackButton(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("TapConfirmButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                // 각 서브뷰에서 저장된 전역변수 데이터 출력
                if let orderForecastTime = CreateParty.orderForecastTime {
                    self.orderForecastTimeButton.layer.shadowRadius = 0
                    self.orderForecastTimeButton.setTitle("      \(orderForecastTime)", for: .normal)
                    self.orderForecastTimeButton.titleLabel?.font = .customFont(.neoMedium, size: 13)
                    self.orderForecastTimeButton.backgroundColor = UIColor(hex: 0xF8F8F8)
                    self.orderForecastTimeButton.setTitleColor(.black, for: .normal)
                }
                
                if let matchingPerson = CreateParty.matchingPerson {
                    self.selectedPersonLabel.text = "      \(matchingPerson)"
                    self.selectedPersonLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedPersonLabel.textColor = .black
                    self.selectedPersonLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                if let category = CreateParty.category {
                    self.selectedCategoryLabel.text = "      \(category)"
                    self.selectedCategoryLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedCategoryLabel.textColor = .black
                    self.selectedCategoryLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                if let url = CreateParty.url {
                    self.selectedUrlLabel.text = "      \(url)"
                    self.selectedUrlLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedUrlLabel.textColor = .black
                    self.selectedUrlLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                if let address = CreateParty.address {
                    self.selectedLocationLabel.text = "      \(address)"
                    self.selectedLocationLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedLocationLabel.textColor = .black
                    self.selectedLocationLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                // 좌표가 있으면 기존의 blockedView를 없애고 그 자리에 카카오맵 노출
                if let _ = CreateParty.latitude,
                   let _ = CreateParty.longitude {
                    self.blockedView.removeFromSuperview()
                    self.setMapView()
                }
                
                // Blur View 제거
                self.visualEffectView?.removeFromSuperview()
                
                // subVC 제거
                let viewControllers = self.children
                viewControllers.forEach {
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
                
                self.isSettedOptions = true
                if self.titleTextField.text?.count ?? 0 >= 1 && self.contentsTextView.text.count >= 1 {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.tapRegisterButton))
                    self.navigationItem.rightBarButtonItem?.tintColor = .mainColor
                    self.view.layoutSubviews()
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapBackButtonFromBankAccountVC"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                self.visualEffectView?.removeFromSuperview()
            }
        }
        
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [eatTogetherButton, titleTextField, contentsTextView, separateView,
         orderForecastTimeLabel, matchingPersonLabel, categoryLabel, urlLabel, locationLabel,
         orderForecastTimeButton, selectedPersonLabel, selectedCategoryLabel, selectedUrlLabel, selectedLocationLabel,
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
        
        blockedView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(selectedLocationLabel.snp.bottom).offset(16)
            make.width.equalTo(314)
            make.height.equalTo(144)
        }
    }
    
    /* 현재 날짜와 시간을 orderForecastTimeButton에 출력 */
    private func setDefaultDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "      MM월 dd일        HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        orderForecastTimeButton.setTitle(formatter.string(from: Date()), for: .normal)
    }
    
    private func createBlueView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        visualEffectView.isUserInteractionEnabled = false
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    /* 이전 화면으로 돌아가기 */
    @objc
    private func tapBackButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc
    private func tapEatTogetherButton() {
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
    
    /* show 주문 예정 시간 VC */
    @objc
    private func tapOrderForecastTimeButton() {
        view.endEditing(true)
        createBlueView()
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = OrderForecastTimeViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func changeValueTitleTextField() {
        // isSettedOptions가 true인데 titleTextField가 지워진 경우
        if isSettedOptions
            && isEditedContentsTextView
            && contentsTextView.text.count >= 1
            && titleTextField.text?.count ?? 0 >= 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.tapRegisterButton))
            self.navigationItem.rightBarButtonItem?.tintColor = .mainColor
            self.view.layoutSubviews()
        } else if (isEditedContentsTextView && isSettedOptions && titleTextField.text?.count ?? 0 < 1)
                    || (isEditedContentsTextView && isSettedOptions && contentsTextView.text.count < 1) {
            self.navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
            self.view.layoutSubviews()
        }
    }
    
    @objc
    private func tapSelectedPersonLabel() {
        createBlueView()
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = OrderForecastTimeViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let matchingPersonVC = MatchingPersonViewController()
            self.addChild(matchingPersonVC)
            self.view.addSubview(matchingPersonVC.view)
            matchingPersonVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }

    @objc
    private func tapSelectedCategoryLabel() {
        createBlueView()
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = OrderForecastTimeViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let matchingPersonVC = MatchingPersonViewController()
            self.addChild(matchingPersonVC)
            self.view.addSubview(matchingPersonVC.view)
            matchingPersonVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let categoryVC = CategoryViewController()
            self.addChild(categoryVC)
            self.view.addSubview(categoryVC.view)
            categoryVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapSelectedUrlLabel() {
        createBlueView()
        // selectedUrlLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = OrderForecastTimeViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let matchingPersonVC = MatchingPersonViewController()
            self.addChild(matchingPersonVC)
            self.view.addSubview(matchingPersonVC.view)
            matchingPersonVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let categoryVC = CategoryViewController()
            self.addChild(categoryVC)
            self.view.addSubview(categoryVC.view)
            categoryVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let urlVC = UrlViewController()
            self.addChild(urlVC)
            self.view.addSubview(urlVC.view)
            urlVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapSelectedLocationLabel() {
        createBlueView()
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC, UrlVC,receiptPlaceVC 띄우기
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let orderForecastTimeVC = OrderForecastTimeViewController()
            self.addChild(orderForecastTimeVC)
            self.view.addSubview(orderForecastTimeVC.view)
            orderForecastTimeVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let matchingPersonVC = MatchingPersonViewController()
            self.addChild(matchingPersonVC)
            self.view.addSubview(matchingPersonVC.view)
            matchingPersonVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let categoryVC = CategoryViewController()
            self.addChild(categoryVC)
            self.view.addSubview(categoryVC.view)
            categoryVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let urlVC = UrlViewController()
            self.addChild(urlVC)
            self.view.addSubview(urlVC.view)
            urlVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let receiptPlaceVC = ReceiptPlaceViewController()
            self.addChild(receiptPlaceVC)
            self.view.addSubview(receiptPlaceVC.view)
            receiptPlaceVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapRegisterButton() {
        if let title = titleTextField.text,
           let content = contentsTextView.text {
            CreateParty.title = title
            CreateParty.content = content
        }
        
        view.endEditing(true)
        createBlueView()
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = BankAccountViewController()
            childView.dormitoryInfo = self.dormitoryInfo
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
}

extension CreatePartyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text else { return true }
        let newLength = str.count + string.count - range.length
        
        return newLength <= 20
    }
}

extension CreatePartyViewController: UITextViewDelegate {
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
        if isSettedOptions
            && isEditedContentsTextView
            && contentsTextView.text.count >= 1
            && titleTextField.text?.count ?? 0 >= 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(tapRegisterButton))
            navigationItem.rightBarButtonItem?.tintColor = .mainColor
            view.layoutSubviews()
        } else if (isEditedContentsTextView && isSettedOptions && contentsTextView.text.count < 1)
                    || (isEditedContentsTextView && isSettedOptions && titleTextField.text?.count ?? 0 < 1) {
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

extension CreatePartyViewController: MTMapViewDelegate {

}

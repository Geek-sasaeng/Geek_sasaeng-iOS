//
//  CreatePartyVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/11.
//

import UIKit
import SnapKit
import QuartzCore
import Then
import NMapsMap

class CreatePartyViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var isSettedOptions = false // 옵션이 모두 설정되었는지
    var isEditedContentsTextView = false // 내용이 수정되었는지
    
    var dormitoryInfo: DormitoryNameResult?
    var delegate: UpdateDeliveryDelegate?
    
    /* 네이버 지도 마커 */
    var naverMarker = NMFMarker()

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
    
    /* 우측 상단 다음 버튼 */
    var deactivatedRightBarButtonItem = UIBarButtonItem().then {
        let registerButton = UIButton().then {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        }
//        let barButton = UIBarButtonItem(customView: registerButton)
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
        $0.textColor = UIColor(hex: 0xD8D8D8)
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
        $0.titleLabel?.font = .customFont(.neoRegular, size: 13)
        $0.contentHorizontalAlignment = .left
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.setActivatedButton()
        $0.addTarget(self, action: #selector(tapOrderForecastTimeButton), for: .touchUpInside)
    }
        
    var selectedPersonLabel = UILabel()
    var selectedCategoryLabel = UILabel()
    var selectedUrlLabel = UILabel()
    var selectedLocationLabel = UILabel()
    
    /* 서브뷰 나타났을 때 뒤에 블러뷰 */
    var visualEffectView: UIVisualEffectView?
    
    /* 네이버 지도 */
    let naverMapView = NMFNaverMapView().then {
        $0.isUserInteractionEnabled = false
        $0.showZoomControls = false
        $0.showLocationButton = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributeOfOptionLabel()
        setAttributeOfSelectedLabel()
        setDelegate()
        setNavigationBar()
        setDefaultDate()
        setNotificationCenter()
        setTapGestureToLabels()
        addSubViews()
        setLayouts()
        setMapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapConfirmButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TapBackButtonFromBankAccountVC"), object: nil)
        
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
        MyLoadingView.shared.show()
        /* 기숙사 좌표 불러오기 */
        LocationAPI.getLocation(dormitoryInfo?.id ?? 1) { isSuccess in
            MyLoadingView.shared.hide()
            
            if isSuccess {
                /* 수령 장소로 지도 카메라 이동, 마커 표시 */
                if let latitude = CreateParty.latitude,
                   let longitude = CreateParty.longitude {
                    print("기숙사 좌표 불러오기 성공, 좌표: ", latitude, longitude)
                    self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)))
                    
                    self.naverMarker.position = NMGLatLng(lat: latitude, lng: longitude)
                    self.naverMarker.captionText = CreateParty.address ?? "요기?"
                    self.naverMarker.captionAligns = [NMFAlignType.top]
                    self.naverMarker.mapView = self.naverMapView.mapView
                }
            }
        }
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
        setLabelsData()
        
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
        children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        selectedUrlLabel.isUserInteractionEnabled = true
        selectedLocationLabel.isUserInteractionEnabled = true
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
                self.setLabelsData()

                /* 수령 장소로 지도 카메라 이동, 마커 표시 */
                if let latitude = CreateParty.latitude,
                   let longitude = CreateParty.longitude {
                    print("기숙사 좌표 불러오기 성공, 좌표: ", latitude, longitude)
                    self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)))
                    
                    self.naverMarker.position = NMGLatLng(lat: latitude, lng: longitude)
                    self.naverMarker.captionText = CreateParty.address ?? "요기?"
                    self.naverMarker.captionAligns = [NMFAlignType.top]
                    self.naverMarker.mapView = self.naverMapView.mapView
                }
                
                // Blur View 제거
                self.visualEffectView?.removeFromSuperview()
                self.visualEffectView = nil
                
                // subVC 제거
                let viewControllers = self.children
                viewControllers.forEach {
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
                self.selectedLocationLabel.isUserInteractionEnabled = true
                
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
                self.visualEffectView = nil
            }
        }
        
    }
    
    private func setLabelsData() {
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
        
        if let address = CreateParty.address {
            self.selectedLocationLabel.text = "      \(address)"
            self.selectedLocationLabel.font = .customFont(.neoMedium, size: 13)
            self.selectedLocationLabel.textColor = .black
            self.selectedLocationLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [eatTogetherButton, titleTextField, contentsTextView, separateView,
         orderForecastTimeLabel, matchingPersonLabel, categoryLabel, urlLabel, locationLabel,
         orderForecastTimeButton, selectedPersonLabel, selectedCategoryLabel, selectedUrlLabel, selectedLocationLabel,
         naverMapView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screenWidth)
        }
        
        // 컨텐츠뷰
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
            make.height.equalTo(screenHeight)
        }
        
        eatTogetherButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(screenHeight / 23.02)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(eatTogetherButton.snp.bottom).offset(screenHeight / 77.45)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.width.equalTo(screenWidth / 1.25)
            make.height.equalTo(screenHeight / 18.93)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(screenHeight / 53.25)
            make.left.equalToSuperview().inset(screenWidth / 10.34)
            make.width.equalTo(screenWidth / 1.33)
            make.height.equalTo(screenHeight / 5.42)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(screenHeight / 53.25)
            make.height.equalTo(screenHeight / 106.5)
            make.width.equalToSuperview()
        }
        
        orderForecastTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(screenHeight / 27.48)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        matchingPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeLabel.snp.bottom).offset(screenHeight / 22.42)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(matchingPersonLabel.snp.bottom).offset(screenHeight / 22.42)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(screenHeight / 22.42)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(screenHeight / 22.42)
            make.left.equalToSuperview().inset(screenWidth / 14.03)
        }
        
        orderForecastTimeButton.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(screenHeight / 42.6)
            make.left.equalTo(orderForecastTimeLabel.snp.right).offset(screenWidth / 8.73)
            make.width.equalTo(screenWidth / 2.09)
            make.height.equalTo(screenHeight / 22.42)
        }
        
        selectedPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeButton.snp.bottom).offset(screenHeight / 53.25)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(screenWidth / 2.09)
            make.height.equalTo(screenHeight / 22.42)
        }
        
        selectedCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedPersonLabel.snp.bottom).offset(screenHeight / 53.25)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(screenWidth / 2.09)
            make.height.equalTo(screenHeight / 22.42)
        }
        
        selectedUrlLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedCategoryLabel.snp.bottom).offset(screenHeight / 53.25)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(screenWidth / 2.09)
            make.height.equalTo(screenHeight / 22.42)
        }
        
        selectedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedUrlLabel.snp.bottom).offset(screenHeight / 53.25)
            make.left.equalTo(orderForecastTimeButton.snp.left)
            make.width.equalTo(screenWidth / 2.09)
            make.height.equalTo(screenHeight / 22.42)
        }
        
        naverMapView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(selectedLocationLabel.snp.bottom).offset(screenHeight / 53.25)
            make.left.right.equalToSuperview().inset(screenWidth / 17.08)
            make.height.equalTo(screenHeight / 4.15)
        }
    }
    
    /* 현재 날짜와 시간을 orderForecastTimeButton에 출력 */
    private func setDefaultDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "      MM월 dd일        HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        orderForecastTimeButton.setTitle(formatter.string(from: Date()), for: .normal)
    }
    
    private func createBlurView() {
        if visualEffectView == nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            visualEffectView.layer.opacity = 0.6
            visualEffectView.frame = view.frame
            visualEffectView.isUserInteractionEnabled = false
            view.addSubview(visualEffectView)
            self.visualEffectView = visualEffectView
        }
    }
    
    /* 이전 화면으로 돌아가기 */
    @objc
    private func tapBackButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    /* 함께 먹어요 버튼 */
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
    
    /* 화면에 서브뷰 띄우는 함수 */
    private func addOrderForecastTimeVC() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = OrderForecastTimeViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    private func addMatchingPersonVC() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let matchingPersonVC = MatchingPersonViewController()
            self.addChild(matchingPersonVC)
            self.view.addSubview(matchingPersonVC.view)
            matchingPersonVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    private func addCategoryVC() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let categoryVC = CategoryViewController()
            self.addChild(categoryVC)
            self.view.addSubview(categoryVC.view)
            categoryVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    private func addUrlVC() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let urlVC = UrlViewController()
            self.addChild(urlVC)
            self.view.addSubview(urlVC.view)
            urlVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    private func addReceiptPlaceVC() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let receiptPlaceVC = ReceiptPlaceViewController()
            self.addChild(receiptPlaceVC)
            self.view.addSubview(receiptPlaceVC.view)
            receiptPlaceVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    /* 각 버튼을 탭했을 때 서브뷰 띄우는 함수 호출 */
    @objc
    private func tapOrderForecastTimeButton() {
        view.endEditing(true)
        createBlurView()
        selectedLocationLabel.isUserInteractionEnabled = false
        
        // addSubview animation 처리
        addOrderForecastTimeVC()
    }
    @objc
    private func tapSelectedPersonLabel() {
        createBlurView()
        selectedLocationLabel.isUserInteractionEnabled = false
        
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC 띄우기
        addOrderForecastTimeVC()
        addMatchingPersonVC()
    }
    @objc
    private func tapSelectedCategoryLabel() {
        createBlurView()
        selectedLocationLabel.isUserInteractionEnabled = false
        
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC 띄우기
        addOrderForecastTimeVC()
        addMatchingPersonVC()
        addCategoryVC()
    }
    @objc
    private func tapSelectedUrlLabel() {
        createBlurView()
        selectedLocationLabel.isUserInteractionEnabled = false
        
        // selectedUrlLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC, urlVC 띄우기
        addOrderForecastTimeVC()
        addMatchingPersonVC()
        addCategoryVC()
        addUrlVC()
    }
    @objc
    private func tapSelectedLocationLabel() {
        createBlurView()
        
        // selectedPersonLabel 탭 -> orderForecastTimeVC, matchingPersonVC, categoryVC, UrlVC, receiptPlaceVC 띄우기
        addOrderForecastTimeVC()
        addMatchingPersonVC()
        addCategoryVC()
        addUrlVC()
        addReceiptPlaceVC()
    }
    
    /* 조건을 만족 했을 때 우측 상단 다음 버튼 활성화 */
    @objc
    private func changeValueTitleTextField() {
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
    
    /* 파티 생성 버튼 */
    @objc
    private func tapRegisterButton() {
        if let title = titleTextField.text,
           let content = contentsTextView.text {
            CreateParty.title = title
            CreateParty.content = content
        }
        
        view.endEditing(true)
        createBlurView()
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = BankAccountViewController()
            childView.dormitoryInfo = self.dormitoryInfo
            childView.delegate = self.delegate
            self.selectedUrlLabel.isUserInteractionEnabled = false
            self.selectedLocationLabel.isUserInteractionEnabled = false
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

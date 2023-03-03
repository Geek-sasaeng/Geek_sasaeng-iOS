//
//  PartyVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit

import CoreLocation
import SnapKit
import Then
import NMapsMap
import Kingfisher

class PartyViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var partyId: Int?
    var detailData = DeliveryListDetailModelResult()
    var dormitoryInfo: DormitoryNameResult? // dormitory id, name
    var chatRoomName: String?
    var isFromCreated: Bool?    // 파티 생성 후 바로 상세보기로 온 건지 여부
    var isEnded: Bool?      // 종료된 파티인 건지 여부 -> 나의 활동 목록에서 여기로 넘어왔을 경우에 해당
    
    // 남은 시간 1초마다 구해줄 타이머
    var timer: DispatchSourceTimer?
    
    // MARK: - Subviews
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // 신청하기 뷰가 들어갈 뷰 -> 신청하기 뷰를 탭바 위에 고정시켜 놓기 위해 필요!
    let containerView = UIView().then {
        $0.backgroundColor = .none
    }
    
    /* 배경 블러 처리를 위해 추가한 visualEffectView */
    var visualEffectView: UIVisualEffectView?
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
    }
    
    let stageLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .customFont(.neoBold, size: 13)
    }
    
    let nickNameLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoBold, size: 13)
    }
    
    let postingTimeLabel = UILabel().then {
        $0.font = .customFont(.neoRegular, size: 11)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    
    let hashTagLabel = UILabel().then {
        $0.text = "# 같이 먹고 싶어요"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    
    let titleLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 20)
        $0.textColor = .black
    }
    
    let contentLabel = UILabel().then {
        $0.font = .customFont(.neoLight, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.numberOfLines = 0
    }
    
    let separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }

    let orderLabel = UILabel().then {
        $0.text = "주문 예정 시간"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    let orderReserveLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    let matchingLabel = UILabel().then {
        $0.text = "매칭 현황"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    let matchingDataLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    let categoryDataLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    let storeLinkLabel = UILabel().then {
        $0.text = "식당 링크"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    let storeLinkDataLabel = UILabel().then {
        $0.text = "???"
        $0.numberOfLines = 1
        $0.lineBreakMode = .byCharWrapping
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    let pickupLocationLabel = UILabel().then {
        $0.text = "수령 장소"
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    let pickupLocationDataLabel = UILabel().then {
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.font = .customFont(.neoMedium, size: 13)
    }
    
    let matchingStatusView = UIView().then {
        $0.backgroundColor = .mainColor
    }
    
    let matchingDataWhiteLabel = UILabel().then {
        $0.font = UIFont.customFont(.neoMedium, size: 16)
        $0.textColor = .white
    }
    
    let remainTimeLabel = UILabel().then {
        $0.font = UIFont.customFont(.neoMedium, size: 16)
        $0.textColor = .white
    }
    
    lazy var signUpButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 16)
        $0.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
    }
    
    let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "Arrow")
    }
    
    lazy var deleteView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.53)
            make.height.equalTo(screenHeight / 4.21)
        }
        
        /* top View: 삭제하기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(screenHeight / 17.04)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "삭제하기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoRegular, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.tintColor = UIColor(hex: 0x5B5B5B)
        cancelButton.addTarget(self, action: #selector(removeDeleteView), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(screenWidth / 19.65)
            make.height.equalTo(screenHeight / 71)
            make.right.equalToSuperview().offset(-(screenWidth / 26.2))
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 5.6)
            make.top.equalTo(topSubView.snp.bottom)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "이 배달 파티가 삭제됩니다.\n계속할까요?"
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .customFont(.neoRegular, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 2.23)
            make.height.equalTo(screenHeight / 17.75)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(screenHeight / 42.6)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(screenHeight / 56.8)
            make.left.right.equalToSuperview().inset(screenWidth / 21.83)
            make.height.equalTo(screenHeight / 501.17)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapDeleteConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(screenHeight / 47.33)
            make.width.height.equalTo(34)
        }
    }
    
    /* 신청하기 누르면 나오는 신청하기 Alert 뷰 */
    lazy var registerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        $0.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.53)
            make.height.equalTo(screenHeight / 4.78)
        }
        
        /* top View: 파티 신청하기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(screenHeight / 17.04)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "파티 신청하기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoMedium, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(removeRegisterView), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(screenWidth / 19.65)
            make.height.equalTo(screenHeight / 71)
            make.right.equalToSuperview().offset(-(screenWidth / 26.2))
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 6.65)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "파티에 참여해볼까요?"
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .init(hex: 0x2F2F2F)
        contentLabel.font = .customFont(.neoMedium, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(screenHeight / 42.6)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(screenHeight / 53.25)
            make.left.right.equalToSuperview().inset(screenWidth / 21.83)
            make.height.equalTo(screenHeight / 501.176)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapRegisterConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(screenHeight / 47.33)
            make.width.height.equalTo(34)
        }
    }
    
    lazy var toastView: UIView? = nil
    
    // 배달파티에서 나간 파티원은 같은 파티에 다시 참여할 수 없어요. 안내뷰
    lazy var exitedGuideView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        $0.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(202)
        }
        
        /* top View: 안내 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "안내"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoMedium, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.tintColor = UIColor(hex: 0x5B5B5B)
        cancelButton.addTarget(self, action: #selector(tapGoMainButton), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(152)
            make.top.equalTo(topSubView.snp.bottom)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "배달파티에서 나간 파티원은\n같은 파티에 다시 참여할 수 없어요."
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .init(hex: 0x2F2F2F)
        contentLabel.font = .customFont(.neoMedium, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.36
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(206)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1.7)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("메인으로 돌아가기", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapGoMainButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.equalTo(137)
            make.height.equalTo(31)
        }
    }
    
    /* 네이버 지도 */
    let naverMapView = NMFNaverMapView().then {
        $0.isUserInteractionEnabled = true
        $0.showLocationButton = false
        $0.showZoomControls = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    
    // MARK: - Properties
    /* 네이버 지도 마커 */
    var naverMarker = NMFMarker()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        getDetailData()
        setAttributes()
        startTimer()
        showToastFromCreated()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditCompleteButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                print("수정 완료 버튼이 눌렸당")
                self.getDetailData()
            }
        }
        
        // 종료된 파티이면
        if isEnded! {
            // 파란바 없애기
            matchingStatusView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이 뷰가 보여지면 네비게이션바를 나타나게 해야한다
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Initialization
    
    convenience init(partyId: Int, dormitoryInfo: DormitoryNameResult? = nil, isFromCreated: Bool? = nil, isEnded: Bool? = false) {
        self.init()
        self.partyId = partyId
        self.dormitoryInfo = dormitoryInfo
        self.isFromCreated = isFromCreated
        self.isEnded = isEnded
    }
    
    // MARK: - Functions
    
    /*
     파티 상세보기의 데이터를 가져온다.
     1. 파티 생성 후 바로 그 파티의 상세보기를 보여주는 경우
     2. 배달파티 목록에서 클릭한 파티의 상세보기로 오는 경우
     */
    private func getDetailData() {
        MyLoadingView.shared.show()
        if let partyId = partyId {
            DeliveryListDetailViewModel.getDetailInfo(partyId: partyId, completion: { [weak self] result, message in
                MyLoadingView.shared.hide()
                
                if let result = result {
                    // detailData에 데이터 넣기
                    if let self = self {
                        self.detailData = result
                        self.setDetailData()
                        
                        print("hashTag: ", result.hashTag!)
                        if !result.hashTag! { // 같이 먹어요 없을 때 제목 레이아웃 조정
                            print("같이 안 먹어요에 해당")
                            DispatchQueue.main.async {
                                self.titleLabel.snp.remakeConstraints { make in
                                    make.left.equalToSuperview().inset(self.screenWidth / 16.375)
                                    make.top.equalTo(self.nickNameLabel.snp.bottom).offset(self.screenHeight / 34.08)
                                }
                            }
                        }
                        
                        // belongStatus가 Y인데 activeStatus가 false => 나간 방장 또는 파티원
                        if self.detailData.belongStatus == "Y" && self.detailData.activeStatus == false {
                            self.showExitedGuideView()
                            // rightBarButtonItem(옵션탭) 비활성화
                            self.navigationItem.rightBarButtonItem?.isEnabled = false
                        }
                    }
                } else {
                    print("DEBUG: 파티 상세 조회 실패")
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    /* 상세보기 데이터 세팅 */
    private func setDetailData() {
        // partyEdit 고려하여 전역에 데이터 넣기 -> edit API 호출 시 nil 값 방지
        switch detailData.foodCategory {
        case "한식": CreateParty.foodCategory = 1
        case "양식": CreateParty.foodCategory = 2
        case "중식": CreateParty.foodCategory = 3
        case "일식": CreateParty.foodCategory = 4
        case "분식": CreateParty.foodCategory = 5
        case "치킨/피자": CreateParty.foodCategory = 6
        case "회/돈까스": CreateParty.foodCategory = 7
        case "패스트 푸드": CreateParty.foodCategory = 8
        case "디저트/음료": CreateParty.foodCategory = 9
        case "기타": CreateParty.foodCategory = 10
        default: print("잘못된 카테고리입니다.")
        }
        
        CreateParty.orderTime = detailData.orderTime
        CreateParty.maxMatching = detailData.maxMatching
        CreateParty.url = detailData.storeUrl
        CreateParty.latitude = detailData.latitude
        CreateParty.longitude = detailData.longitude
        CreateParty.hashTag = detailData.hashTag
        
        self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: detailData.latitude!, lng: detailData.longitude!)))
        self.naverMarker.position = NMGLatLng(lat: detailData.latitude!, lng: detailData.longitude!)
        self.naverMarker.captionAligns = [NMFAlignType.top]
        self.naverMarker.mapView = self.naverMapView.mapView
        
        setDefaultValue()
        
        guard let belongStatus = self.detailData.belongStatus else { return }
        guard let activeStatus = self.detailData.activeStatus else { return }
        print("DEBUG: belongStatus, activeStatus", belongStatus, activeStatus)
        print("방장인가", self.detailData.authorStatus as Any)
        
        // belongStatus Y activeStatus true -> 방에 들어와 있는 상태
        if belongStatus == "Y" && activeStatus {
            self.signUpButton.setTitle("채팅방 가기", for: .normal)
        } else {
            self.signUpButton.setTitle("신청하기", for: .normal)
        }
    }
                                                          
    
    private func setDefaultValue() {
        let url = URL(string: detailData.chiefProfileImgUrl!)
        profileImageView.kf.setImage(with: url)
        nickNameLabel.text = detailData.chief
        stageLabel.text = detailData.chiefGrade
        contentLabel.text = detailData.content
        matchingDataLabel.text = "\(detailData.currentMatching!)/\(detailData.maxMatching!)"
        matchingDataWhiteLabel.text = "\(detailData.currentMatching!)/\(detailData.maxMatching!) 명"
        categoryDataLabel.text = detailData.foodCategory
        storeLinkDataLabel.text = (detailData.storeUrl == "null") ? "???" : detailData.storeUrl
        if detailData.hashTag ?? false {
            hashTagLabel.isHidden = false
        } else {
            hashTagLabel.isHidden = true
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
        orderReserveLabel.text = "\(dateStr)      \(timeStr)"
        titleLabel.text = detailData.title
        
        postingTimeLabel.text = detailData.updatedAt?.formatToMMddHHmm()
        
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
                    self.pickupLocationDataLabel.text = "\(administrativeArea) \(locality) \(name)"
                }
            }
        }
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.view.addSubview(containerView)
        self.containerView.addSubview(matchingStatusView)
        
        [
            profileImageView, stageLabel, nickNameLabel, postingTimeLabel,
            hashTagLabel,
            titleLabel, contentLabel,
            separateView,
            orderLabel, matchingLabel, categoryLabel, storeLinkLabel, pickupLocationLabel,
            orderReserveLabel, matchingDataLabel, categoryDataLabel, storeLinkDataLabel, pickupLocationDataLabel,
            naverMapView
        ].forEach { contentView.addSubview($0) }
        [
            matchingDataWhiteLabel,
            remainTimeLabel,
            signUpButton,
            arrowImageView
        ].forEach { matchingStatusView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screenWidth)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(naverMapView.snp.bottom).offset(screenHeight / 11.36)
        }
        
        // 신청하기 뷰를 고정시켜 놓을 컨테이너 뷰
        containerView.snp.makeConstraints { make in
            make.bottom.width.equalToSuperview()
            // 컨테이너뷰 높이 = 탭바 높이 + 매칭 상태바 높이
            if let tabBarCont = tabBarController {
                make.height.equalTo(tabBarCont.tabBar.bounds.height + (screenHeight / 15.49))
            }
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(screenHeight / 42.6)
            make.left.equalToSuperview().inset(screenWidth / 17.08)
            make.width.height.equalTo(screenWidth / 15.11)
        }
        
        stageLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(screenWidth / 49.12)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(stageLabel.snp.right).offset(screenWidth / 78.6)
            make.centerY.equalTo(stageLabel.snp.centerY)
        }
        
        postingTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(screenWidth / 17.08)
            make.centerY.equalTo(nickNameLabel.snp.centerY)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 16.37)
            make.top.equalTo(profileImageView.snp.bottom).offset(screenHeight / 38.72)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 16.375)
            make.top.equalTo(hashTagLabel.snp.bottom).offset(screenHeight / 94.66)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(screenWidth / 17.08)
            make.top.equalTo(titleLabel.snp.bottom).offset(screenHeight / 60.85)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(screenHeight / 25.05)
            make.height.equalTo(screenHeight / 106.5)
            make.width.equalToSuperview()
        }
        
        orderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(separateView.snp.bottom).offset(screenHeight / 27.48)
            make.width.equalTo(screenWidth / 5.03)
        }
        
        matchingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(orderLabel.snp.bottom).offset(screenHeight / 35.5)
            make.width.equalTo(screenWidth / 5.03)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(matchingLabel.snp.bottom).offset(screenHeight / 35.5)
            make.width.equalTo(screenWidth / 5.03)
        }
        
        storeLinkLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(categoryLabel.snp.bottom).offset(screenHeight / 35.5)
            make.width.equalTo(screenWidth / 5.03)
        }
        
        pickupLocationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 14.03)
            make.top.equalTo(storeLinkLabel.snp.bottom).offset(screenHeight / 35.5)
            make.width.equalTo(screenWidth / 5.03)
        }
        
        orderReserveLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(orderLabel.snp.top)
        }
        
        matchingDataLabel.snp.makeConstraints { make in
            make.left.equalTo(orderReserveLabel.snp.left)
            make.top.equalTo(matchingLabel.snp.top)
        }
        
        categoryDataLabel.snp.makeConstraints { make in
            make.left.equalTo(orderReserveLabel.snp.left)
            make.top.equalTo(categoryLabel.snp.top)
        }
        
        storeLinkDataLabel.snp.makeConstraints { make in
            make.left.equalTo(orderReserveLabel.snp.left)
            make.top.equalTo(storeLinkLabel.snp.top)
        }
        
        pickupLocationDataLabel.snp.makeConstraints { make in
            make.left.equalTo(orderReserveLabel.snp.left)
            make.top.equalTo(pickupLocationLabel.snp.top)
        }
        
        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(pickupLocationLabel.snp.bottom).offset(screenHeight / 35.5)
            make.left.right.equalToSuperview().inset(screenWidth / 17.08)
            make.height.equalTo(screenHeight / 4.15)
        }
        
        matchingStatusView.snp.makeConstraints { make in
            // 탭바 높이만큼 떨어뜨려 놓는다
            if let tabBarCont = tabBarController {
                make.bottom.equalToSuperview().inset(tabBarCont.tabBar.bounds.height)
                make.height.equalTo(screenHeight / 15.49)
                make.width.equalToSuperview()
            }
        }
        
        matchingDataWhiteLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(screenWidth / 13.55)
            make.centerY.equalTo(matchingStatusView.snp.centerY)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(matchingDataWhiteLabel.snp.right).offset(screenWidth / 8.73)
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-(screenWidth / 35.72))
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
            make.right.equalToSuperview().inset(screenWidth / 13.55)
        }
        
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "파티 보기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // 종료된 파티가 아닐 때에만 rightBarButton을 옵션 버튼으로 설정
        if !isEnded! {
            navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "EllipsisOption"), style: .plain, target: self, action: #selector(tapEllipsisOption)), animated: true)
            navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
            // rightBarButtonItem의 default 위치에다가 inset을 줘서 위치를 맞춤
            navigationItem.rightBarButtonItem?.imageInsets = .init(top: -3, left: 0, bottom: 0, right: 20)
        }
    }
    
    /* 글쓴이일 경우 액션 시트 띄우기 */
    private func showAuthorActionSheet() {
        // title: 나타낼 alert의 제목, message: title과 함께 나타낼 메세지, preferredStyle: alert 스타일
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // alert 발생 시 나타날 액션 선언 및 추가
        [
            UIAlertAction(title: "수정하기", style: .default, handler: { _ in self.tapEditButton() }),
            UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in self.tapDeleteButton() }),
            UIAlertAction(title: "닫기", style: .cancel)
        ].forEach{ actionSheet.addAction($0) }
        
        // alert 나타내기
        present(actionSheet, animated: true)
    }
    
    /* 글쓴이가 아닌 유저일 경우 액션 시트 띄우기 */
    private func showUserActionSheet() {
        // title: 나타낼 alert의 제목, message: title과 함께 나타낼 메세지, preferredStyle: alert 스타일
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // alert발생시 나타날 액션선언 및 추가
        [
            UIAlertAction(title: "신고하기", style: .default, handler: { _ in self.tapReportButton() }),
            UIAlertAction(title: "닫기", style: .cancel)
        ].forEach{ actionSheet.addAction($0) }
        
        // alert 나타내기
        present(actionSheet, animated: true)
    }
    
    /* 나간 파티원 또는 나간 방장일 경우 안내 뷰 띄우기 */
    private func showExitedGuideView() {
        // 배경을 흐리게, 블러뷰로 설정
        showBlurBackground()
        
        // 안내뷰 띄우기
        view.addSubview(exitedGuideView)
        exitedGuideView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    /* 배경의 블러뷰를 터치하면 띄워진 뷰와 블러뷰가 같이 사라지도록 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if let touch = touches.first, touch.view == self.visualEffectView {
            // view에 addSubview가 된 즉, 현재 띄워져있는 뷰인지 확인
            if deleteView.isDescendant(of: view) {
                removeViewWithBlurView(deleteView)
            } else if registerView.isDescendant(of: view) {
                removeViewWithBlurView(registerView)
            }
        }
    }
    
    /* 남은 시간 변경해줄 타이머 작동 */
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            
            // 서버에서 받은 데이터의 형식대로 날짜 포맷팅
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            
            let nowDate = Date()
            
            guard let orderTime = self.detailData.orderTime else { return }
            let orderDate = formatter.date(from: orderTime)
            if let orderDate = orderDate {
                // (주문 예정 시간 - 현재 시간) 의 값을 초 단위로 받아온다
                var intervalSecs = Int(orderDate.timeIntervalSince(nowDate))
                
                // 1초마다 감소
                intervalSecs -= 1
                
                // 남은 일자를 시간으로 변환하면 몇 시간인지 ex) 2일 -> 48시간
                let hourTime = intervalSecs / 60 / 60
                // 몇 분, 몇 초 남았는지
                let minuteTime = intervalSecs / 60 % 60
                let secondTime = intervalSecs % 60
                
                // 텍스트 변경
                self.remainTimeLabel.text = "\(hourTime):\(minuteTime):\(secondTime)"
                
                if intervalSecs <= 0 {
                    self.timer?.cancel()
                }
            }
        })
        timer?.resume()
    }
    
    private func showCompleteRegisterView() {
        /* 파티 신청 후 채팅방에 초대가 완료 됐을 때 뜨는 뷰 */
        toastView = {
            let view = UIView()
            view.backgroundColor = .init(hex: 0x474747, alpha: 0.6)
            view.layer.cornerRadius = 5;
            view.clipsToBounds  =  true
            
            // 서브뷰들
            let toastLabel: UILabel = {
                let label = UILabel()
                label.text = "파티 채팅방이 생성되었습니다"
                label.textColor = UIColor.white
                label.font = .customFont(.neoMedium, size: 14)
                label.alpha = 1.0
                return label
            }()
            lazy var cancelButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(named: "XmarkWhite"), for: .normal)
                button.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
                return button
            }()
            lazy var goChatButton: UIButton = {
                let button = UIButton()
                button.setTitle("바로가기 >", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font =  .customFont(.neoBold, size: 15)
                button.addTarget(self, action: #selector(tapGoChatButton), for: .touchUpInside)
                return button
            }()
            
            [toastLabel, cancelButton, goChatButton]
                .forEach { view.addSubview($0) }
            toastLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(screenHeight / 35.5)
                make.centerX.equalToSuperview()
            }
            cancelButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(screenHeight / 71)
                make.right.equalToSuperview().inset(screenWidth / 65.5)
                make.width.equalTo(screenWidth / 19.65)
                make.height.equalTo(screenHeight / 56.8)
            }
            goChatButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(toastLabel.snp.bottom).offset(screenHeight / 94.66)
                make.width.equalTo(screenWidth / 5.45)
                make.height.equalTo(screenHeight / 44.84)
            }
            
            return view
        }()
        
        // toastView가 보이게 설정
        view.addSubview(toastView!)
        toastView!.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(screenWidth / 1.59)
            make.height.equalTo(screenHeight / 9.16)
        }
        
        // 3초 뒤에 사라지도록 타이머 설정
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.tapCancelButton()
        })
    }
    
    private func showToastFromCreated() {
        guard let isFromCreated = isFromCreated else { return }
        if isFromCreated {
            self.showToast(viewController: self, message: "파티 생성이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
        }
    }
    
    /* 배경에 블러뷰 띄우기 */
    private func showBlurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    /* 파라미터로 온 뷰와 배경 블러뷰 함께 제거 */
    private func removeViewWithBlurView(_ view: UIView) {
        view.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
    
    // MARK: - @objc Functions
    
    /* Ellipsis Button을 눌렀을 때 동작하는, 액션시트를 나타나게 하는 함수 */
    @objc
    private func tapEllipsisOption() {
        guard let authorStatus = detailData.authorStatus else { return }
        
        // 글쓴이인지 아닌지 확인해서 해당하는 액션시트를 띄운다.
        if authorStatus {
            showAuthorActionSheet()
        } else {
            showUserActionSheet()
        }
    }
    
    /* 액션시트에서 수정하기 버튼 클릭시 실행되는 함수 */
    @objc
    private func tapEditButton() {
        let editPartyVC = EditPartyViewController()
        editPartyVC.dormitoryInfo = dormitoryInfo
        editPartyVC.detailData = detailData
        editPartyVC.isEdittiedDelegate = self
        navigationController?.pushViewController(editPartyVC, animated: true)
    }
        
    /* 신고하기 버튼 눌렀을 때 화면 전환 */
    @objc
    private func tapReportButton() {
        guard let partyId = self.partyId,
              let memberId = self.detailData.chiefId else { return }
        
        let reportVC = ReportViewController()
        
        // 해당 배달파티 id값, 유저 id값 전달
        reportVC.partyId = partyId
        reportVC.memberId = memberId
        
        // 화면 전환 실행
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @objc
    private func tapDeleteButton() {
        // 배경을 흐리게, 블러뷰로 설정
        showBlurBackground()
        
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    @objc
    private func removeDeleteView() {
        removeViewWithBlurView(deleteView)
    }
    
    /* 신청하기 뷰에서 X자 눌렀을 때 실행되는 함수 */
    @objc
    private func removeRegisterView() {
        removeViewWithBlurView(registerView)
    }
    
    /* 삭제하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapDeleteConfirmButton() {
        guard let partyId = partyId else { return }
        // 파티 삭제
        DeletePartyViewModel.deleteParty(partyId: partyId) { success in
            if success {
                // 삭제하기 뷰 없애고
                self.removeDeleteView()
                // 이전화면으로 이동
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /* 배달 파티 신청하기 버튼 눌렀을 때 실행되는 함수 */
    @objc
    private func tapSignUpButton(_ sender: UIButton) {
        // 파티장이라면 채팅방으로 가는 로직을 연결
        if sender.title(for: .normal) == "채팅방 가기" {
            guard let roomId = detailData.partyChatRoomId else { return }
            // 해당 채팅방으로 이동
            let chattingVC = ChattingViewController()
            chattingVC.roomName = self.detailData.title
            chattingVC.roomId = roomId
            self.navigationController?.pushViewController(chattingVC, animated: true)
        } else {
            // 파티장이 아니고, 아직 채팅방에 참여하지 않은 유저라면 신청하는 로직에 연결
            // 배경을 흐리게, 블러뷰로 설정
            showBlurBackground()
            
            /* 신청하기 뷰 보여줌 */
            view.addSubview(registerView)
            registerView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    /* 신청하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapRegisterConfirmButton() {
        guard let partyId = self.partyId else { return }
        MyLoadingView.shared.show()
        
        // 신청하기 뷰 없애고
        removeRegisterView()
        
        // API를 통해 이 유저를 서버의 partyMember에도 추가해 줘야 함
        // 배달 파티 신청하기 API 호출
        PartyAPI.requestJoinParty(JoinPartyInput(partyId: partyId)) { [self] isSuccess in
            print("DEBUG: 배달파티 신청 API 호출")
            MyLoadingView.shared.hide()
            
            // 배달파티 신청 성공
            if isSuccess {
                // 만들어진 배달파티의 채팅방의 멤버로 추가하기
                let input = JoinChatInput(partyChatRoomId: self.detailData.partyChatRoomId)
                ChatAPI.requestJoinChat(input) { [self] isSuccess, result in
                    if isSuccess {
                        print("DEBUG: 채팅방 초대까지 성공", result?.enterTime)
                        showCompleteRegisterView()
                    } else {
                        print("DEBUG: 채팅방 초대 실패", result?.enterTime)
                        // TODO: - 파티에는 추가가 됐는데 채팅방에 추가가 안 됐을 경우 어떻게 처리하면 되는지 확정 안 남
                        showToast(viewController: self, message: "배달파티 채팅방 초대에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .init(hex: 0x474747, alpha: 0.6), width: 250)
                    }
                }
            } else {
                // 배달파티 신청 실패 시 실패 메세지 띄우기
                showToast(viewController: self, message: "배달파티 신청에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .init(hex: 0x474747, alpha: 0.6), width: 250)
            }
        }
    }
    
    /* 채팅방 생성 완료 뷰 X 눌렀을 때 사라지게 하는 함수 */
    @objc
    private func tapCancelButton() {
        // 자연스럽게 사라지게 설정
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.toastView!.alpha = 0.0
        }, completion: {(isCompleted) in
            self.toastView!.removeFromSuperview()
        })
    }
    
    /* 바로가기 눌렀을 때 채팅탭을 보여주는 함수 */
    @objc
    private func tapGoChatButton() {
        print("DEBUG: 채팅탭으로 바로가기")
        // 2번 인덱스인 채팅 탭을 보여준다
        self.tabBarController?.selectedIndex = 2

        // 탭바에 아이템이 있고, 선택된 아이템이 있을 때에만 { } 안을 실행
        if let items = self.tabBarController?.tabBar.items,
           let selectedItem = self.tabBarController?.tabBar.selectedItem {
            // 아이콘 아래 띄울 타이틀 설정
            selectedItem.title = "채팅"

            // 선택된 아이템(채팅)이 아니면 title 값을 제거해준다
            items.forEach {
                if $0 != selectedItem {
                    $0.title = ""
                }
            }
        }
    }
}

// MARK: - EdittedDelegate

extension PartyViewController: EdittedDelegate {
    public func checkEditted(isEditted: Bool) {
        if isEditted {
            self.showToast(viewController: self, message: "수정이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 226)
        }
    }
}

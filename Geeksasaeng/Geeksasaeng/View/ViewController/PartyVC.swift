//
//  PartyVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PartyViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    // 남은 시간 1초마다 구해줄 타이머
    var timer: DispatchSourceTimer?
    // 프로토콜의 함수를 실행하기 위해 delegate를 설정
    var delegate: UpdateDeliveryDelegate?
    // 유저가 초대됐는지 아닌지 여부 확인
    var isInvited: Bool = false
    
    // MARK: - Subviews
    
    // 스크롤뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 신청하기 뷰가 들어갈 뷰 -> 신청하기 뷰를 탭바 위에 고정시켜 놓기 위해 필요!
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }()
    
    /* 글쓴이가 오른쪽 상단의 옵션 탭 눌렀을 때 나오는 옵션 뷰 */
    lazy var optionViewForAuthor: UIView = {
        // 등장 애니메이션을 위해 뷰의 생성 때부터 원점과 크기를 정해놓음
        let view = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.height / 3.8)))
        view.backgroundColor = .white
        
        // 왼쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        /* 옵션뷰에 있는 ellipsis 버튼
         -> 원래 있는 버튼을 안 가리게 & 블러뷰에 해당 안 되게 할 수가 없어서 옵션뷰 위에 따로 추가함 */
        lazy var ellipsisButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "EllipsisOption"), for: .normal)
            button.tintColor = .init(hex: 0x2F2F2F)
            // 옵션뷰 나온 상태에서 ellipsis button 누르면 사라지도록
            button.addTarget(self, action: #selector(tapEllipsisInOptionView), for: .touchUpInside)
            return button
        }()
        view.addSubview(ellipsisButton)
        ellipsisButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(23)
        }
        
        /* 옵션뷰에 있는 버튼 */
        var editButton: UIButton = {
            let button = UIButton()
            button.setTitle("수정하기", for: .normal)
            button.addTarget(self, action: #selector(showEditView), for: .touchUpInside)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            return button
        }()
        var deleteButton: UIButton = {
            let button = UIButton()
            button.setTitle("삭제하기", for: .normal)
            button.addTarget(self, action: #selector(showDeleteView), for: .touchUpInside)
            return button
        }()
        
        [editButton, deleteButton].forEach {
            // attributes
            $0.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            $0.titleLabel?.font =  .customFont(.neoMedium, size: 15)
            
            // layouts
            view.addSubview($0)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(ellipsisButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        return view
    }()
    
    /* (글쓴이가 아닌) 유저가 오른쪽 상단의 옵션 탭 눌렀을 때 나오는 옵션 뷰 */
    lazy var optionView: UIView = {
        // 등장 애니메이션을 위해 뷰의 생성 때부터 원점과 크기를 정해놓음
        let view = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.height / 5.5)))
        view.backgroundColor = .white
        
        // 왼쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        /* 옵션뷰에 있는 ellipsis 버튼
         -> 원래 있는 버튼을 안 가리게 & 블러뷰에 해당 안 되게 할 수가 없어서 옵션뷰 위에 따로 추가함 */
        lazy var ellipsisButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "EllipsisOption"), for: .normal)
            button.tintColor = .init(hex: 0x2F2F2F)
            // 옵션뷰 나온 상태에서 ellipsis button 누르면 사라지도록
            button.addTarget(self, action: #selector(tapEllipsisInOptionView), for: .touchUpInside)
            return button
        }()
        /* 옵션뷰에 있는 버튼 */
        lazy var reportButton: UIButton = {
            let button = UIButton()
            button.setTitle("신고하기", for: .normal)
            button.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            button.titleLabel?.font =  .customFont(.neoMedium, size: 15)
            button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
            return button
        }()
        
        [
            ellipsisButton,
            reportButton
        ].forEach { view.addSubview($0) }
        ellipsisButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(23)
        }
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(ellipsisButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    /* 배경 블러 처리를 위해 추가한 visualEffectView */
    var visualEffectView: UIVisualEffectView?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "ProfileImage")
        imageView.layer.cornerRadius = 13
        return imageView
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var postingTime: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoRegular, size: 11)
        label.textColor = .init(hex: 0xD8D8D8)
        return label
    }()
    
    var hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "# 같이 먹고 싶어요"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoBold, size: 20)
        label.textColor = .black
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoLight, size: 15)
        label.textColor = .init(hex: 0x5B5B5B)
        label.numberOfLines = 0
        return label
    }()
    
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()

    var orderLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 예정 시간"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    var orderReserveLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var matchingLabel: UILabel = {
        let label = UILabel()
        label.text = "매칭 현황"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    var matchingDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    var categoryDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var storeLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "식당 링크"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    var storeLinkDataLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var pickupLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "수령 장소"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    var pickupLocationDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    let mapSubView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    var matchingStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var matchingDataWhiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.neoMedium, size: 16)
        label.textColor = .white
        return label
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.neoMedium, size: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 16)
        button.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Arrow")
        return imageView
    }()
    
    lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(298)
        }
        
        /* top View: 삭제하기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
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
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(206)
            make.top.equalTo(topSubView.snp.bottom)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "파티글 삭제하기를 누를 시\n해당 글을 영구적으로\n지워집니다.\n삭제하시겠습니까?"
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
            make.width.equalTo(193)
            make.height.equalTo(144)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.width.equalTo(230)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoRegular, size: 18)
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
        
        return view
    }()
    
    /* 신청하기 누르면 나오는 신청하기 Alert 뷰 */
    lazy var registerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(222)
        }
        
        /* top View: 삭제하기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
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
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "이 파티를\n신청하시겠습니까?"
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
            make.top.equalToSuperview().inset(25)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapRegisterConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
        
        return view
    }()
    
    lazy var toastView: UIView? = nil
    
    // MARK: - Properties
    
    var deliveryData: DeliveryListModelResult?
    var detailData = DeliveryListDetailModelResult()
    var dormitoryInfo: DormitoryNameResult? // dormitory id, name
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
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .white
        
        setFirestore()
        setMapView()
        setDetailData()
        addSubViews()
        setLayouts()
        setAttributes()
        startTimer()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TapEditButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                print("수정 완료 버튼이 눌렸당")
                self.setDetailData()
            }
        }
    }
    
    // MARK: - viewWillAppear()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이 뷰가 보여지면 네비게이션바를 나타나게 해야한다
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView = nil
    }
    
    // MARK: - Functions
    
    private func setFirestore() {
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        db.clearPersistence()
    }
    
    private func setDetailData() {
        if let partyId = self.deliveryData?.id {
            DeliveryListDetailViewModel.getDetailInfo(partyId: partyId, completion: { [weak self] result in
                // detailData에 데이터 넣기
                if let self = self {
                    self.detailData = result
                    
                    // partyEdit 고려하여 전역에 데이터 넣기 -> edit API 호출 시 nil 값 방지
                    switch result.foodCategory {
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
                    CreateParty.orderTime = result.orderTime
                    CreateParty.maxMatching = result.maxMatching
                    CreateParty.url = result.storeUrl
                    CreateParty.latitude = result.latitude
                    CreateParty.longitude = result.longitude
                    CreateParty.hashTag = result.hashTag
                
                    // 불러온 시점에 바로 MapView 좌표, 마커 좌표 바꾸기 -> setMapView에서는 설정한 좌표로 초기화가 안 됨
                    self.mapView!.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: result.latitude!, longitude: result.longitude!)), zoomLevel: 5, animated: true)
                    self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: result.latitude!, longitude: result.longitude!))
                    
                    self.setDefaultValue()
                    
                    guard let belongStatus = self.detailData.belongStatus else { return }
                    print("속해있는가", belongStatus)
                    
                    if self.detailData.authorStatus! {
                        self.signUpButton.setTitle("채팅방 가기", for: .normal)
                    } else {
                        if belongStatus == "Y" {
                            self.signUpButton.setTitle("채팅방 가기", for: .normal)
                        } else {
                            self.signUpButton.setTitle("신청하기", for: .normal)
                        }
                    }
                }
            })
        }
    }
    
    public func setDefaultValue() {
//        chiefProfileImgUrl -> default image 추후에
//        id
//        matchingStatus      안 쓴 다섯 개 값 (나중에 필요)
        nickNameLabel.text = detailData.chief
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
        postingTime.text = detailData.updatedAt
        
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
    
    public func setMapView() {
        print("setMapView 호출 시점")
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            mapView.isUserInteractionEnabled = false
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: detailData.latitude ?? 37.456518177069526,
                                                                    longitude: detailData.longitude ?? 126.70531256589555)), zoomLevel: 5, animated: true)
            // 마커의 좌표 설정
            self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: detailData.latitude ?? 37.456518177069526, longitude: detailData.longitude ?? 126.70531256589555))
            
            mapView.addPOIItems([marker])
            mapSubView.addSubview(mapView)
        }
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.view.addSubview(containerView)
        self.containerView.addSubview(matchingStatusView)
        
        [
            profileImageView, nickNameLabel, postingTime, hashTagLabel,
            titleLabel, contentLabel,
            separateView,
            orderLabel, matchingLabel, categoryLabel, storeLinkLabel, pickupLocationLabel,
            orderReserveLabel, matchingDataLabel, categoryDataLabel, storeLinkDataLabel, pickupLocationDataLabel,
            mapSubView
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
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(mapSubView.snp.bottom).offset(55 + 20)
        }
        
        // 신청하기 뷰를 고정시켜 놓을 컨테이너 뷰
        containerView.snp.makeConstraints { make in
            make.bottom.width.equalToSuperview()
            // 컨테이너뷰 높이 = 탭바 높이 + 매칭 상태바 높이
            if let tabBarCont = tabBarController {
                make.height.equalTo(tabBarCont.tabBar.bounds.height + 55)
            }
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(23)
            make.width.height.equalTo(26)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        postingTime.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel.snp.right).offset(15)
            make.centerY.equalTo(nickNameLabel.snp.centerY)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(hashTagLabel.snp.bottom).offset(9)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.right.equalToSuperview().inset(23)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(34)
            make.height.equalTo(8)
            make.width.equalToSuperview()
        }
        
        orderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(separateView.snp.bottom).offset(31)
            make.width.equalTo(78)
        }
        
        matchingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(orderLabel.snp.bottom).offset(24)
            make.width.equalTo(78)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(matchingLabel.snp.bottom).offset(24)
            make.width.equalTo(78)
        }
        
        storeLinkLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(categoryLabel.snp.bottom).offset(24)
            make.width.equalTo(78)
        }
        
        pickupLocationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.top.equalTo(storeLinkLabel.snp.bottom).offset(24)
            make.width.equalTo(78)
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
        
        mapSubView.snp.makeConstraints { make in
            make.top.equalTo(pickupLocationLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(122)
        }
        
        matchingStatusView.snp.makeConstraints { make in
            // 탭바 높이만큼 떨어뜨려 놓는다
            if let tabBarCont = tabBarController {
                make.bottom.equalToSuperview().inset(tabBarCont.tabBar.bounds.height)
                make.height.equalTo(55)
                make.width.equalToSuperview()
            }
        }
        
        matchingDataWhiteLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(29)
            make.centerY.equalTo(matchingStatusView.snp.centerY)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(matchingDataWhiteLabel.snp.right).offset(45)
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-11)
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
            make.right.equalToSuperview().inset(29)
        }
        
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "파티 보기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // rightBarButton을 옵션 버튼으로 설정
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "EllipsisOption"), style: .plain, target: self, action: #selector(tapEllipsisOption)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        // rightBarButtonItem의 default 위치에다가 inset을 줘서 위치를 맞춤
        navigationItem.rightBarButtonItem?.imageInsets = .init(top: -3, left: 0, bottom: 0, right: 20)
    }
    
    /* Ellipsis Button을 눌렀을 때 동작하는, 옵션뷰를 나타나게 하는 함수 */
    @objc
    private func tapEllipsisOption() {
        guard let authorStatus = detailData.authorStatus else { return }
        
        // 글쓴이인지 아닌지 확인해서 해당하는 옵션뷰에 애니메이션을 적용한다
        if authorStatus {
            showOptionMenu(optionViewForAuthor, UIScreen.main.bounds.height / 3.8)
        } else {
            showOptionMenu(optionView, UIScreen.main.bounds.height / 5.5)
        }
    }
    
    /*
     오른쪽 상단의 옵션뷰 보여주기
     - 오른쪽 위에서부터 대각선 아래로 내려오는 애니메이션 설정
     - 배경의 블러뷰 설정
     */
    private func showOptionMenu(_ nowView: UIView, _ height: CGFloat) {
        // 네비게이션 바보다 앞쪽에 위치하도록 설정
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(nowView)
        print("DEBUG: 옵션뷰의 위치", nowView.frame)
        
        // 레이아웃 설정
        nowView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().inset(150)
            make.height.equalTo(height)
        }
        
        // 오른쪽 위에서부터 대각선 아래로 내려오는 애니메이션을 설정
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseOut,
            animations: { () -> Void in
                nowView.center.y += nowView.bounds.height
                nowView.center.x -= nowView.bounds.width
                nowView.layoutIfNeeded()
            },
            completion: nil
        )
        
        // 배경을 흐리게, 블러뷰로 설정
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    /* 옵션뷰가 나타난 후에, 배경의 블러뷰를 터치하면 옵션뷰와 블러뷰가 같이 사라지도록 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        guard let authorStatus = detailData.authorStatus else { return }
        
        if authorStatus {
            showPartyPost(optionViewForAuthor)
        } else {
            showPartyPost(optionView)
        }
        
        deleteView.removeFromSuperview()
        registerView.removeFromSuperview()
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
    
    /* 이전 화면으로 돌아가기 */
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 옵션뷰 안에 들어있는 Ellipsis 버튼 클릭해서 옵션뷰 사라지게 할 때 사용하는 함수 */
    @objc
    private func tapEllipsisInOptionView(_ sender: UIButton) {
        // 클릭한 버튼의 superView가 그냥 optionView인지 optionViewForAuthor인지 파라미터로 보내주는 것
        guard let nowView = sender.superview else { return }
        showPartyPost(nowView)
    }
    
    /* 파티 보기 화면으로 돌아가기 */
    private func showPartyPost(_ nowView: UIView) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseOut,
            animations: { () -> Void in
                // 사라질 때 자연스럽게 옵션뷰, 블러뷰에 애니메이션 적용
                nowView.center.y -= nowView.bounds.height
                nowView.center.x += nowView.bounds.width
                nowView.layoutIfNeeded()
                self.visualEffectView?.layer.opacity -= 0.6
            },
            completion: { _ in ()
                nowView.removeFromSuperview()
                self.visualEffectView?.removeFromSuperview()
            }
        )
    }
    
    @objc
    private func showEditView() {
        optionViewForAuthor.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
        
        let editPartyVC = EditPartyViewController()
        editPartyVC.dormitoryInfo = dormitoryInfo
        editPartyVC.detailData = detailData
        editPartyVC.isEdittiedDelegate = self
        navigationController?.pushViewController(editPartyVC, animated: true)
    }
        
    /* 신고하기 버튼 눌렀을 때 화면 전환 */
    @objc
    private func tapReportButton() {
        guard let partyId = self.deliveryData?.id,
              let memberId = self.detailData.chiefId else { return }
        
        let reportVC = ReportViewController()
        
        // 해당 배달파티 id값, 유저 id값 전달
        reportVC.partyId = partyId
        reportVC.memberId = memberId
        
        // 옵션탭 집어넣고 화면 전환 실행
        self.optionView.removeFromSuperview()
        self.visualEffectView?.removeFromSuperview()
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @objc
    private func showDeleteView() {
        optionViewForAuthor.removeFromSuperview()
        
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    @objc
    private func removeDeleteView() {
        deleteView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
    
    /* 신청하기 뷰에서 X자 눌렀을 때 실행되는 함수 */
    @objc
    private func removeRegisterView() {
        registerView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
    
    /* 삭제하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapConfirmButton() {
        if let partyId = detailData.id {
            // 파티 삭제
            DeletePartyViewModel.deleteParty(partyId: partyId)
        }
        // 삭제하기 뷰 없애고
        removeDeleteView()
        // DeliveryVC에서 배달 목록 새로고침 (삭제된 거 반영되게 하려고)
        delegate?.updateDeliveryList()
        // 이전화면으로 이동
        navigationController?.popViewController(animated: true)
    }
    
    /* 배달 파티 신청하기 버튼 눌렀을 때 실행되는 함수 */
    @objc
    private func tapSignUpButton(_ sender: UIButton) {
        // 파티장이라면 채팅방으로 가는 로직을 연결
        if sender.title(for: .normal) == "채팅방 가기" {
            guard let roomUUID = detailData.uuid else { return }
            db.collection("Rooms").document(roomUUID).getDocument { (document, error) in
                if let document = document {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Cached document data: \(dataDescription)")
                    
                    // 해당 채팅방으로 이동
                    let chattingVC = ChattingViewController()
                    chattingVC.roomUUID = roomUUID
                    chattingVC.maxMatching = self.detailData.maxMatching
                    self.navigationController?.pushViewController(chattingVC, animated: true)
                } else {
                    print("Document does not exist in cache")
                }
            }
        } else {
            // 파티장이 아니고, 아직 채팅방에 참여하지 않은 유저라면 신청하는 로직에 연결
            // 배경을 흐리게, 블러뷰로 설정
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            visualEffectView.layer.opacity = 0.6
            visualEffectView.frame = view.frame
            view.addSubview(visualEffectView)
            self.visualEffectView = visualEffectView
            
            /* 신청하기 뷰 보여줌 */
            view.addSubview(registerView)
            registerView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    /* (방장이 아닌) 유저를 채팅방에 초대하는 함수 (= 참여자로 추가) */
    private func addParticipant(roomUUID: String, completion: @escaping () -> ()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 해당 채팅방의 participants에 본인 닉네임을 append
        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let e = error {
                print(e.localizedDescription)
                self.isInvited = false
            } else {
                if let document = documentSnapshot {
                    // 해당 uuid의 채팅방이 존재할 때에만 초대 로직을 실행한다
                    if document.exists {
                        guard let nickName = LoginModel.nickname else { return }
                        /* roomInfo 안의 participants 배열에 nickName을 추가해주는 코드 */
                        let input = ["participant": nickName, "enterTime": formatter.string(from: Date()), "isRemittance": "false"]
                        self.db.collection("Rooms").document(roomUUID).updateData(["roomInfo.participants": FieldValue.arrayUnion([input])])
                        
                        // 참가자 참가 시스템 메세지 업로드
                        self.db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                            "content": "\(LoginModel.nickname ?? "홍길동")님이 입장하셨습니다",
                            "nickname": LoginModel.nickname ?? "홍길동",
                            "userImgUrl": LoginModel.userImgUrl ?? "https://",
                            "time": formatter.string(from: Date()),
                            "isSystemMessage": true
                        ]) { error in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                print("Success save data")
                            }
                        }

                        // object를 넣어야 함
                        print("DEBUG: 채팅방 \(roomUUID)에 참가자 \(nickName) 추가 완료")
                        self.isInvited = true
                    }
                }
            }
            // 비동기 처리를 위해 completion 사용 -> 이 함수가 끝난 뒤에 실행되게 하려고
            completion()
        }
    }
    
    /* 신청하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapRegisterConfirmButton() {
        // 신청하기 뷰 없애고
        removeRegisterView()
        
        guard let uuid = detailData.uuid else { return }
        print("DEBUG: 이 채팅방의 uuid값은", uuid)
        addParticipant(roomUUID: uuid, completion: { [self] in
            print("DEBUG: 초대 상황은?", isInvited)
            // 초대하기 성공했을 때만 성공 메세지 띄우기
            if isInvited {
                // API를 통해 이 유저를 서버의 partyMember에도 추가해 줘야 함
                // 배달 파티 신청하기 API 호출
                guard let partyId = self.deliveryData?.id else { return }
                JoinPartyAPI.requestJoinParty(JoinPartyInput(partyId: partyId)) {
                    print("DEBUG: 배달 파티멤버로 추가 완료")
                }
                
                showCompleteRegisterView()
            } else {
                // 초대 실패 시 실패 메세지 띄우기
                showToast(viewController: self, message: "배달파티 신청에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .init(hex: 0x474747, alpha: 0.6))
            }
        })
        
        
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
                make.top.equalToSuperview().inset(24)
                make.centerX.equalToSuperview()
            }
            cancelButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(12)
                make.right.equalToSuperview().inset(6)
                make.width.equalTo(20)
                make.height.equalTo(15)
            }
            goChatButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(toastLabel.snp.bottom).offset(9)
                make.width.equalTo(72)
                make.height.equalTo(19)
            }
            
            return view
        }()
        
        // toastView가 보이게 설정
        view.addSubview(toastView!)
        toastView!.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(246)
            make.height.equalTo(93)
        }
        
        // 3초 뒤에 사라지도록 타이머 설정
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.tapCancelButton()
        })
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
    func checkEditted(isEditted: Bool) {
        if isEditted {
            self.showToast(viewController: self, message: "수정이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
            
            // DeliveryVC에서 배달 목록 새로고침 (수정된 거 반영되게 하려고)
            delegate?.updateDeliveryList()
        }
    }
}

extension PartyViewController: MTMapViewDelegate {
    
}

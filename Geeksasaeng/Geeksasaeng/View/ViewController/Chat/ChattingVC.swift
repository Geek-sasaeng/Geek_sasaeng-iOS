//
//  ChattingVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChattingViewController: UIViewController {
    // MARK: - SubViews
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
        collectionView.addGestureRecognizer(gesture)
        return collectionView
    }()
    
    /* bottomView components */
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        return view
    }()
    let sendImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SendImage"), for: .normal)
        return button
    }()
    let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .customFont(.neoMedium, size: 16)
        textView.backgroundColor = .init(hex: 0xEFEFEF)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.isEditable = true
        textView.text = "입력하세요"
        textView.textColor = .init(hex: 0xD8D8D8)
        return textView
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 16)
        button.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapSendButton), for: .touchUpInside)
        return button
    }()
    
    /* 방장이 옵션뷰를 눌렀을 때 나오는 뷰 */
    lazy var optionViewForOwner: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.height / 3.8)))
        view.backgroundColor = .white
        
        // 왼쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        /* 옵션뷰에 있는 ellipsis 버튼
         -> 원래 있는 버튼을 안 가리게 & 블러뷰에 해당 안 되게 할 수가 없어서 옵션뷰 위에 따로 추가함 */
        lazy var settingButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "Setting"), for: .normal)
            button.tintColor = .init(hex: 0x2F2F2F)
            // 옵션뷰 나온 상태에서 ellipsis button 누르면 사라지도록
            button.addTarget(self, action: #selector(tapOptionButtonInView), for: .touchUpInside)
            return button
        }()
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(23)
        }
        
        /* 옵션뷰에 있는 버튼 */
        var showMenuButton: UIButton = {
            let button = UIButton()
            button.setTitle("메뉴판 보기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            return button
        }()
        var sendDeliveryConfirmButton: UIButton = {
            let button = UIButton()
            button.setTitle("배달 완료 알림 보내기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            return button
        }()
        var closeMatchingButton: UIButton = {
            let button = UIButton()
            button.setTitle("매칭 마감하기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            button.addTarget(self, action: #selector(tapCloseMatchingButton), for: .touchUpInside)
            return button
        }()
        var forcedExitButton: UIButton = {
            let button = UIButton()
            button.setTitle("강제 퇴장시키기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            return button
        }()
        var endOfChatButton: UIButton = {
            let button = UIButton()
            button.setTitle("나가기", for: .normal)
            button.addTarget(self, action: #selector(tapEndOfChatButton), for: .touchUpInside)
            return button
        }()
        
        [showMenuButton, sendDeliveryConfirmButton, closeMatchingButton, forcedExitButton, endOfChatButton].forEach {
            // attributes
            $0.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            $0.titleLabel?.font =  .customFont(.neoMedium, size: 15)
            
            // layouts
            view.addSubview($0)
        }
        
        showMenuButton.snp.makeConstraints { make in
            make.top.equalTo(settingButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        sendDeliveryConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(showMenuButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        closeMatchingButton.snp.makeConstraints { make in
            make.top.equalTo(sendDeliveryConfirmButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        forcedExitButton.snp.makeConstraints { make in
            make.top.equalTo(closeMatchingButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        endOfChatButton.snp.makeConstraints { make in
            make.top.equalTo(forcedExitButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    lazy var optionViewForUser: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.height / 5)))
        view.backgroundColor = .white
        
        // 왼쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        /* 옵션뷰에 있는 ellipsis 버튼
         -> 원래 있는 버튼을 안 가리게 & 블러뷰에 해당 안 되게 할 수가 없어서 옵션뷰 위에 따로 추가함 */
        lazy var settingButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "Setting"), for: .normal)
            button.tintColor = .init(hex: 0x2F2F2F)
            // 옵션뷰 나온 상태에서 ellipsis button 누르면 사라지도록
            button.addTarget(self, action: #selector(tapOptionButtonInView), for: .touchUpInside)
            return button
        }()
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(23)
        }
        
        /* 옵션뷰에 있는 버튼 */
        var showMenuButton: UIButton = {
            let button = UIButton()
            button.setTitle("메뉴판 보기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 16)
            return button
        }()
        var endOfChatButton: UIButton = {
            let button = UIButton()
            button.setTitle("채팅 나가기", for: .normal)
            button.addTarget(self, action: #selector(tapEndOfChatButton), for: .touchUpInside)
            return button
        }()
        
        [showMenuButton, endOfChatButton].forEach {
            // attributes
            $0.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            $0.titleLabel?.font =  .customFont(.neoMedium, size: 15)
            
            // layouts
            view.addSubview($0)
        }
        
        showMenuButton.snp.makeConstraints { make in
            make.top.equalTo(settingButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        endOfChatButton.snp.makeConstraints { make in
            make.top.equalTo(showMenuButton.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    // 나가기 뷰
    lazy var exitView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        
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
        titleLabel.text = "나가기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoMedium, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(tapXButton), for: .touchUpInside)
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
        contentLabel.text = "본 채팅방을 나갈 시\n이후로 채팅에 참여할 수\n없습니다. 계속하시겠습니까?"
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
        confirmButton.addTarget(self, action: #selector(tapExitConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
        
        return view
    }()
    
    /* 매칭 마감하기 누르면 나오는 매칭마감 안내 뷰 */
    lazy var closeMatchingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(250)
        }
        
        /* top View */
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
        titleLabel.text = "매칭 마감하기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoMedium, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(removeCloseMatchingView), for: .touchUpInside)
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
            make.height.equalTo(200)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "매칭을 종료할 시\n본 파티에 대한 추가 인원이\n더 이상 모집되지 않습니다.\n계속하시겠습니까?"
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
            make.top.equalToSuperview().inset(20)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoBold, size: 18)
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
        
        return view
    }()
    
    // 송금하기 상단 뷰 (Firestore의 participant의 isRemittance 값이 false인 경우에만 노출)
    lazy var remittanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF6F9FB)
        view.layer.opacity = 0.9
        
        let coinImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "RemittanceIcon")
            return imageView
        }()
        
        let accountLabel: UILabel = {
            let label = UILabel()
            label.font = .customFont(.neoMedium, size: 14)
            label.textColor = .init(hex: 0x2F2F2F)
            // TODO: - Firestore or Server에서 받아오기
            label.text = "국민  000000-00-000000"
            return label
        }()
        
        let remittanceConfirmButton: UIButton = {
            let button = UIButton()
            button.setTitle("송금 완료", for: .normal)
            button.titleLabel?.font = .customFont(.neoMedium, size: 11)
            button.titleLabel?.textColor = .white
            button.backgroundColor = .mainColor
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(tapRemittanceButton), for: .touchUpInside)
            return button
        }()
        
        [coinImageView, accountLabel, remittanceConfirmButton].forEach {
            view.addSubview($0)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(29)
            make.width.height.equalTo(24)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(coinImageView.snp.right).offset(8)
        }
        
        remittanceConfirmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(28)
            make.width.equalTo(67)
            make.height.equalTo(29)
        }
        
        return view
    }()
    
    // 블러 뷰
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    var contents: [cellContents] = []
    var userNickname: String?
    var maxMatching: Int?
    var currentMatching: Int?
    // 선택한 채팅방의 uuid값
    var roomUUID: String?
    
    var presentOptionViewForOwner = false
    var presentOptionViewForUser = false
    
    var firstRoomInfo = true
    var firstMessage = true
    
    var lastSender: String?
    
    var roomMaster: String? // 내가 현재 방장인지
    // TODO: - 나중에 방장일 때, 아닐 때 옵션뷰 다르게 보이기
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        contentsTextView.delegate = self
        
        setFirestore()
        checkRemittance()
        loadPreMessages()
        loadParticipants()
        loadMessages()
        setCollectionView()
        addSubViews()
        setLayouts()
        setRoomMaster()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "채팅방 이름"
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(tapOptionButton)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 사라질 때 다시 탭바 보이게 설정
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        collectionView.endEditing(true)
    }
    
    private func setCollectionView() {
        collectionView.register(SystemMessageCell.self, forCellWithReuseIdentifier: "SystemMessageCell")
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView.register(SameSenderMessageCell.self, forCellWithReuseIdentifier: "SameSenderMessageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func addSubViews() {
        [sendImageButton, contentsTextView, sendButton].forEach {
            bottomView.addSubview($0)
        }
        
        [collectionView, bottomView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(69)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(69)
        }
        
        sendImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(33)
            make.left.equalToSuperview().inset(20)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(22)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(sendImageButton.snp.right).offset(13)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
    }
    
    private func setFirestore() {
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        db.clearPersistence()
    }
    
    private func setRoomMaster() {
        guard let roomUUID = roomUUID else { return }

        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let data = try documentSnapshot?.data(as: RoomInfoModel.self)
                    guard let roomInfo = data?.roomInfo,
                          let participants = roomInfo.participants else { return }
                    
                    // 방장 설정
                    if participants.count >= 1 {
                        self.roomMaster = participants[0].participant
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func checkRemittance() {
        // firestore에서 내 participant 불러와서 isRemittance가 false이면 remittanceView add
        guard let roomUUID = roomUUID else { return }

        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let data = try documentSnapshot?.data(as: RoomInfoModel.self)
                    guard let roomInfo = data?.roomInfo,
                          let participants = roomInfo.participants else { return }
                    
                    participants.forEach {
                        // 해당 참여자가 송금을 하지 않을 상태이면 remittanceView 노출
                        if $0.participant == LoginModel.nickname {
                            guard let isRemittance = $0.isRemittance else { return }
                            if !isRemittance {
                                self.view.addSubview(self.remittanceView)
                                self.remittanceView.snp.makeConstraints { make in
                                    if let navigationBar = self.navigationController?.navigationBar {
                                        make.top.equalTo(navigationBar.snp.bottom)
                                    }
                                    make.width.equalToSuperview()
                                    make.height.equalTo(55)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadPreMessages() {
        guard let roomUUID = roomUUID else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 참가자가 참가한 시간 불러오기
        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let data = try documentSnapshot?.data(as: RoomInfoModel.self)
                    guard let roomInfo = data?.roomInfo,
                          let participants = roomInfo.participants else { return }
                    if participants.count > 0 {
                        // 채팅방 로드할 때 방장, 현재 인원 정보 불러오기 (방장은 나가기 API 호출 위해 필요)
                        self.roomMaster = participants[0].participant
                        self.currentMatching = participants.count
                    }

                    // 현재 사용자가 참여한 시간을 추출
                    data?.roomInfo?.participants?.forEach {
                        if $0.participant == LoginModel.nickname {
                            guard let enterTime = $0.enterTime else { return }
                            guard let enterTimeToDate = formatter.date(from: enterTime) else { return }// 참가자가 참가한 시간 Date Type

                            // 이전 메세지 모두 불러오기 (systemMessage, message) -> 이거 되면 시간 필터링
                            self.db.collection("Rooms").document(roomUUID).collection("Messages").order(by: "time").getDocuments { querySnapshot, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let documents = querySnapshot?.documents {
                                        for doc in documents {
                                            do {
                                                let message = try doc.data(as: MessageModel.self)
                                                guard let sendTime = message.time else { return }
                                                guard let sendTimeToDate = formatter.date(from: sendTime) else { return }
                                                if message.isSystemMessage == true { // systemMessage
                                                    // 시간이 이후인 경우에만
                                                    let timeInterval = Int(enterTimeToDate.timeIntervalSince(sendTimeToDate))
                                                    if timeInterval <= 0 { // 음수일 떄 -> 참가 이후의 메세지
                                                        self.contents.append(cellContents(cellType: .systemMessage, message: MessageModel(content: message.content, nickname: message.nickname, userImgUrl: message.userImgUrl, time: message.time, isSystemMessage: true)))
                                                        self.lastSender = "system"
                                                    }
                                                } else { // 일반 message
                                                    let timeInterval = Int(enterTimeToDate.timeIntervalSince(sendTimeToDate))
                                                    if timeInterval <= 0 {
                                                        if self.lastSender == nil { // 첫 메세지일 때
                                                            self.contents.append(cellContents(cellType: .message, message: MessageModel(content: message.content, nickname: message.nickname, userImgUrl: message.userImgUrl, time: message.time, isSystemMessage: false)))
                                                            self.lastSender = message.nickname
                                                        } else if self.lastSender == message.nickname { // 같은 사람이 연속으로 보냈을 때
                                                            self.contents.append(cellContents(cellType: .sameSenderMessage, message: MessageModel(content: message.content, nickname: message.nickname, userImgUrl: message.userImgUrl, time: message.time, isSystemMessage: false)))
                                                            self.lastSender = message.nickname
                                                        } else { // 같은 사람이 보낸 게 아닐 때
                                                            self.contents.append(cellContents(cellType: .message, message: MessageModel(content: message.content, nickname: message.nickname, userImgUrl: message.userImgUrl, time: message.time, isSystemMessage: false)))
                                                            self.lastSender = message.nickname
                                                        }
                                                    }
                                                }

                                                DispatchQueue.main.async {
                                                    self.collectionView.reloadData()
                                                    self.collectionView.scrollToItem(at: IndexPath(row: self.contents.count-1, section: 0), at: .top, animated: true)
                                                }
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            }

                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadParticipants() {
        guard let roomUUID = roomUUID else { return }
        db.collection("Rooms").document(roomUUID).addSnapshotListener { documentSnapshot, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                // 첫 번째 데이터 버리기
                if self.firstRoomInfo {
                    self.firstRoomInfo = false
                    return
                }
                print("roomInfo 불러오기")
                if let document = documentSnapshot {
                    if let data = try? document.data(as: RoomInfoModel.self) {
                        guard let roomInfo = data.roomInfo,
                              let participants = roomInfo.participants else { return }
                        if participants.count > 0 {
                            // index 0 참가자가 방장으로
                            self.roomMaster = participants[0].participant
                        }
                        
                        self.currentMatching = participants.count // 참여자가 늘어나면 currentMatching에 추가
                        if self.currentMatching == roomInfo.maxMatching {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatter.locale = Locale(identifier: "ko_KR")
                            
                            // 모든 참가자 참여 완료 시스템 메세지 업로드
                            self.db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                                "content": "모든 파티원이 입장을 마쳤습니다 !\n안내에 따라 메뉴를 입력해주세요",
                                "nickname": "SystemMessage",
                                "userImgUrl": "SystemMessage",
                                "time": formatter.string(from: Date()),
                                "isSystemMessage": true
                            ]) { error in
                                if let e = error {
                                    print(e.localizedDescription)
                                } else {
                                    print("Success save data")
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.collectionView.scrollToItem(at: IndexPath(row: self.contents.count-1, section: 0), at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    private func loadMessages() {
        guard let roomUUID = roomUUID else { return }
        db.collection("Rooms").document(roomUUID).collection("Messages").order(by: "time").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                // 첫 번째 데이터 버리기
                if self.firstMessage {
                    self.firstMessage = false
                    return
                }
                print("Messages 불러오기")
                if let snapshotDocuments = querySnapshot?.documents {
                    if let data = snapshotDocuments.last?.data() {
                        if let content = data["content"] as? String,
                           let nickname = data["nickname"] as? String,
                           let userImgUrl = data["userImgUrl"] as? String,
                           let time = data["time"] as? String,
                           let isSystemMessage = data["isSystemMessage"] as? Bool {
                            if isSystemMessage == true {
                                self.contents.append(cellContents(cellType: .systemMessage, message: MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl, time: time, isSystemMessage: isSystemMessage)))
                                self.lastSender = "system"
                            } else if self.lastSender == nil { // 첫 메세지일 때
                                self.contents.append(cellContents(cellType: .message,
                                                                  message: MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl, time: time)))
                                self.lastSender = nickname
                            } else if self.lastSender == nickname { // 같은 사람이 연속으로 보낼 때
                                self.contents.append(cellContents(cellType: .sameSenderMessage,
                                                                  message: MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl, time: time)))
                                self.lastSender = nickname
                            } else { // 다른 사람이 보낼 때
                                self.contents.append(cellContents(cellType: .message,
                                                                  message: MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl, time: time)))
                                self.lastSender = nickname
                            }
                            

                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.collectionView.scrollToItem(at: IndexPath(row: self.contents.count-1, section: 0), at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc
    private func tapOptionButton() {
        if roomMaster == LoginModel.nickname {
            presentOptionViewForOwner = true
            showOptionMenu(optionViewForOwner, UIScreen.main.bounds.height / 2 - 30)
        } else {
            presentOptionViewForUser = true
            showOptionMenu(optionViewForUser, UIScreen.main.bounds.height / 4)
        }
        
    }
    
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
        visualEffectView.isUserInteractionEnabled = false
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    @objc
    private func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(
                withDuration: 0.3, animations: {
                    self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                    self.collectionView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc
    private func keyboardDown() {
        // reportBarView 위치 제자리로
        self.bottomView.transform = .identity
    }
    
    /* 매칭 마감하기 버튼 누르면 실행되는 함수 */
    @objc
    private func tapCloseMatchingButton() {
        optionViewForOwner.removeFromSuperview()
        
        /* 매칭 마감 뷰 보여줌 */
        view.addSubview(closeMatchingView)
        closeMatchingView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /* 매칭 마감하기 뷰에서 X자 눌렀을 때 실행되는 함수 */
    @objc
    private func removeCloseMatchingView() {
        closeMatchingView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
    
    /* 매칭 마감하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapConfirmButton() {
        let input = CloseMatchingInput(uuid: roomUUID)
        CloseMatchingAPI.requestCloseMatching(input) { isSuccess in
            if isSuccess {
                // 매칭 마감 시스템 메세지 업로드
                self.db.collection("Rooms").document(self.roomUUID!).collection("Messages").document(UUID().uuidString).setData([
                    "content": "매칭이 마감되었습니다",
                    "nickname": LoginModel.nickname ?? "홍길동",
                    "userImgUrl": LoginModel.userImgUrl ?? "https://",
                    "time": FormatCreater.sharedLongFormat.string(from: Date()),
                    "isSystemMessage": true
                ]) { error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        print("Success save data")
                    }
                }
                
                // 매칭 마감 버튼 비활성화
                guard let closeMatchingButton = self.optionViewForOwner.subviews[3] as? UIButton else { return }
                closeMatchingButton.isUserInteractionEnabled = false
                closeMatchingButton.setTitleColor(.init(hex: 0xA8A8A8), for: .normal)
            }
        }
        
        // 매칭 마감하기 뷰 없애기
        removeCloseMatchingView()
    }
    
    @objc
    private func tapCollectionView() {
        view.endEditing(true)
        
        if visualEffectView != nil { // nil이 아니라면, 즉 옵션뷰가 노출되어 있다면
            if presentOptionViewForOwner {
                presentOptionViewForOwner = false
                showChattingRoom(optionViewForOwner)
            } else if presentOptionViewForUser {
                presentOptionViewForUser = false
                showChattingRoom(optionViewForUser)
            }
            view.subviews.forEach {
                if $0 == exitView {
                    $0.removeFromSuperview()
                }
            }
        }
    }
    
    @objc
    private func tapSendButton() {
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let message = contentsTextView.text {
            guard let roomUUID = roomUUID else { return }
            db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                "content": message,
                "nickname": LoginModel.nickname ?? "홍길동",
                "userImgUrl": LoginModel.userImgUrl ?? "https://",
                "time": formatter.string(from: Date()),
                "isSystemMessage": false
            ]) { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Success save data")
                    
                    DispatchQueue.main.async {
                        self.contentsTextView.text = ""
                    }
                }
            }
            
            /* 메세지 전송시 roomInfo의 updatedAt값도 바꿔주기 */
            db.collection("Rooms").document(roomUUID).updateData(["roomInfo.updatedAt" : formatter.string(from: Date())])
            { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("DEBUG: updatedAt 값 업데이트")
                }
            }
        }
    }
    
    @objc
    private func tapRemittanceButton() {
        // 파이어스토어에 isRemittance = true로 바꾸고 remittanceView remove
        guard let roomUUID = roomUUID else { return }

        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let data = try documentSnapshot?.data(as: RoomInfoModel.self)
                    guard let roomInfo = data?.roomInfo,
                          let participants = roomInfo.participants else { return }
                    
                    var targetEnterTime: String?
                    
                    participants.forEach {
                        if $0.participant == LoginModel.nickname {
                            targetEnterTime = $0.enterTime
                        }
                    }
                    
                    guard let targetEnterTime = targetEnterTime else { return }
                    // roomInfo.participants의 특정 인덱스를 수정할 수 없어서 삭제 후 추가 -> 방장이 나갔을 때 다음 방장은 들어온 순서가 아니게 됨 (상관은 없을 듯?)
                    if let nickname = LoginModel.nickname {
                        let removeData = ["enterTime": targetEnterTime, "isRemittance": false, "participant": nickname] as [String : Any]
                        let newData = ["enterTime": targetEnterTime, "isRemittance": true, "participant": nickname] as [String : Any]
                        
                        self.db.collection("Rooms").document(roomUUID).updateData(["roomInfo.participants" : FieldValue.arrayRemove([removeData])])
                        self.db.collection("Rooms").document(roomUUID).updateData(["roomInfo.participants" : FieldValue.arrayUnion([newData])])
                    }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    formatter.locale = Locale(identifier: "ko_KR")
                    
                    self.db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                        "content": "\'\(LoginModel.nickname ?? "홍길동")\'님이 송금을 완료하였습니다",
                        "nickname": "SystemMessage",
                        "userImgUrl": "SystemMessage",
                        "time": formatter.string(from: Date()),
                        "isSystemMessage": true
                    ]) { error in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
                            print("Success save data")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        self.remittanceView.removeFromSuperview()
    }
    
    @objc
    private func tapOptionButtonInView(_ sender: UIButton) {
        // 클릭한 버튼의 superView가 그냥 optionView인지 optionViewForAuthor인지 파라미터로 보내주는 것
        guard let nowView = sender.superview else { return }
        showChattingRoom(nowView)
    }
    
    private func showChattingRoom(_ nowView: UIView) {
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
    
    private func formatTime(str: String) -> String {
        let startIdx = str.index(str.startIndex, offsetBy: 11)
        let endIdx = str.index(startIdx, offsetBy: 5)
        let range = startIdx..<endIdx
        return String(str[range])
    }
    
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapEndOfChatButton() {
        // 옵션뷰 제거, 블러뷰는 그대로
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseOut,
            animations: { () -> Void in
                // 사라질 때 자연스럽게 옵션뷰, 블러뷰에 애니메이션 적용
                self.optionViewForOwner.center.y -= self.optionViewForOwner.bounds.height
                self.optionViewForOwner.center.x += self.optionViewForOwner.bounds.width
                self.optionViewForOwner.layoutIfNeeded()
            },
            completion: { _ in ()
                self.optionViewForOwner.removeFromSuperview()
            }
        )
        
        // exitView 추가
        view.addSubview(exitView)
        exitView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(256)
            make.height.equalTo(236)
        }
    }
    
    @objc
    private func tapXButton() {
        if visualEffectView != nil { // nil이 아니라면, 즉 나가기뷰가 노출되어 있다면
            visualEffectView?.removeFromSuperview()
            if presentOptionViewForOwner {
                presentOptionViewForOwner = false
                showChattingRoom(optionViewForOwner)
            } else if presentOptionViewForUser {
                presentOptionViewForUser = false
                showChattingRoom(optionViewForUser)
            }
            view.subviews.forEach {
                if $0 == exitView {
                    $0.removeFromSuperview()
                }
            }
        }
    }
    
    @objc
    private func tapExitConfirmButton() {
        // 파이어 스토어 participants에서 이름 빼고 popVC
        guard let roomUUID = roomUUID else { return }
        
        // map 삭제로 변경
        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let data = try documentSnapshot?.data(as: RoomInfoModel.self)
                    guard let roomInfo = data?.roomInfo else { return }
                    let participants = roomInfo.participants
                    
                    var targetParticipant: String? // 삭제 대상 딕셔너리를 만들기 위해
                    var time: String?
                    var isRemittance: Bool?
                    
                    if self.roomMaster == LoginModel.nickname { // 본인이 방장이면
                        if participants?.count ?? 0 >= 2 {
                            self.roomMaster = participants?[1].participant // 다음 인덱스를 방장으로
                        } else {
                            self.db.collection("Rooms").document(roomUUID).delete() // 방에 한 명이라면 채팅방 삭제
                        }
                    }
                
                    participants?.forEach {
                        if $0.participant == LoginModel.nickname {
                            targetParticipant = $0.participant
                            time = $0.enterTime
                            isRemittance = $0.isRemittance
                        }
                    }
                    
                    guard let targetParticipant = targetParticipant,
                          let time = time,
                          let isRemittance = isRemittance else { return }

                    let input = ["participant": targetParticipant, "enterTime": time, "isRemittance": isRemittance] as [String : Any]
                    self.db.collection("Rooms").document(roomUUID).updateData(["roomInfo.participants": FieldValue.arrayRemove([input])])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")

        if roomMaster == LoginModel.nickname { // 본인이 방장일 때
            let input = ChatRoomExitForCheifInput(nickName: roomMaster, uuid: roomUUID)
            ChatRoomExitAPI.patchExitCheif(input)
            
            self.db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                "content": "방장의 활동 중단에 따라 새로운\n방장으로\'\(roomMaster ?? "홍길동")\'님이 선정되었습니다",
                "nickname": "SystemMessage",
                "userImgUrl": "SystemMessage",
                "time": formatter.string(from: Date()),
                "isSystemMessage": true
            ]) { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Success save data")
                }
            }
        } else { // 본인이 방장이 아닐 때
            let input = ChatRoomExitInput(uuid: roomUUID)
            ChatRoomExitAPI.patchExitUser(input)
            
            self.db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                "content": "\(LoginModel.nickname ?? "홍길동")님이 방에서 나갔습니다",
                "nickname": "SystemMessage",
                "userImgUrl": "SystemMessage",
                "time": formatter.string(from: Date()),
                "isSystemMessage": true
            ]) { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Success save data")
                }
            }
        }
        if var currentMatching = currentMatching {
            currentMatching -= 1
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func getMessageLabelHeight(text: String) -> CGFloat {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
        let label = PaddingLabel()
        label.paddingLeft = 18
        label.paddingRight = 18
        label.paddingTop = 10
        label.paddingBottom = 10
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude)
        
        label.text = text
        label.font = .customFont(.neoMedium, size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 200
        label.sizeToFit()
        label.setNeedsDisplay()
        
        return label.frame.height
    }
    
    private func getSystemMessageLabelHeight(text: String) -> CGFloat {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: CGFloat.greatestFiniteMagnitude))
        let label = PaddingLabel()
        label.paddingLeft = 18
        label.paddingRight = 18
        label.paddingTop = 6
        label.paddingBottom = 6
        
        label.frame = CGRect(x: 0, y: 0, width: 250, height: CGFloat.greatestFiniteMagnitude)
        
        label.text = text
        label.font = .customFont(.neoMedium, size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 250
        label.textAlignment = .center
        label.sizeToFit()
        label.setNeedsDisplay()
        
        return label.frame.height
    }
}

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.row].cellType {
        case .systemMessage: // 시스템 메세지
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
            cell.systemMessageLabel.text =  contents[indexPath.row].message?.content
            return cell
        case .sameSenderMessage: // 같은 사람이 연속 전송
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SameSenderMessageCell", for: indexPath) as! SameSenderMessageCell
            if contents[indexPath.row].message?.nickname == LoginModel.nickname { // 보낸 사람이 자신
                cell.rightMessageLabel.text = contents[indexPath.row].message?.content
                cell.rightTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
                cell.rightUnReadCountLabel.text = "3" // 안 읽은 사람 수 넣기
                cell.leftTimeLabel.isHidden = true
                cell.leftUnReadCountLabel.isHidden = true
                cell.leftMessageLabel.isHidden = true
                cell.rightTimeLabel.isHidden = false
                cell.rightUnReadCountLabel.isHidden = false
                return cell
            } else {
                cell.leftMessageLabel.text = contents[indexPath.row].message?.content
                cell.leftTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
                cell.leftUnReadCountLabel.text = "3" // 안 읽은 사람 수 넣기
                cell.rightTimeLabel.isHidden = true
                cell.rightUnReadCountLabel.isHidden = true
                cell.rightMessageLabel.isHidden = true
                cell.leftTimeLabel.isHidden = false
                cell.leftUnReadCountLabel.isHidden = false
                return cell
            }
        default: // 다른 사람이 전송
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.nicknameLabel.text = contents[indexPath.row].message?.nickname
            if contents[indexPath.row].message?.nickname == LoginModel.nickname { // 보낸 사람이 자신이면
                cell.rightMessageLabel.text = contents[indexPath.row].message?.content
                cell.nicknameLabel.textAlignment = .right
                cell.rightTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
                cell.rightUnReadCountLabel.text = "3" // 안 읽은 사람 수 넣기
                cell.leftTimeLabel.isHidden = true
                cell.leftUnReadCountLabel.isHidden = true
                cell.leftMessageLabel.isHidden = true
                cell.leftImageView.isHidden = true
                cell.rightImageView.isHidden = false
                cell.rightTimeLabel.isHidden = false
                cell.rightUnReadCountLabel.isHidden = false
                if self.roomMaster == contents[indexPath.row].message?.nickname { // 방장이라면
                    cell.rightImageView.image = UIImage(named: "RoomMasterProfile")
                }
            } else {
                cell.leftMessageLabel.text = contents[indexPath.row].message?.content
                cell.nicknameLabel.textAlignment = .left
                cell.leftTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
                cell.leftUnReadCountLabel.text = "3"
                cell.rightTimeLabel.isHidden = true
                cell.rightUnReadCountLabel.isHidden = true
                cell.rightMessageLabel.isHidden = true
                cell.rightImageView.isHidden = true
                cell.leftImageView.isHidden = false
                cell.leftTimeLabel.isHidden = false
                cell.leftUnReadCountLabel.isHidden = false
                if self.roomMaster == contents[indexPath.row].message?.nickname { // 방장이라면
                    cell.leftImageView.image = UIImage(named: "RoomMasterProfile")
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch contents[indexPath.row].cellType {
        case .systemMessage:
            let labelHeight = getSystemMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // padding top, bottom = 6
            print("System Label Height: ", labelHeight + 12)
        case .message:
            // content의 크기에 맞는 라벨을 정의하고 해당 라벨의 높이가 40 초과 (두 줄 이상) or 40 (한 줄) 비교하여 높이 적용
            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight + 16) // 상하 여백 20 + 닉네임 라벨
            print("Message Label Height: ", labelHeight + 16)
        case .sameSenderMessage:
            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // label 상하 여백 20
            print("Same Message Label Height: ", labelHeight)
        default:
            cellSize = CGSize(width: view.bounds.width, height: 40)
        }
        
        return cellSize
    }
    
}

enum cellType {
    case message
    case sameSenderMessage
    case systemMessage
}

struct cellContents {
    var cellType: cellType?
    var message: MessageModel?
}

extension ChattingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            sendButton.isEnabled = true
            sendButton.setTitleColor(.mainColor, for: .normal)
        } else {
            sendButton.isEnabled = false
            sendButton.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "입력하세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "입력하세요"
            textView.textColor = UIColor(hex: 0xD8D8D8)
        }
    }
}

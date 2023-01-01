//
//  ChattingVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/23.
//

import UIKit

import Kingfisher
import RealmSwift
import RMQClient
import SnapKit
import Starscream
import Then
import PhotosUI

// Delegate Pattern을 통해 pushVC 구현
protocol PushReportUserDelegate {
    func pushReportUserVC()
}

class ChattingViewController: UIViewController {
    
    // MARK: - SubViews
    
    /* collectionView 생성할 때, Layout 초기화 필요 -> then 쓰기 위해 바깥에 layout 변수 선언 */
    let layout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 9
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
        $0.addGestureRecognizer(gesture)
    }
    
    /* bottomView components */
    let bottomView = UIView().then {
        $0.backgroundColor = .init(hex: 0xEFEFEF)
    }
    let sendImageButton = UIButton().then {
        $0.setImage(UIImage(named: "SendImage"), for: .normal)
    }
    let contentsTextView = UITextView().then {
        $0.font = .customFont(.neoMedium, size: 16)
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.isEditable = true
        $0.text = "입력하세요"
        $0.textColor = .init(hex: 0xD8D8D8)
    }
    lazy var sendButton = UIButton().then {
        $0.setTitle("전송", for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 16)
        $0.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(self.tapSendButton), for: .touchUpInside)
    }
    
    
    // 방장에게 띄워질 액션 시트
    lazy var ownerAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then { actionSheet in
        [
            UIAlertAction(title: "배달 완료 알림 보내기", style: .default, handler: { _ in self.tapDeliveryConfirmButton() }),
            UIAlertAction(title: "매칭 마감하기", style: .default, handler: { _ in self.tapCloseMatchingButton() }),
            UIAlertAction(title: "강제 퇴장시키기", style: .default, handler: { _ in self.tapForcedExitButton() }),
            UIAlertAction(title: "채팅 나가기", style: .default, handler: { _ in self.tapEndOfChatButton() }),
            UIAlertAction(title: "닫기", style: .cancel)
        ].forEach{ actionSheet.addAction($0) }
    }
    
    // 방장이 아닌 유저에게 띄워질 액션 시트
    lazy var userAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then { actionSheet in
        // alert 발생 시 나타날 액션선언 및 추가
        [
            UIAlertAction(title: "채팅 나가기", style: .default, handler: { _ in self.tapEndOfChatButton() }),
            UIAlertAction(title: "닫기", style: .cancel)
        ].forEach{ actionSheet.addAction($0) }
    }
    
    // 나가기 뷰
    lazy var exitView = UIView().then { view in
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        
        /* top View: 삭제하기 */
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "나가기"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "본 채팅방을 나갈 시\n이후로 채팅에 참여할 수\n없습니다. 계속하시겠습니까?"
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapExitConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
    }
    
    /* 매칭 마감하기 누르면 나오는 매칭마감 안내 뷰 */
    lazy var closeMatchingView = UIView().then { view in
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(250)
        }
        
        /* top View */
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "매칭 마감하기"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.removeCloseMatchingView), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "매칭을 종료할 시\n본 파티에 대한 추가 인원이\n더 이상 모집되지 않습니다.\n계속하시겠습니까?"
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.width.height.equalTo(34)
        }
    }
    
    // 송금하기 상단 뷰 (Firestore의 participant의 isRemittance 값이 false인 경우에만 노출)
    lazy var remittanceView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF6F9FB)
        view.layer.opacity = 0.9
        
        let coinImageView = UIImageView().then {
            $0.image = UIImage(named: "RemittanceIcon")
        }
        
        let accountLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 14)
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.text = "\(self.bank ?? "은행")  \(self.accountNumber ?? "000-0000-0000-00")"
        }
        
        let remittanceConfirmButton = UIButton().then {
            $0.setTitle("송금 완료", for: .normal)
            $0.titleLabel?.font = .customFont(.neoMedium, size: 11)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .mainColor
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(tapRemittanceButton), for: .touchUpInside)
        }
        
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
    }
    
    // 주문완료 상단 뷰 (방장인 경우에만 노출)
    lazy var orderCompletedView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF6F9FB)
        view.layer.opacity = 0.9
        
        let orderCompletedButton = UIButton().then {
            $0.setTitle("주문 완료", for: .normal)
            $0.titleLabel?.font = .customFont(.neoMedium, size: 11)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .mainColor
            $0.layer.cornerRadius = 5
//            $0.addTarget(self, action: #selector(tapRemittanceButton), for: .touchUpInside)
            // TODO: - 채팅 구현 후 addTarget 설정
        }
        
        view.addSubview(orderCompletedButton)
        orderCompletedButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(67)
            make.height.equalTo(29)
        }
    }
    
    // 배달완료 알림 보내기 재확인 알림뷰
    lazy var notificationSendView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        $0.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(226)
        }
        
        /* top View: 배달완료 알림 보내기 */
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "배달완료 알림 보내기"
            $0.textColor = UIColor(hex: 0xA8A8A8)
            $0.font = .customFont(.neoMedium, size: 14)
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.removeNotificationSendView), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 보내기 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(176)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "주문한 음식이 배달되었는지\n다시 확인한 후 알림을\n보내보세요. "
            $0.numberOfLines = 0
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.font = .customFont(.neoMedium, size: 14)
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("보내기", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.tapNotificationSendButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1.7)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(18)
        }
    }
    
    // 블러 뷰
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    
    private var socket: WebSocket?
    private let rabbitMQUri = "amqp://\(Keys.idPw)@\(Keys.address)"
    
    enum MsgType {
        case message
        case sameSenderMessage
        case systemMessage
    }

    struct MsgContents {
        var msgType: MsgType?
        var message: MsgResponse?
    }
    
    var msgContents: [MsgContents] = []
    var msgRecords: Results<MsgResponse>?
    var userNickname: String?
    var maxMatching: Int?
    var currentMatching: Int?
    
    // 선택한 채팅방의 id값
    var roomId: String?
    var roomName: String?
    
    var firstRoomInfo = true
    var firstMessage = true
    
    var lastSenderId: Int? = nil
    
    var roomMaster: String? // 내가 현재 방장인지
    var bank: String?
    var accountNumber: String?
    var enterTimeToDate: Date?    // 내가 이 방에 들어온 시간
    
    var keyboardHeight: CGFloat? // 키보드 높이
    // 로컬에 데이터를 저장하기 위해 Realm 객체 생성
    var localRealm: Realm? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupWebSocket()
        
        setAttributes()
        setCollectionView()
        addSubViews()
        setLayouts()
        receiveMsgs()
        
        do {
            // 스키마 버전 명시 -> migration 할 때 버전 업데이트 필요.
            let configuration = Realm.Configuration(schemaVersion: 7)
            localRealm = try Realm(configuration: configuration)
            
            // Realm 파일 위치
            print("DEBUG: 채팅 데이터 Realm 파일 경로", Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print(error.localizedDescription)
        }
        
        // 이전 메세지 불러오기
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = roomName
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(tapOptionButton)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 사라질 때 다시 탭바 보이게 설정
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - deinit
    
    // 웹소켓 해제
    deinit {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        collectionView.endEditing(true)
    }
    
    private func setAttributes() {
        contentsTextView.delegate = self
        sendImageButton.addTarget(self, action: #selector(tapSendImageButton), for: .touchUpInside)
    }
    
    // 웹소켓 설정
    private func setupWebSocket() {
        let url = URL(string: "ws://geeksasaeng.shop:8080/chatting")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket!.delegate = self
        socket!.connect()
    }
    
    private func setCollectionView() {
        collectionView.register(SystemMessageCell.self, forCellWithReuseIdentifier: "SystemMessageCell")
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView.register(SameSenderMessageCell.self, forCellWithReuseIdentifier: "SameSenderMessageCell")
        collectionView.register(ImageMessageCell.self, forCellWithReuseIdentifier: "ImageMessageCell")
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
            make.bottom.equalTo(bottomView.snp.top).offset(-15)
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
    
    // TODO: - 입장 시간 설정하고 그 이후 메세지만 가져오기
    
    // TODO: - 송금 관련 뷰 설정 -> 방장도 구별해야 함
    
    // TODO: - 사진 데이터도 저장해야 함
    
    // 로컬에서 이전 채팅 불러오기
    private func loadMessages() {
        print("DEBUG: loadMessages")
        // 로컬에서 해당 채팅방의 채팅 데이터 가져오기
        let predicate = NSPredicate(format: "chatRoomId = %@", self.roomId!)
        self.msgRecords = localRealm!.objects(MsgResponse.self).filter(predicate).sorted(byKeyPath: "createdAt")
        
        guard let msgRecords = msgRecords else { return }
        print("DEBUG: 불러온 채팅 갯수", msgRecords.count)
        for msgRecord in msgRecords {
            if msgRecord.isSystemMessage == true {
                self.msgContents.append(
                    MsgContents(msgType: .systemMessage, message: msgRecord))
                self.lastSenderId = -1 // 시스템 메세지는 -1로 지정
            } else if self.lastSenderId == nil { // 첫 메세지일 때
                self.msgContents.append(
                    MsgContents(msgType: .message, message: msgRecord))
                self.lastSenderId = msgRecord.memberId
            } else if self.lastSenderId == msgRecord.memberId { // 같은 사람이 연속으로 보낼 때
                self.msgContents.append(
                    MsgContents(msgType: .sameSenderMessage, message: msgRecord))
                self.lastSenderId = msgRecord.memberId
            } else { // 다른 사람이 보낼 때
                self.msgContents.append(
                    MsgContents(msgType: .message, message: msgRecord))
                self.lastSenderId = msgRecord.memberId
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: self.msgContents.count-1, section: 0), at: .top, animated: true)
                print("이거", self.msgContents.count, "이전 메세지 불러온 거")
            }
        }
    }
    
    typealias CompletionHandler = () -> Void
    // 채팅 로컬에 저장하기
    private func saveMessage(msgResponse: MsgResponse, completion: CompletionHandler) {
        try! localRealm!.write {
            localRealm!.add(msgResponse)
            print("DEBUG: local에 채팅을 저장하다", msgResponse.content)
            
            // 채팅 셀에 추가하기
            if msgResponse.isSystemMessage == true {
                self.msgContents.append(
                    MsgContents(msgType: .systemMessage, message: msgResponse))
                self.lastSenderId = -1 // 시스템 메세지는 -1로 지정
            } else if self.lastSenderId == nil { // 첫 메세지일 때
                self.msgContents.append(
                    MsgContents(msgType: .message, message: msgResponse))
                self.lastSenderId = msgResponse.memberId
            } else if self.lastSenderId == msgResponse.memberId { // 같은 사람이 연속으로 보낼 때
                self.msgContents.append(
                    MsgContents(msgType: .sameSenderMessage, message: msgResponse))
                self.lastSenderId = msgResponse.memberId
            } else { // 다른 사람이 보낼 때
                self.msgContents.append(
                    MsgContents(msgType: .message, message: msgResponse))
                self.lastSenderId = msgResponse.memberId
            }
            print("이거", self.msgContents.count)
        }
        completion()
    }
    
    // 배경을 흐리게, 블러뷰로 설정
    private func showBlurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        visualEffectView.isUserInteractionEnabled = false
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
        
        // 키보드가 올라와있는 상태면 내린다.
        view.endEditing(true)
    }
    
    /* 파라미터로 온 뷰와 배경 블러뷰 함께 제거 */
    private func removeViewWithBlurView(_ view: UIView) {
        view.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
    
    // TODO: - 유저 채팅방 나가기 기능
    // TODO: - 방장 나가기 기능 -> 새 방장 선정
    
    // 연결된 웹소켓을 통해 메세지 전송
    private func sendMessage(input: MsgRequest) {
        print("DEBUG: sendMessage")
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(input)
            if let jsonString = String(data: data, encoding: .utf8),
               let socket = socket {
                print("DEBUG: 웹소켓에 write하는 Json String", jsonString)
                socket.write(string: jsonString) {
                    print("DEBUG: write success")
                    
                    // 전송 성공 시 tf 값 비우기
                    DispatchQueue.main.async {
                        self.contentsTextView.text = ""
                    }
                }
            }
        } catch {
            // TODO: - 실패하면 사용자에게 어떻게? 일단은 토스트 메세지 띄움
            print(error)
            showToast(viewController: self, message: "채팅 전송에 실패하였습니다.",
                      font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8))
        }
    }
    
    // RabbitMQ를 통해 채팅 수신
    private func receiveMsgs() {
        let conn = RMQConnection(uri: rabbitMQUri, delegate: RMQConnectionDelegateLogger())
        conn.start()
        let ch = conn.createChannel()
        let x = ch.fanout("chatting-exchange-\(String(describing: roomId))")
        let q = ch.queue("88", options: .durable)
        q.bind(x)
        print("DEBUG: [Rabbit] Waiting for logs.", ch, x, q)
        q.subscribe({(_ message: RMQMessage) -> Void in
            guard let msg = String(data: message.body, encoding: .utf8) else { return }

            // str - decode
            do {
                // MsgResponse 구조체로 decode.
                let decoder = JSONDecoder()
                let data = try decoder.decode(MsgResponse.self, from: message.body)
                print("[Rabbit] 수신", data.content)
                
                // 수신한 채팅 로컬에 저장하기
                DispatchQueue.main.async {
                    print("이거 저장 전", self.msgContents.last?.message?.content)
                    self.saveMessage(msgResponse: data) {
                        self.collectionView.reloadData()
                        print("이거 저장 후", self.msgContents.last?.message?.content, "리로드")
                        self.collectionView.scrollToItem(at: IndexPath(row: self.msgContents.count-1, section: 0), at: .top, animated: true)
                    }
                }
                
            } catch {
                print(error)
            }

            print("DEBUG: [Rabbit] Received RoutingKey: \(message.routingKey!), Message: \(msg)")
            print("DEBUG: [Rabbit] Message Info: \n consumerTag \(message.consumerTag ?? "nil값"), deliveryTag \(message.deliveryTag ?? 0), exchangeName \(message.exchangeName ?? "nil값")")
            print("DEBUG: [Rabbit] subscribe", self.msgContents.count, msg)
        })
    }
    
    private func getMessageLabelHeight(text: String) -> CGFloat {
        let label = PaddingLabel()
        label.paddingLeft = 18
        label.paddingRight = 18
        label.paddingTop = 10
        label.paddingBottom = 10
        
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.569, height: CGFloat.greatestFiniteMagnitude)
        
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
        let label = PaddingLabel()
        label.paddingLeft = 18
        label.paddingRight = 18
        label.paddingTop = 6
        label.paddingBottom = 6
        
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.783, height: CGFloat.greatestFiniteMagnitude)
        
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
    
    private func formatTime(str: String) -> String {
        let startIdx = str.index(str.startIndex, offsetBy: 11)
        let endIdx = str.index(startIdx, offsetBy: 5)
        let range = startIdx..<endIdx
        return String(str[range])
    }
    
    // MARK: - @objc Functions
    
    /* 키보드가 올라올 때 실행되는 함수 */
    @objc
    private func keyboardWillShow(sender: NSNotification) {
        // 1. 키보드의 높이를 구함
        if let info = sender.userInfo,
           let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.keyboardHeight = keyboardHeight
            // 2. collectionView의 contentInset bottom 값을 변경하여 키보드 위로 content가 올라갈 수 있도록 함
            collectionView.contentInset.bottom = keyboardHeight
            // 3. 키보드 높이만큼 bottomView의 y값을 변경
            bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            
            // 4. 맨 마지막 아이템으로 스크롤을 해줌으로써 마지막 채팅이 키보드의 위에 뜨도록 함
            self.collectionView.scrollToItem(at: IndexPath(row: self.msgRecords!.count-1, section: 0), at: .top, animated: true)
        }
    }

    /* 키보드가 내려갈 때 실행되는 함수 */
    @objc
    private func keyboardWillHide(sender: NSNotification) {
        // collectionView의 contentInset 값과 bottomView의 transform을 원래대로 변경
        collectionView.contentInset.bottom = 0
        bottomView.transform = .identity
    }
    
    /* 사진 전송 아이콘 클릭시 실행되는 함수 */
    @objc
    private func tapSendImageButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        /* 사진 선택 뷰의 크기 조정, rightBarButton title 변경 코드인데 잘 안 됨
        guard let keyboardHeight = keyboardHeight else { return }
        picker.view.frame = CGRect(x: 0, y: -(UIScreen.main.bounds.height - keyboardHeight), width: UIScreen.main.bounds.width, height: keyboardHeight)
        picker.navigationController?.navigationItem.rightBarButtonItem?.title = "전송"
        */
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    /* 왼쪽 상단 백버튼 클릭시 실행되는 함수 */
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 오른쪽 위의 톱니바퀴 버튼 클릭시 실행되는 함수 */
    @objc
    private func tapOptionButton() {
        if roomMaster == LoginModel.nickname {
            /* 방장인 경우의 액션 시트 띄우기 */
            present(ownerAlertController, animated: true)
        } else {
            /* 방장이 아닌 유저일 경우의 액션 시트 띄우기 */
            present(userAlertController, animated: true)
        }
    }
    
    /* 메세지 전송 버튼 클릭 */
    @objc
    private func tapSendButton() {
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        /* 웹소켓 통신으로 채팅 전송 */
        if let message = contentsTextView.text {
            // TODO: - 읽음 처리 할 때는 chatType read로 주기
            let input = MsgRequest(content: message,
                                   chatRoomId: roomId,
                                   isSystemMessage: false,
                                   chatType: "publish",
                                   chatId: "none",
                                   jwt: "Bearer " + LoginModel.jwt!)
            sendMessage(input: input)
        }
    }
    
    /* 송금 완료 버튼 클릭 */
    @objc
    private func tapRemittanceButton() {
        // TODO: - 송금 완료 뷰 지우기
        // TODO: - 송금 완료한 사람 저장
        // TODO: - 송금 완료 시스템 메세지 전송
        
//        self.remittanceView.removeFromSuperview()
    }
    
    /* 배경의 컬렉션뷰 클릭시 띄워져있는 안내뷰와 블러뷰를 없애는 함수 */
    @objc
    private func tapCollectionView() {
        view.endEditing(true)
        
        if visualEffectView != nil { // nil이 아니라면, 즉 옵션뷰가 노출되어 있다면
            view.subviews.forEach {
                if $0 == exitView || $0 == closeMatchingView || $0 == notificationSendView {
                    removeViewWithBlurView($0)
                }
            }
        }
    }
    
    /* 액션시트에서 배달 완료 알림 보내기 버튼 누르면 실행되는 함수 */
    @objc
    private func tapDeliveryConfirmButton() {
        // 배경 블러뷰
        showBlurBackground()
        
        // 배달완료 알림 보내기 알림뷰 등장
        view.addSubview(notificationSendView)
        notificationSendView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    /* 배달완료 알림 전송 재확인 뷰에서 '보내기' 버튼 클릭시 실행되는 함수 */
    @objc
    private func tapNotificationSendButton() {
        print("DEBUG: 클릭!!!")
        // 알림뷰 제거
        removeNotificationSendView()
        
        // 서버에 요청
        let input = DeliveryNotificationInput(uuid: roomId)
        DeliveryNotificationAPI.requestPushNotification(input) { [self] isSuccess in
            // 토스트 메세지 띄우기
            if isSuccess {
                print("DEBUG: 성공!!!")
                self.showToast(viewController: self, message: "배달완료 알림 전송이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
            } else {
                print("DEBUG: 실패!!!")
                self.showToast(viewController: self, message: "배달완료 알림 전송에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
            }
            
        }
    }
    
    /* 배달 완료 알림 전송 재확인 뷰에서 X자 눌렀을 때 실행되는 함수 */
    @objc
    private func removeNotificationSendView() {
        removeViewWithBlurView(notificationSendView)
    }
    
    /* 매칭 마감하기 버튼 누르면 실행되는 함수 */
    @objc
    private func tapCloseMatchingButton() {
        // 배경 블러뷰
        showBlurBackground()
        
        /* 매칭 마감 뷰 보여줌 */
        view.addSubview(closeMatchingView)
        closeMatchingView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /* 매칭 마감하기 뷰에서 X자 눌렀을 때 실행되는 함수 */
    @objc
    private func removeCloseMatchingView() {
        removeViewWithBlurView(closeMatchingView)
    }
    
    /* 매칭 마감하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
    @objc
    private func tapConfirmButton() {
        // TODO: - 매칭 마감 시스템 메세지 업로드
                // 매칭 마감 버튼 비활성화
//                self.ownerAlertController.actions[1].isEnabled = false
//                self.ownerAlertController.actions[1].setValue(UIColor.init(hex: 0xA8A8A8), forKey: "titleTextColor")

        // 매칭 마감하기 뷰 없애기
//        removeCloseMatchingView()
    }
    
    // 강제 퇴장시키기 버튼 누르면 실행되는 함수
    @objc
    private func tapForcedExitButton() {
        let forcedExitVC = ForcedExitViewController()
        navigationController?.pushViewController(forcedExitVC, animated: true)
    }
    
    /* 채팅 나가기 버튼 클릭시 실행 -> 재확인 뷰 띄워줌 */
    @objc
    private func tapEndOfChatButton() {
        // 배경 블러뷰
        showBlurBackground()
        
        // exitView 추가
        view.addSubview(exitView)
        exitView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(256)
            make.height.equalTo(236)
        }
    }
    
    /* 채팅 나가기에서 'X' 버튼 클릭시 실행 */
    @objc
    private func tapXButton() {
        removeViewWithBlurView(exitView)
    }
    
    /* 채팅 나가기에서 '확인' 버튼 클릭시 실행 */
    @objc
    private func tapExitConfirmButton() {
        // TODO: - 방장인지 구별하기
        // TODO: - 방장이면 새 방장 선정
        // TODO: - 방장 나감 & 새 방장 선정 시스템 메세지
        // TODO: - 방장 아니면 나갔다는 시스템 메세지만
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    /* 채팅방에 있는 상대 유저 프로필 클릭시 실행되는 함수 */
    @objc
    private func tapProfileImage() {
        let popUpView = ProfilePopUpViewController()
        popUpView.delegate = self
        popUpView.modalPresentationStyle = .overFullScreen
        popUpView.modalTransitionStyle = .crossDissolve
        self.present(popUpView, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.msgContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let msg = msgContents[indexPath.row]
        switch msg.msgType {
        case .systemMessage: // 시스템 메세지
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
            cell.systemMessageLabel.text = msg.message?.content
            print("Seori Test: sys #\(indexPath.item)", cell)
            return cell
        case .sameSenderMessage: // 같은 사람이 연속 전송
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SameSenderMessageCell", for: indexPath) as! SameSenderMessageCell
            if msg.message?.nickName == LoginModel.nickname { // 보낸 사람이 자신
                cell.rightMessageLabel.text = msg.message?.content
                cell.rightTimeLabel.text = formatTime(str: (msg.message?.createdAt)!)
                cell.leftTimeLabel.isHidden = true
                cell.leftMessageLabel.isHidden = true
            } else {
                cell.leftMessageLabel.text = msg.message?.content
                cell.leftTimeLabel.text = formatTime(str: (msg.message?.createdAt)!)
                cell.rightTimeLabel.isHidden = true
                cell.rightMessageLabel.isHidden = true
            }
            print("Seori Test: same #\(indexPath.item)", cell)
            return cell
        default: // 다른 사람이 전송
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.nicknameLabel.text = msg.message?.nickName
            if msg.message?.nickName == LoginModel.nickname { // 보낸 사람이 자신이면
                cell.rightMessageLabel.text = msg.message?.content
                cell.nicknameLabel.textAlignment = .right
                cell.rightTimeLabel.text = formatTime(str: (msg.message?.createdAt)!)
                cell.leftTimeLabel.isHidden = true
                cell.leftMessageLabel.isHidden = true
                cell.leftImageView.isHidden = true
                if self.roomMaster == msg.message?.nickName { // 방장이라면
                    cell.rightImageView.image = UIImage(named: "RoomMasterProfile")
                } else {// 방장이 아니면 기본 프로필로 설정
                    cell.rightImageView.image = UIImage(named: "DefaultProfile")
                }

                print("Seori Test: me #\(indexPath.item)", cell)
            } else {
                cell.leftImageView.isUserInteractionEnabled = true
                cell.leftImageView.addTarget(self, action: #selector(tapProfileImage), for: .touchUpInside)
                cell.leftMessageLabel.text = msg.message?.content
                cell.nicknameLabel.textAlignment = .left
                cell.leftTimeLabel.text = formatTime(str: (msg.message?.createdAt)!)
                cell.rightTimeLabel.isHidden = true
                cell.rightMessageLabel.isHidden = true
                cell.rightImageView.isHidden = true
                if self.roomMaster == msg.message?.nickName { // 방장이라면
                    cell.leftImageView.setImage(UIImage(named: "RoomMasterProfile"), for: .normal)
                } else {// 방장이 아니면 기본 프로필로 설정
                    cell.leftImageView.setImage(UIImage(named: "DefaultProfile"), for: .normal)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        let msg = msgContents[indexPath.row]
        
        switch msg.msgType {
        case .systemMessage:
            let labelHeight = getSystemMessageLabelHeight(text: msg.message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // padding top, bottom = 6
        case .message:
            // content의 크기에 맞는 라벨을 정의하고 해당 라벨의 높이가 40 초과 (두 줄 이상) or 40 (한 줄) 비교하여 높이 적용
            let labelHeight = getMessageLabelHeight(text: msg.message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight + 16) // 상하 여백 20 + 닉네임 라벨
        case .sameSenderMessage:
            let labelHeight = getMessageLabelHeight(text: msg.message?.content ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // label 상하 여백 20
        default:
            cellSize = CGSize(width: view.bounds.width, height: 40)
        }
        
        return cellSize
    }
    
}

// MARK: - UITextViewDelegate

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

// MARK: - PushReportUserDelegate

extension ChattingViewController: PushReportUserDelegate {
    public func pushReportUserVC() {
        let reportUserVC = ReportUserViewController()
        self.navigationController?.pushViewController(reportUserVC, animated: true)
    }
}

// MARK: - WebSocketDelegate

extension ChattingViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("DEBUG: 웹소켓 연결 완료 - \(headers)")
        case .disconnected(let reason, let code):
            print("DEBUG: 웹소켓 연결 끊어짐 - \(reason) with code: \(code)")
        case .text(let text):
            print("DEBUG: text")
            guard let data = text.data(using: .utf16),
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                  let res = jsonData as? MsgRequest,
                  let _ = res.content else {
                return
            }
        case .binary(let data):
            print("DEBUG: binary - Received data: \(data.count)")
        case .ping(_):
            print("DEBUG: ping")
            break
        case .pong(_):
            print("DEBUG: pong")
            break
        case .viabilityChanged(_):
            print("DEBUG: viabilityChanged")
            break
        case .reconnectSuggested(_):
            print("DEBUG: reconnectSuggested")
            break
        case .cancelled:
            print("DEBUG: websocket is cancelled")
        case .error(let error):
            print("DEBUG: 에러 websocket is error = \(error!)")
        }
    }
}

extension ChattingViewController: PHPickerViewControllerDelegate {
    /* 사진 선택이 완료되었을 때 */
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("사진 선택 완료")
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    guard let imageData = image as? UIImage else { return }
                    let input = ChatImageSendInput(
                        chatId: "none",
                        chatRootId: self.roomId,
                        chatType: "publish",
                        content: "content",
                        email: "dmstn@gachon.ac.kr",
                        isImageMessage: true,
                        isSystemMessage: false,
                        profileImgUrl: "더미"
                    )
                    
                    ChatAPI.sendImage(input, imageData: imageData) { isSuccess in
                        if isSuccess {
                            print("이미지 전송 성공")
                        }
                    }
                    
                }
            }
        }
    }
}

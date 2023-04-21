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
    func pushReportUserVC(memberId: Int)
}

protocol PresentPopUpViewDelegate {
    func getInfoMember(memberId: Int, profileImg: UIImage)
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
    lazy var sendImageButton = UIButton().then {
        $0.setImage(UIImage(named: "SendImage"), for: .normal)
        $0.addTarget(self, action: #selector(tapSendImageButton), for: .touchUpInside)
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
            $0.text = "채팅 나가기"
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
            make.height.equalTo(186)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "이 채팅방을 나간 후로는\n채팅에 참여할 수 없어요.\n채팅 나가기를 진행할까요?"
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
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(40)
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
            $0.text = "매칭을 종료할 시\n본 파티에 대한 추가 인원이\n더 이상 모집되지 않아요.\n매칭 마감을 진행할까요?"
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
    
    // 계좌번호 label
    lazy var accountLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .init(hex: 0x2F2F2F)
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAccountLabel)))
    }
    
    // 송금하기 상단 뷰 (Firestore의 participant의 isRemittance 값이 false인 경우에만 노출)
    lazy var remittanceView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF6F9FB)
        view.layer.opacity = 0.9
        
        let coinImageView = UIImageView().then {
            $0.image = UIImage(named: "RemittanceIcon")
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
            $0.addTarget(self, action: #selector(tapOrderCompleted), for: .touchUpInside)
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
    
    // MARK: - Properties
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private var socket: WebSocket? = nil
    private var conn: RMQConnection? = nil  // rabbitmq 채널 변수
    private let rabbitMQUri = "amqp://\(Keys.idPw)@\(Keys.address)"
    
    enum MsgType {
        case message
        case sameSenderMessage
        case systemMessage
    }

    struct MsgContents {
        var msgType: MsgType?
        var message: MsgToSave?
    }
    
    var msgContents: [MsgContents] = []
    var msgRecords: Results<MsgToSave>?
    
    // 선택한 채팅방의 id값
    var roomId: String?
    var roomName: String?
    var lastSenderId: Int? = nil
    var roomInfo: ChattingRoomResult? // 채팅방의 상세 정보
    var enterTimeToDate: Date?  // 채팅방 입장 시간 - Date 타입
    
    var keyboardHeight: CGFloat? // 키보드 높이
    
    // Realm 싱글톤 객체 가져오기
    private let localRealm = DataBaseManager.shared
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        msgContents.append(MsgContents(msgType: .message, message: MsgToSave(chatId: "", content: "http://placeimg.com/155/154/any", chatRoomId: "", isSystemMessage: false, memberId: 1, nickName: "애플플", profileImgUrl: "", createdAt: Date(), unreadMemberCnt: 0, isImageMessage: true)))
        
        // 웹소켓 설정
        setupWebSocket()
        // RabbitMq 수신 설정
        setupReceiver()
        
        setAttributes()
        setCollectionView()
        addSubViews()
        setLayouts()
        
        // db 경로 출력
        localRealm.getLocationOfDefaultRealm()
        
        // 다른 VC에서 여기에 토스트 메세지를 띄우기 위한 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(completeForcedExit), name: NSNotification.Name("CompleteForcedExit"), object: nil)
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
        // 웹소켓 해제
        socket?.disconnect()
        socket?.delegate = nil
        
        // RabbitMQ Connection 끊기
        conn?.close()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 사라질 때 다시 탭바 보이게 설정
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        collectionView.endEditing(true)
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
    
    // RabbitMQ를 통해 채팅 수신
    private func setupReceiver() {
        // RabbitMQ 연결
        conn = RMQConnection(uri: rabbitMQUri, delegate: RMQConnectionDelegateLogger())
        conn!.start()
        
        // 채널 생성
        let ch = conn!.createChannel()
        // fanout 방식 사용
        let x = ch.fanout("chatting-exchange-\(String(describing: roomId))")
        
        // 큐 생성, 바인딩
        let q = ch.queue("\(LoginModel.memberId ?? 0)", options: .durable)
        q.bind(x)
        print("=====: ", LoginModel.memberId)
        print("DEBUG: [Rabbit] 수신 대기 중", ch, x, q)
        
        // 큐 수신 리스너 설치 -> 메세지 수신 시 실행될 코드 작성
        q.subscribe({(_ message: RMQMessage) -> Void in
            // 디코딩
            do {
                // MsgResponse 구조체로 decode.
                let decoder = JSONDecoder()
                let data = try decoder.decode(MsgResponse.self, from: message.body)
                
                // 새 메세지 수신 시
                if data.chatType! == "publish" {
                    print("[Rabbit] 채팅방에서 채팅 수신", data)
                    // String 날짜를 Date 형태로 변경
                    let createdAtDate = FormatCreater.sharedLongFormat.date(from: data.createdAt!)
                    
                    // 로컬에 저장하기 위한 데이터 구조를 만든다.
                    let msgToSave = MsgToSave(chatId: data.chatId!,
                                              content: data.content!,
                                              chatRoomId: data.chatRoomId!,
                                              isSystemMessage: data.isSystemMessage!,
                                              memberId: data.memberId!,
                                              nickName: data.nickName!,
                                              profileImgUrl: data.profileImgUrl ?? "",
                                              createdAt: createdAtDate ?? Date(),
                                              unreadMemberCnt: data.unreadMemberCnt!,
                                              isImageMessage: data.isImageMessage!)
                    
                    // 수신한 채팅 로컬에 저장하기
                    self.saveMessage(msgToSave: msgToSave)
                    
                    // 컬렉션뷰 셀 업데이트
                    self.updateChattingView(newChat: msgToSave)
                } else if data.chatType! == "read" {  // 읽음 요청 응답 수신 시
                    print("[Rabbit] 채팅방에서 채팅 읽음 수신", data)
                    
                    // 로컬에 isRead 값을 true로, unreadCnt도 수신한 값으로 업데이트
                    self.updateUnreadToRead(data: data)
                } else if data.chatType! == "ban" {
                    // 강제퇴장 당했다는 것
                    // alert 뷰 띄워주기
                    print("[Rabbit] 채팅방에서 강제퇴장 알림 수신", data)
                }
            } catch {
                print(error)
            }
        })
    }
    
    // 채팅방 상세조회 API 호출
    private func getRoomInfo() {
        MyLoadingView.shared.show()
        
        print("DEBUG: [1] getRoomInfo")
        ChatAPI.getChattingRoomInfo(ChattingRoomInput(chatRoomId: roomId)) { result in
            MyLoadingView.shared.hide()
            
            // 조회 성공 시
            if let res = result {
                print("DEBUG: 채팅방 \(self.roomId!)의 상세 정보", res)
                self.roomInfo = res
                print("roomInfo: ", self.roomInfo)
                self.enterTimeToDate = FormatCreater.sharedLongFormat.date(from: self.roomInfo?.enterTime ?? "2023-01-01 00:00:00")
                print("DEBUG: 내 입장 시간", self.enterTimeToDate)
                
                // 방장이 아니고, 아직 송금을 안 했다면 송금완료 뷰 띄우기
                if (!(self.roomInfo!.isChief!) && !(self.roomInfo!.isRemittanceFinish!)) {
                    self.showTopView(view: self.remittanceView)
                    self.accountLabel.text = "\(self.roomInfo?.bank ?? "은행")  \(self.roomInfo?.accountNumber ?? "000-0000-0000-00")"
                } else if (self.roomInfo!.isChief! && !(self.roomInfo!.isOrderFinish!)) {  // 방장이고 주문 완료 안 했다면 주문완료 뷰 띄우기
                    self.showTopView(view: self.orderCompletedView)
                }
                
                // 매칭 마감됐으면 매칭 마감 버튼 비활성화
                if (self.roomInfo!.isMatchingFinish ?? false) {
                    self.setInactiveButton(index: 1)
                }
                
                // 성공 시에만 이전 메세지 불러오기 -> 순서대로 처리하기 위해
                self.loadMessages()
                
                // 안 읽은 메세지 있나 확인
                let unreadMsgs = self.getUnreadMsgs()
                if !(unreadMsgs.isEmpty) {
                    print("DEBUG: 안 읽은 메세지 있음!!")
                    // 읽음 요청 전송
                    self.sendReadRequest(unreadMsgs)
                } else {
                    print("DEBUG: 안 읽은 메세지 없음")
                }
            } else { // 실패 시
                self.showToast(viewController: self, message: "채팅방 정보 조회에 실패하였습니다.",
                          font: .customFont(.neoMedium, size: 13), color: UIColor(hex: 0xA8A8A8))
            }
        }
    }
    
    private func setAttributes() {
        contentsTextView.delegate = self
        sendImageButton.addTarget(self, action: #selector(tapSendImageButton), for: .touchUpInside)
        
        // top에 padding 설정
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
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
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 11.6)
        }
        
        sendImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(33)
            make.left.equalToSuperview().inset(screenWidth / 18)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(screenWidth / 16.4)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(sendImageButton.snp.right).offset(screenWidth / 27.7)
            make.width.equalTo(screenWidth / 1.6)
            make.height.equalTo(screenHeight / 20)
        }
    }
    
    private func setCollectionView() {
        collectionView.register(SystemMessageCell.self, forCellWithReuseIdentifier: "SystemMessageCell")
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView.register(SameSenderMessageCell.self, forCellWithReuseIdentifier: "SameSenderMessageCell")
        collectionView.register(ImageMessageCell.self, forCellWithReuseIdentifier: "ImageMessageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 상단에 송금완료 뷰(파티원일 때) 또는 주문완료 뷰(방장일 때) 띄우기
    private func showTopView(view: UIView) {
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(55)
        }
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
    
    // 로컬에서 이전 채팅 불러오기
    private func loadMessages() {
        if self.enterTimeToDate == nil {
            self.enterTimeToDate = Date()
        }
        
        print("DEBUG: [2] loadMessages")
        // 로컬에서 해당 채팅방의, 입장시간 이후의 채팅 데이터 가져오기
        let predicate = NSPredicate(format: "chatRoomId = %@ AND createdAt >= %@", self.roomId!, self.enterTimeToDate! as CVarArg)
        self.msgRecords = self.localRealm.read(MsgToSave.self).filter(predicate).sorted(byKeyPath: "createdAt")

        guard let msgRecords = msgRecords else { return }
        print("DEBUG: 불러온 채팅 갯수", msgRecords.count)
        for msgRecord in msgRecords {
            self.updateChattingView(newChat: msgRecord)
        }
    }
    
    // 안 읽은 메세지 가져오기
    private func getUnreadMsgs() -> [MsgContents] {
        print("DEBUG: [3] getUnreadMsgs")
        // 로드된 이전 메세지들 중에 안 읽은 메세지이고, 시스템 메세지가 아니고, 상대방이 보낸 메세지만 필터링
        return self.msgContents.filter { msg in
            msg.message?.isRead == false
            && msg.message?.isSystemMessage == false
            && msg.message?.memberId != LoginModel.memberId
        }
    }
    
    // 채팅 로컬에 저장하기
    private func saveMessage(msgToSave: MsgToSave) {
        DispatchQueue.main.async {
            self.localRealm.write(msgToSave)
            
            // 상대방이 보낸 채팅인데, 내가 지금 채팅방 화면을 보고 있는 경우
            if msgToSave.memberId != LoginModel.memberId {
                guard let last = self.msgContents.last else { return }
                // 바로 읽음 처리 요청 => 실시간 읽음 처리
                self.sendReadRequest([last])
            }
        }
    }
    
    // 새 채팅을 컬렉션뷰 셀에 추가하기
    private func updateChattingView(newChat: MsgToSave) {
        if newChat.isSystemMessage == true {
            self.msgContents.append(
                MsgContents(msgType: .systemMessage, message: newChat))
            self.lastSenderId = -1 // 시스템 메세지는 -1로 지정
        } else if self.lastSenderId == nil { // 첫 메세지일 때
            self.msgContents.append(
                MsgContents(msgType: .message, message: newChat))
            self.lastSenderId = newChat.memberId
        } else if self.lastSenderId == newChat.memberId { // 같은 사람이 연속으로 보낼 때
            self.msgContents.append(
                MsgContents(msgType: .sameSenderMessage, message: newChat))
            self.lastSenderId = newChat.memberId
        } else { // 다른 사람이 보낼 때
            self.msgContents.append(
                MsgContents(msgType: .message, message: newChat))
            self.lastSenderId = newChat.memberId
        }
        
        // 컬렉션뷰 리로드, 새로 추가된 셀로 스크롤 이동
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(row: self.msgContents.count-1, section: 0), at: .top, animated: true)
        }
    }
    
    // 웹소켓을 통해 읽음 요청 보내기
    private func sendReadRequest(_ unreadMsgs: [MsgContents]) {
        print("DEBUG: [4] sendReadRequest")
        print("DEBUG: unreadMsgs", unreadMsgs)
        // 하나씩 읽음 처리 요청 보내기
        for unreadMsg in unreadMsgs {
            print("DEBUG: 읽음 요청", unreadMsg)
            self.sendMessage(input: MsgRequest(
                content: unreadMsg.message?.content,
                chatRoomId: unreadMsg.message?.chatRoomId,
                isSystemMessage: unreadMsg.message?.isSystemMessage,
                chatType: "read",
                chatId: unreadMsg.message?.chatId,
                jwt: "Bearer " + LoginModel.jwt!))
        }
    }
    
    // 로컬에 저장된 isRead 필드값을 true로 업데이트
    // -> 내 채팅에 대한 상대방의 읽음 요청일 수도 있다. 그래서 memberId로 구분 안 함
    private func updateUnreadToRead(data: MsgResponse) {
        DispatchQueue.main.async {
            print("DEBUG: updateUnreadToRead")
            let predicate = NSPredicate(format: "chatRoomId = %@ AND isRead = false AND isSystemMessage = false", self.roomId!)
            let unreadMsgsInDB = self.localRealm.read(MsgToSave.self).filter(predicate).sorted(byKeyPath: "createdAt")
            print("DEBUG: 안 읽은 메세지들", unreadMsgsInDB)
            
            // 하나씩 로컬 데이터 업데이트
            unreadMsgsInDB.forEach { unreadMsg in
                self.localRealm.update(unreadMsg) { unreadMsg in
                    unreadMsg.isRead = true
                    unreadMsg.unreadMemberCnt = data.unreadMemberCnt
                    print("DEBUG: 읽음 상태 업데이트", data.content)
                }
            }
            
            // 읽음 표시 UI 업데이트를 위해 채팅 다시 불러오기
            self.msgContents.removeAll()
            self.loadMessages()
        }
    }
    
    // 연결된 웹소켓을 통해 메세지 전송
    private func sendMessage(input: MsgRequest) {
        print("DEBUG: sendMessage", input.chatType, socket)
        do {
            // 메세지 string으로 인코딩
            let encoder = JSONEncoder()
            let data = try encoder.encode(input)
            if let jsonString = String(data: data, encoding: .utf8),
               let socket = socket {
                print("DEBUG: 웹소켓에 write하는 Json String", jsonString)
                // 웹소켓에 전송
                socket.write(string: jsonString) {
                    print("TEST: write")
                    // 새 채팅 전송일 때
                    if input.chatType! == "publish" {
                        print("DEBUG: 웹소켓 채팅 전송 성공")
                        // 전송 성공 시 tf 값 비우기
                        DispatchQueue.main.async {
                            self.contentsTextView.text = ""
                        }
                    } else if input.chatType! == "read" {
                        // 읽음 요청 전송일 때
                        print("DEBUG: 읽음 처리 요청 전송 성공")
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
    
    // 해당 index의 버튼 비활성화 시키기
    private func setInactiveButton(index: Int) {
        self.ownerAlertController.actions[index].isEnabled = false
        self.ownerAlertController.actions[index].setValue(UIColor.init(hex: 0xA8A8A8), forKey: "titleTextColor")
    }
    
    /* 상대방의 프로필 클릭 시 실행 -> 팝업 VC를 띄워준다 */
    private func presentPopUpView(memberId: Int, profileImg: UIImage, model: ChattingMemberResultModel) {
        guard let nickName = model.userName,
                let grade = model.grade,
                let isChief = model.isChief else { return }
        let popUpView = ProfilePopUpViewController(memberId: memberId,
                                                   profileImg: profileImg,
                                                   nickNameStr: nickName,
                                                   gradeStr: grade,
                                                   isChief: isChief)
        popUpView.delegate = self
        popUpView.modalPresentationStyle = .overFullScreen
        popUpView.modalTransitionStyle = .crossDissolve
        self.present(popUpView, animated: true)
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
        configuration.selectionLimit = 3 // 사진 최대 3개까지 선택 가능
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    /* 오른쪽 위의 톱니바퀴 버튼 클릭시 실행되는 함수 */
    @objc
    private func tapOptionButton() {
        if self.roomInfo?.isChief ?? false {
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
        
        /* 웹소켓 통신으로 채팅 전송 */
        if let message = contentsTextView.text {
            let input = MsgRequest(content: message,
                                   chatRoomId: roomId,
                                   isSystemMessage: false,
                                   chatType: "publish",
                                   chatId: "none",
                                   jwt: "Bearer " + LoginModel.jwt!)
            sendMessage(input: input)
        }
    }
    
    /* 계좌번호 label 클릭 -> 계좌번호 클립보드에 복사, 토스트 띄우기 */
    @objc
    private func tapAccountLabel() {
        UIPasteboard.general.string = accountLabel.text?.replacingOccurrences(of: "-", with: "")
        self.showBottomToast(viewController: self, message: "클립보드에 복사되었습니다", font: .customFont(.neoMedium, size: 13), color: .lightGray)
    }
    
    
    /* 송금 완료 버튼 클릭 */
    @objc
    private func tapRemittanceButton() {
        let input = CompleteRemittanceInput(roomId: roomId)
        ChatAPI.completeRemittance(input) { isSuccess in
            if isSuccess {
                self.showToast(viewController: self, message: "송금이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 184, height: 59)
                self.remittanceView.removeFromSuperview()
            } else {
                print("송금 실패")
            }
        }
        
    }
    
    /* 주문 완료 버튼 클릭 */
    @objc
    private func tapOrderCompleted() {
        guard let roomId = self.roomId else { return }
        let orderCompletedInput = OrderCompletedInput(roomId: roomId)
        
        ChatAPI.orderCompleted(orderCompletedInput) { model in
            if let model = model {
                if model.code == 1000 {
                    self.orderCompletedView.removeFromSuperview()
                }else if model.code == 2409 || model.code == 2410 {
                    // 매칭 마감이 아직 안 된 상태에서 주문완료를 하려는 경우
                    self.showToast(viewController: self, message: "매칭 마감을 먼저 해주세요!", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
                } else {
                    self.showToast(viewController: self, message: "주문완료에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
                }
            } else {
                self.showToast(viewController: self, message: "주문완료에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
            }
        }
    }
    
    /* 배경의 컬렉션뷰 클릭시 띄워져있는 안내뷰와 블러뷰를 없애는 함수 */
    @objc
    private func tapCollectionView() {
        view.endEditing(true)
        
        if visualEffectView != nil { // nil이 아니라면, 즉 옵션뷰가 노출되어 있다면
            visualEffectView?.removeFromSuperview()
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
        
        // 서버에 푸시 알림 요청
        let input = CompleteDeliveryInput(roomId: roomId)
        ChatAPI.completeDelivery(input) { isSuccess, model in
            // 토스트 메세지 띄우기
            if isSuccess {
                self.showToast(viewController: self, message: "배달완료 알림 전송이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
            } else {
                if model?.code == 2409 || model?.code == 2410 {
                    // 매칭 마감이 아직 안 된 상태에서 배달 완료하려는 경우
                    self.showToast(viewController: self, message: "매칭 마감을 먼저 해주세요!", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
                } else {
                    self.showToast(viewController: self, message: "배달완료 알림 전송에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
                }
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
        ChatAPI.closeMatching(CloseMatchingInput(partyId: self.roomInfo?.partyId)) { model in
            if let model = model {
                switch model.code {
                case 1000:
                    print("DEBUG: 매칭 마감 성공")
                    // 매칭 마감 버튼 비활성화
                    self.setInactiveButton(index: 1)
                case 2616:
                    self.showToast(viewController: self, message: "이미 마감된 방입니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 240)
                default:
                    self.showToast(viewController: self, message: "매칭 마감이 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 240)
                }
            } else {
                print("DEBUG: 매칭 마감 실패")
                self.showToast(viewController: self, message: "매칭 마감이 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 240)
            }
        }
        
        // 매칭 마감하기 뷰 없애기
        removeCloseMatchingView()
    }
    
    // 강제 퇴장시키기 버튼 누르면 실행되는 함수
    @objc
    private func tapForcedExitButton() {
        guard let roomId = roomId,
              let partyId = self.roomInfo?.partyId else { return }
        let forcedExitVC = ForcedExitViewController(partyId: partyId, roomId: roomId)
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
        // 방장이라면
        if self.roomInfo?.isChief ?? false {
            // 1. 방장 배달 파티 나가기
            let partyInput = ExitPartyChiefInput(partyId: self.roomInfo?.partyId)
            PartyAPI.exitPartyChief(partyInput) { isSuccess in
                if isSuccess {
                    print("DEBUG: 방장 배달파티 나가기 성공", partyInput)
                    // 2. 방장 채팅방 나가기
                    let chatInput = ExitChiefInput(roomId: self.roomId)
                    ChatAPI.exitChief(chatInput) { isSuccess in
                        if isSuccess {
                            print("DEBUG: 방장 채팅방 나가기 성공", chatInput)
                            self.navigationController?.popViewController(animated: true)
                            // 채팅 목록 VC에 토스트 메세지 띄우기
                            NotificationCenter.default.post(name: NSNotification.Name("CompleteExit"), object: nil)
                        } else {
                            print("방장 채팅방 나가기 실패", chatInput)
                            self.showToast(viewController: self, message: "채팅방 나가기가 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 250)
                        }
                    }
                } else {
                    print("방장 파티 나가기 실패", partyInput)
                }
            }
        } else {
            // 1. 파티원 배달파티 나가기
            let partyInput = ExitPartyMemberInput(partyId: self.roomInfo?.partyId)
            PartyAPI.exitPartyMember(partyInput) { isSuccess in
                if isSuccess {
                    print("DEBUG: 파티원 배달파티 나가기 성공", partyInput)
                    // 2. 파티원 채팅방 나가기
                    let chatInput = ExitMemberInput(roomId: self.roomId)
                    ChatAPI.exitMember(chatInput) { isSuccess in
                        if isSuccess {
                            print("DEBUG: 파티원 채팅방 나가기 성공", chatInput)
                            self.navigationController?.popViewController(animated: true)
                            // 채팅 목록 VC에 토스트 메세지 띄우기
                            NotificationCenter.default.post(name: NSNotification.Name("CompleteExit"), object: nil)
                        } else {
                            print("DEBUG: 파티원 채팅방 나가기 실패", chatInput)
                            self.showToast(viewController: self, message: "채팅방 나가기가 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 250)
                        }
                    }
                } else {
                    print("파티원 파티 나가기 실패", partyInput)
                }
            }
        }
    }
    
    @objc
    private func tapImageMessageCell(_ sender: UITapGestureRecognizerWithParam) {
        let imageCellVC = ImageCellViewController()
        
        let msg = self.msgContents[sender.index!]
        imageCellVC.nickname = msg.message?.nickName

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: (msg.message?.createdAt)!)
        imageCellVC.date = dateString

        let imageUrl = URL(string: (msg.message?.content)!)
        imageCellVC.imageUrl = imageUrl
        
        imageCellVC.modalPresentationStyle = .overFullScreen
        imageCellVC.modalTransitionStyle = .crossDissolve
        self.present(imageCellVC, animated: true)
    }
    
    // 강제퇴장 완료 토스트 메세지 띄우기
    @objc
    private func completeForcedExit() {
        self.showToast(viewController: self,
                       message: "강제 퇴장이 완료되었습니다",
                       font: .customFont(.neoBold, size: 15),
                       color: .mainColor, width: 229)
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
        guard let isImageMessage = msg.message?.isImageMessage else { return UICollectionViewCell() }
        switch msg.msgType {
        case .systemMessage: // 시스템 메세지
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
            cell.systemMessageLabel.text = msg.message?.content
            return cell
        case .sameSenderMessage: // 보냈던 사람이 연속 전송
            // 채팅이 이미지일 때
            if isImageMessage {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageMessageCell.identifier, for: indexPath) as! ImageMessageCell
                
                /* imageCell에 tap gesture 추가 (이미지 확대 기능 위해) */
                let tapGesture = UITapGestureRecognizerWithParam(target: self, action: #selector(tapImageMessageCell))
                tapGesture.index = indexPath.row
                
                cell.nicknameLabel.isHidden = true
                cell.rightProfileImageView.isHidden = true
                cell.leftProfileImageView.isHidden = true
                
                if msg.message?.memberId == LoginModel.memberId { // 보낸 사람이 자신
                    if let contentUrl = msg.message?.content {
                        cell.rightImageView.kf.setImage(with: URL(string: contentUrl))
                        print("TEST:", contentUrl)
                    }
                    cell.rightImageMessageView.addGestureRecognizer(tapGesture)
                    cell.rightTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.rightUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.leftImageView.isHidden = true
                    cell.leftImageMessageView.isHidden = true
                    cell.leftTimeLabel.isHidden = true
                    cell.leftUnreadCntLabel.isHidden = true
                } else {
                    if let contentUrl = msg.message?.content {
                        cell.leftImageView.kf.setImage(with: URL(string: contentUrl))
                        print("DEBUG: 사진 Url", contentUrl)
                    }
                    cell.leftImageMessageView.addGestureRecognizer(tapGesture)
                    cell.leftTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.leftUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.rightImageView.isHidden = true
                    cell.rightImageMessageView.isHidden = true
                    cell.rightTimeLabel.isHidden = true
                    cell.rightUnreadCntLabel.isHidden = true
                }
                return cell
            } else {
                // TODO: SameSenderMessageCell 필요없을지도? MessageCell로 쓰고 이미지셀처럼 same sender일 때 닉네임 프사 isHidden 처리하면 됨
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SameSenderMessageCell", for: indexPath) as! SameSenderMessageCell
                if msg.message?.memberId == LoginModel.memberId { // 보낸 사람이 자신
                    cell.rightMessageLabel.text = msg.message?.content
                    cell.rightTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.rightUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.leftTimeLabel.isHidden = true
                    cell.leftMessageLabel.isHidden = true
                    cell.leftUnreadCntLabel.isHidden = true
                } else {
                    cell.leftMessageLabel.text = msg.message?.content
                    cell.leftTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.leftUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.rightTimeLabel.isHidden = true
                    cell.rightMessageLabel.isHidden = true
                    cell.rightUnreadCntLabel.isHidden = true
                }
                return cell
            }
        default: // new 사람이 채팅 시작
            // 채팅이 이미지일 때
            if isImageMessage {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageMessageCell.identifier, for: indexPath) as! ImageMessageCell
                cell.delegate = self
                
                let tapGesture = UITapGestureRecognizerWithParam(target: self, action: #selector(tapImageMessageCell))
                tapGesture.index = indexPath.row
                
                cell.nicknameLabel.text = msg.message?.nickName
                cell.memberId = msg.message?.memberId
                if msg.message?.memberId == LoginModel.memberId { // 그 사람이 자신이면
                    cell.rightImageMessageView.addGestureRecognizer(tapGesture)
                    cell.nicknameLabel.textAlignment = .right
                    // nil 아니면 프로필 이미지로 설정
                    if let profileImgUrl = msg.message?.profileImgUrl {
                        cell.rightProfileImageView.kf.setImage(with: URL(string: profileImgUrl))
                        print("[TEST]", msg.message, profileImgUrl)
                    }
                    if self.roomInfo?.chiefId == msg.message?.memberId {
                        // 방장이라면 프로필 테두리
                        cell.rightProfileImageView.drawBorderToChief()
                    }
                    if let contentUrl = msg.message?.content {
                        cell.rightImageView.kf.setImage(with: URL(string: contentUrl))
                    }
                    cell.rightTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.rightUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.leftProfileImageView.isHidden = true
                    cell.leftImageView.isHidden = true
                    cell.leftImageMessageView.isHidden = true
                    cell.leftTimeLabel.isHidden = true
                    cell.leftUnreadCntLabel.isHidden = true
                } else { // 다른 사람이면
                    cell.leftImageMessageView.addGestureRecognizer(tapGesture)
                    cell.nicknameLabel.textAlignment = .left
                    if let profileImgUrl = msg.message?.profileImgUrl {
                        cell.leftProfileImageView.kf.setImage(with: URL(string: profileImgUrl))
                    }
                    if self.roomInfo?.chiefId == msg.message?.memberId {
                        // 방장이라면 프로필 테두리
                        cell.leftProfileImageView.drawBorderToChief()
                    }
                    if let contentUrl = msg.message?.content {
                        cell.leftImageView.kf.setImage(with: URL(string: contentUrl))
                    }
                    cell.leftTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.leftUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.rightProfileImageView.isHidden = true
                    cell.rightImageView.isHidden = true
                    cell.rightImageMessageView.isHidden = true
                    cell.rightTimeLabel.isHidden = true
                    cell.rightUnreadCntLabel.isHidden = true
                }
                return cell
            } else { // 이미지가 아닐 때
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
                cell.delegate = self
                cell.nicknameLabel.text = msg.message?.nickName
                cell.memberId = msg.message?.memberId
                if msg.message?.memberId == LoginModel.memberId { // 그 사람이 자신이면
                    cell.nicknameLabel.textAlignment = .right
                    // nil 아니면 프로필 이미지로 설정
                    if let profileImgUrl = msg.message?.profileImgUrl {
                        cell.rightImageView.kf.setImage(with: URL(string: profileImgUrl))
                    }
                    if self.roomInfo?.chiefId == msg.message?.memberId {
                        // 방장이라면 프로필 테두리
                        cell.rightImageView.drawBorderToChief()
                    }
                    cell.rightMessageLabel.text = msg.message?.content
                    cell.rightTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.rightUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.leftImageView.isHidden = true
                    cell.leftMessageLabel.isHidden = true
                    cell.leftTimeLabel.isHidden = true
                    cell.leftUnreadCntLabel.isHidden = true
                } else { // 다른 사람이면
                    if let profileImgStr = msg.message?.profileImgUrl {
                        let url = URL(string: profileImgStr)
                        cell.leftImageView.kf.setImage(with: url)
                    }
                    if self.roomInfo?.chiefId == msg.message?.memberId {
                        // 방장이라면 프로필 테두리
                        cell.leftImageView.drawBorderToChief()
                    }
                    cell.nicknameLabel.textAlignment = .left
                    cell.leftMessageLabel.text = msg.message?.content
                    cell.leftTimeLabel.text = FormatCreater.sharedTimeFormat.string(from: (msg.message?.createdAt)!)
                    cell.leftUnreadCntLabel.text = "\(msg.message?.unreadMemberCnt ?? 0)"
                    cell.rightImageView.isHidden = true
                    cell.rightMessageLabel.isHidden = true
                    cell.rightTimeLabel.isHidden = true
                    cell.rightUnreadCntLabel.isHidden = true
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        let msg = msgContents[indexPath.row]
        guard let isImageMessage = msg.message?.isImageMessage else { return CGSize() }
        if isImageMessage {
            if msg.msgType == .message {
                cellSize = CGSize(width: view.bounds.width, height: 170)
            } else {
                cellSize = CGSize(width: view.bounds.width, height: 155)
            }
        } else {
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
    public func pushReportUserVC(memberId: Int) {
        guard let partyId = self.roomInfo?.partyId else { return }
        let reportUserVC = ReportUserViewController(partyId: partyId, memberId: memberId)
        self.navigationController?.pushViewController(reportUserVC, animated: true)
    }
}

// MARK: - PresentPopUpViewDelegate

extension ChattingViewController: PresentPopUpViewDelegate {
    // 상대 프로필 클릭 시 해당 멤버의 정보 불러오기
    public func getInfoMember(memberId: Int, profileImg: UIImage) {
        MyLoadingView.shared.show()
        
        ChatAPI.getInfoChattingMember(input: ChattingMemberInput(chatRoomId: self.roomId, memberId: memberId)) { result in
            MyLoadingView.shared.hide()
            if let res = result {
                // 정보 불러오기 성공 시 프로필 팝업뷰로 화면 전환
                self.presentPopUpView(memberId: Int(LoginModel.memberId ?? 0), profileImg: profileImg, model: res)
            } else {
                self.showToast(viewController: self, message: "멤버 정보 조회에 실패했어요", font: .customFont(.neoBold, size: 15), color: .mainColor)
            }
        }
    }
}

// MARK: - WebSocketDelegate

extension ChattingViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        // 웹소켓 연결 완료됐을 때 실행
        case .connected(let headers):
            print("DEBUG: [0] 웹소켓 연결 완료 - \(headers)")
            // 채팅방 정보 요청
            getRoomInfo()
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
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ChattingViewController: PHPickerViewControllerDelegate {
    /* 사진 선택이 완료되었을 때 */
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if !(results.isEmpty) {
            let itemProviders = results.map { $0.itemProvider }
            var images: [UIImage] = []
            for item in itemProviders {
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            guard let imageData = image as? UIImage else { return }
                            print("이미지 추출 완료")
                            images.append(imageData)
                        }
                    }
                }
            }
            
            let sheet = UIAlertController(title: "사진 전송", message: "선택한 사진을 전송하시겠어요?", preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "전송", style: .default, handler: { _ in
                MyLoadingView.shared.show()
                
                let input = ChatImageSendInput(
                    chatId: "none",
                    chatRoomId: self.roomId,
                    chatType: "publish",
                    content: "",
                    isImageMessage: true,
                    isSystemMessage: false
                )
                
                ChatAPI.sendImage(input, imageData: images) { model in
                    MyLoadingView.shared.hide()
                    if let model = model {
                        switch model.code {
                        case 1000:
                            print("이미지 전송 성공")
                        case 2029, 2030:
                            self.showToast(viewController: self, message: "이미지 용량이 커서 전송에 실패했어요", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 248, height: 40)
                        default:
                            print("이미지 전송 실패")
                            self.showToast(viewController: self, message: "이미지 전송에 실패했어요", font: .customFont(.neoBold, size: 15), color: .mainColor)
                        }
                    } else {
                        print("이미지 전송 실패")
                        self.showToast(viewController: self, message: "이미지 전송에 실패했어요", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    }
                }
            }))
            sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(sheet, animated: true)
        }
    }
}

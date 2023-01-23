//
//  ChattingListVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/06.
//

import UIKit

import RealmSwift
import RMQClient
import SnapKit
import Then

class FormatCreater {
    static let sharedLongFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    static let sharedShortFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    static let sharedTimeFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    private init() { }
}

/* 서버로부터 받은 ChatRoom 형식의 데이터를 가지고 채팅방 목록을 구성하기 위해
 recentMsg, time, unreadedMsgCnt 필드를 추가해서 만든 구조체 */
struct ChattingRoom {
    var roomId: String?
    var roomTitle: String?
    var recentMsg: String?
    var time: String?
    var unreadedMsgCnt: Int?
    var enterTime: String?
}

// TODO: - 로컬에 저장하는 DB 구조 수정 필요 -> 한 핸드폰(로컬)로 여러 개의 계정에 로그인하는 경우 대비 안함
/* 채팅방 목록을 볼 수 있는 메인 채팅탭 */
class ChattingListViewController: UIViewController {
    
    // MARK: - Properties
    
    // rabbitmq 채널 변수
    private var conn: RMQConnection? = nil
    private let rabbitMQUri = "amqp://\(Keys.idPw)@\(Keys.address)"
    
    // Realm 싱글톤 객체 가져오기
    private let localRealm = DataBaseManager.shared
    
    // 현재 선택되어 있는 필터의 label
    private var selectedLabel: UILabel? = nil {
        didSet {
            if selectedLabel?.text != "배달파티" {
                showReadyView()
            }
        }
    }
    
    // 목록에서 현재 커서 위치
    private var cursor = 0
    // 채팅방 목록의 마지막 페이지인지 여부 확인
    var isFinalPage = false
    // 채팅방 목록 데이터
    private var chattingRoomList: [ChattingRoom] = []
    
    // MARK: - SubViews
    
    /* Filter Icon */
    let filterImageView = UIImageView(image: UIImage(named: "FilterImage")).then {
        $0.tintColor = UIColor(hex: 0x2F2F2F)
    }
    
    /* Category Filter */
    /* 필터뷰들을 묶어놓는 스택뷰 */
    let filterStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .horizontal
        $0.alignment = .top
        $0.distribution = .equalSpacing
    }
    
    /* 테이블뷰 셀 하단에 블러뷰 */
    let blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)).then {
        // 그라데이션 적용
        $0.setGradient(startColor: .init(hex: 0xFFFFFF, alpha: 0.0), endColor: .init(hex: 0xFFFFFF, alpha: 1.0))
        $0.isUserInteractionEnabled = false // 블러뷰에 가려진 테이블뷰 셀이 선택 가능하도록 하기 위해
    }
    
    let chattingTableView = UITableView()
    
    // 준비 중입니다 화면
    let readyView = UIView().then {
        $0.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "ReadyImage"))
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(143)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0xFCFDFE)
        
        setAttributes()
        setFilterStackView(filterNameArray: ["배달파티", "심부름", "거래"],
                           width: [80, 67, 54],
                           stackView: filterStackView)
        addSubViews()
        setLayouts()
        setTableView()
        setLabelTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: viewWillAppear", self.chattingRoomList)
        if !(self.chattingRoomList.isEmpty) {
            removeRoomListData()
        }
        
        // 채팅방 목록 데이터 가져오기
        getChatRoomList()
        // RabbitMQ 수신 리스너 설정
        setupReceiver()
        // 로컬로부터 채팅방의 가장 최근 메세지 불러오기
        loadRecentMessage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // RabbitMQ Connection 끊기
        conn?.close()
    }
    
    // MARK: - Functions
    
    /* 배달파티 채팅방 목록 조회 */
    private func getChatRoomList() {
        // 채팅방 목록에 접근할 레퍼런스 생성
        guard let nickName = LoginModel.nickname else { return }
        print("DEBUG: 이 유저의 닉네임", nickName)
        
        // 채팅방 목록 조회 API 연동
        GetChatRoomListAPI.requestGetChatRoomList(cursor: cursor) { model, msg in
            // model이 nil이 아닐 때 -> 조회에 성공해서 결과값을 잘 받아온 것
            if let model = model {
                guard let isFinalPage = model.result?.finalPage else { return }
                self.isFinalPage = isFinalPage
                print("DEBUG: 채팅방 목록 마지막 페이지인가?", self.isFinalPage)
                
                // 받아온 채팅방 목록을 데이터로 추가
                self.addRoomListData(result: model.result?.parties)
            } else {
                self.showBottomToast(viewController: self, message: msg!, font: .customFont(.neoMedium, size: 15), color: .lightGray)
            }
        }
    }
    
    /* 서버로부터 받아온 response를 처리하는 함수. res가 성공이면 배열에 데이터를 추가해준다 */
    private func addRoomListData(result: [ChatRoom]?) {
        result?.forEach {
            // 서버로부터 받은 건 ChatRoom 형식이라서 ChattingRoom로 구조 변경
            let chattingRoom = ChattingRoom(roomId: $0.roomId,
                                              roomTitle: $0.roomTitle,
                                              recentMsg: "",
                                              time: "",
                                            unreadedMsgCnt: self.getUnreadMsgCnt(roomId: $0.roomId ?? ""),
                                            enterTime: $0.enterTime)
            // 데이터를 배열에 추가
            self.chattingRoomList.append(chattingRoom)
            
            // 로컬에 저장된 각 채팅방의 최신 메세지 불러오기
            loadRecentMessage()
            print("DEBUG: 받아온 채팅방 목록 데이터", $0)
            print("DEBUG: 채팅방 목록 데이터 현황", self.chattingRoomList)
        }
        
        // 데이터 로딩 표시 제거
        DispatchQueue.main.async {
            self.chattingTableView.tableFooterView = nil
            self.chattingTableView.reloadData()
        }
    }
    
    /* 채팅방 목록, 커서 초기화 함수 */
    private func removeRoomListData() {
        chattingRoomList.removeAll()
        cursor = 0
    }
    
    // RabbitMQ를 통해 채팅 수신
    private func setupReceiver() {
        // RabbitMQ 연결
        conn = RMQConnection(uri: rabbitMQUri, delegate: RMQConnectionDelegateLogger())
        conn!.start()
        
        // 채널 생성
        let ch = conn!.createChannel()
        // 큐 생성
        let q = ch.queue("\(LoginModel.memberId ?? 0)", options: .durable)
        
        // fanout 방식 사용해서 바인딩
        chattingRoomList.forEach { chattingRoom in
            q.bind(ch.fanout("chatting-exchange-\(String(describing: chattingRoom.roomId))"))
        }
        
        print("DEBUG: [Rabbit] 수신 대기 중", ch, q)
        
        // 큐 수신 리스너 설치 -> 메세지 수신 시 실행될 코드 작성
        q.subscribe({(_ message: RMQMessage) -> Void in
            // 디코딩
            do {
                // MsgResponse 구조체로 decode.
                let decoder = JSONDecoder()
                let data = try decoder.decode(MsgResponse.self, from: message.body)
                
                if data.chatType! == "publish" {
                    print("[Rabbit] 목록에서 채팅 수신", data)
                    // String 날짜를 Date 형태로 변경
                    let createdAtDate = FormatCreater.sharedLongFormat.date(from: data.createdAt!)
                    // 로컬에 저장하기 위한 데이터 구조를 만든다.
                    let msgToSave = MsgToSave(chatId: data.chatId!,
                                              content: data.content!,
                                              chatRoomId: data.chatRoomId!,
                                              isSystemMessage: data.isSystemMessage!,
                                              memberId: data.memberId!,
                                              nickName: data.nickName!,
                                              profileImgUrl: data.profileImgUrl!,
                                              createdAt: createdAtDate ?? Date(),
                                              unreadMemberCnt: data.unreadMemberCnt!,
                                              isImageMessage: data.isImageMessage!)
                    
                    // 수신한 채팅 로컬에 저장하기
                    self.saveMessage(msgToSave: msgToSave)
                    
                    // 수신된 채팅이 어떤 채팅방의 채팅이었는지 배열의 인덱스로 찾기
                    guard let roomIndex = self.chattingRoomList.indices.filter({ self.chattingRoomList[$0].roomId == data.chatRoomId }).first else { return }
                    // 그 채팅방의 최신 메세지, 시간 업데이트
                    self.chattingRoomList[roomIndex].recentMsg = data.content
                    self.chattingRoomList[roomIndex].time = data.createdAt
                    // 안 읽은 메세지 개수 업데이트
                    DispatchQueue.main.sync {
                        self.chattingRoomList[roomIndex].unreadedMsgCnt = self.getUnreadMsgCnt(roomId: data.chatRoomId ?? "")
                    }
                    
                    // 채팅방 목록 맨 위로 셀 올리기
                    self.moveToTopOfList(roomIndex: roomIndex)
                } else {
                    print("[Rabbit] 목록에서 채팅 읽음 수신???", data)
                }
            } catch {
                print(error)
            }
        })
    }
    
    // 안 읽은 메세지 개수 가져오기 -> isRead가 false인 msg의 개수를 구한다.
    private func getUnreadMsgCnt(roomId: String) -> Int {
        let unreadMsg = NSPredicate(format: "chatRoomId = %@ AND isSystemMessage = false AND memberId != %@ AND isRead = false", roomId, NSNumber(value: LoginModel.memberId!))
        return localRealm.read(MsgToSave.self).filter(unreadMsg).count
    }
    
    // 채팅 로컬에 저장하기
    private func saveMessage(msgToSave: MsgToSave) {
        DispatchQueue.main.async {
            self.localRealm.write(msgToSave)
        }
    }
    
    // 로컬에서 각 채팅방의 가장 최근 메세지 불러오기
    private func loadRecentMessage() {
        print("DEBUG: loadRecentMessage", self.chattingRoomList)
        
        // chattingRoomList 배열 내용 재구성 -> 여기서 recentMsg, time 필드가 채워진다.
        self.chattingRoomList = self.chattingRoomList.map { chattingRoom in
            let enterTimeToDate = FormatCreater.sharedLongFormat.date(from: chattingRoom.enterTime ?? "2023-01-01 00:00:00")! // 채팅방 입장 시간
            // 로컬에서 해당 채팅방의, 입장시간 이후의 채팅 데이터 가져오기
            let predicate = NSPredicate(format: "chatRoomId = %@ AND createdAt >= %@", chattingRoom.roomId!, enterTimeToDate as! NSDate)
            // 마지막 메세지가 있는 경우
            if let last = localRealm.read(MsgToSave.self).filter(predicate).sorted(byKeyPath: "createdAt").last {
                print("DEBUG: \(last.chatRoomId)방의 마지막 채팅은", last)
                // 로컬에서 가장 최근 메세지 얻어서 ChattingRoom 구조로 만들어서 리턴
                return ChattingRoom(
                    roomId: chattingRoom.roomId,
                    roomTitle: chattingRoom.roomTitle,
                    recentMsg: last.content,
                    time: FormatCreater.sharedLongFormat.string(from: last.createdAt!),
                    unreadedMsgCnt: self.getUnreadMsgCnt(roomId: chattingRoom.roomId ?? ""),
                    enterTime: chattingRoom.enterTime)
            } else { // 없는 경우
                print("DEBUG: \(chattingRoom.roomId)방의 마지막 채팅은 아직 없다!")
                // 로컬에서 가장 최근 메세지 얻어서 ChattingRoom 구조로 만들어서 리턴
                return ChattingRoom(
                    roomId: chattingRoom.roomId,
                    roomTitle: chattingRoom.roomTitle,
                    recentMsg: nil,
                    time: nil,
                    unreadedMsgCnt: self.getUnreadMsgCnt(roomId: chattingRoom.roomId ?? ""),
                    enterTime: chattingRoom.enterTime)
            }
        }
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "채팅"
        
        chattingTableView.backgroundColor = .white
        chattingTableView.rowHeight = 81 + 6 + 6
        chattingTableView.separatorStyle = .none
        chattingTableView.showsVerticalScrollIndicator = false
    }
    
    private func addSubViews() {
        [
            filterImageView, filterStackView,
            chattingTableView,
            blurView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* Category Filter */
        filterImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(33)
            make.width.equalTo(23)
            make.height.equalTo(15)
        }
        filterStackView.snp.makeConstraints { make in
            make.left.equalTo(filterImageView.snp.right).offset(17)
            make.centerY.equalTo(filterImageView)
            make.width.equalTo(134 + 85)
        }
        
        /* Blur View */
        blurView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(140)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        chattingTableView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(18)
            make.left.equalToSuperview().inset(18)
            make.right.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /* 테이블뷰 세팅 */
    private func setTableView() {
        chattingTableView.dataSource = self
        chattingTableView.delegate = self
        chattingTableView.register(ChattingListTableViewCell.self, forCellReuseIdentifier: ChattingListTableViewCell.identifier)
    }
    
    /* 배열에 담긴 이름으로 Filter Views를 만들고 스택뷰로 묶는다 */
    private func setFilterStackView(filterNameArray: [String], width: [CGFloat], stackView: UIStackView) {
        for i in 0..<filterNameArray.count {
            let filterText = filterNameArray[i]
            let filterView = UIView().then {
                $0.backgroundColor = .init(hex: 0xF8F8F8)
                $0.layer.cornerRadius = 5
                $0.snp.makeConstraints { make in
                    make.width.equalTo(width[i])
                    make.height.equalTo(35)
                }
                
                let label = UILabel().then {
                    $0.text = filterText
                    $0.font = .customFont(.neoMedium, size: 14)
                }
                if filterText == "배달파티" {
                    // default로 배달파티 필터가 활성화 되어 있도록 설정
                    label.textColor = .mainColor
                    selectedLabel = label
                } else {
                    label.textColor = UIColor(hex: 0xD8D8D8)
                }
                $0.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
            }
            
            /* Stack View */
            stackView.addArrangedSubview(filterView)
        }
    }
    
    /* label에 탭 제스쳐를 추가 */
    private func setLabelTap() {
        // filterStackView의 서브뷰 안의 label에게 탭 제스쳐를 추가한다.
        filterStackView.subviews.forEach { view in
            view.subviews.forEach { sub in
                let label = sub as! UILabel
                print(label.text!)
                // 탭 제스쳐를 label에 추가 -> label을 탭했을 때 액션이 발생하도록.
                let labelTapGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(tapFilterLabel(sender:)))
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(labelTapGesture)
            }
        }
    }
    
    // 채팅방의 가장 최근 메세지, 전송 시간 데이터 가져와서 포맷팅 후 UI 연결
    private func setRecentMessageAndTime(cell: ChattingListTableViewCell,
                                         messageContents: String,
                                         messageTime: String,
                                         row: Int) {
        // 아직 주고받은 메세지가 없으면 안내 문구 띄우기
        if messageContents.isEmpty {
            cell.recentMessageLabel.text = "채팅을 시작해보세요!"
            cell.receivedTimeString = ""
        } else {
            // 채팅방의 최근 메세지 설정
            cell.recentMessageLabel.text = messageContents
            
            // 현재 시간과 마지막 메세지 전송시간 비교
            let nowTimeDate = Date()
            if let messageTimeDate = FormatCreater.sharedLongFormat.date(from: messageTime) {
                // 현재가 몇 년도 몇 월 며칠인지.
                let calendar = Calendar.current
                let todayComponents = calendar.dateComponents([.year, .month, .day],
                                                         from: nowTimeDate)
                let todayYear = todayComponents.year
                let todayMonth = todayComponents.month
                let todayDay = todayComponents.day

                // 마지막 메세지 전송시간이 몇 년도 몇 월 며칠인지.
                let messageTimeComponents = calendar.dateComponents([.year, .month, .day],
                                                         from: messageTimeDate)
                let messageSendedYear = messageTimeComponents.year
                let messageSendedMonth = messageTimeComponents.month
                let messageSendedDay = messageTimeComponents.day

                // (메세지 전송 시간 - 현재 시간) 의 값을 초 단위로 받아온다
                let intervalSecs = Int(nowTimeDate.timeIntervalSince(messageTimeDate))

                // 각각 일, 시간, 분 단위로 변환
                let hourTime = intervalSecs / 60 / 60 % 24
                let minuteTime = intervalSecs / 60 % 60

                /* 포맷팅 기준에 따라 최근 메세지의 전송 시간 설정 */
                // 같은 해
                if todayYear == messageSendedYear {
                    // 몇달 전
                    if todayMonth! > messageSendedMonth! {
                        let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
                        cell.receivedTimeString = date
                    } else {
                        // 같은 달
                        if todayDay! - 1 == messageSendedDay! {
                            // 하루 전
                            cell.receivedTimeString = "어제"
                        } else if (todayDay! - messageSendedDay!) <= 3, (todayDay! - messageSendedDay!) > 0 {
                            // 3일 이내
                            cell.receivedTimeString = "\(todayDay! - messageSendedDay!)일 전"
                        } else if (todayDay! - messageSendedDay!) > 3 {
                            // 3일 초과
                            // ex) 22.08.31
                            let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
                            cell.receivedTimeString = date
                        } else {
                            // 같은 날
                            if hourTime == 0 {
                                if minuteTime <= 9 {
                                    // 최근 메세지의 전송 시간 설정
                                    cell.receivedTimeString = "방금"
                                } else if minuteTime > 9, minuteTime <= 59 {
                                    // 최근 메세지의 전송 시간 설정
                                    cell.receivedTimeString = "\(minuteTime)분 전"
                                }
                            } else if hourTime >= 1, hourTime <= 12 {
                                cell.receivedTimeString = "\(hourTime)시간 전"
                            } else if messageSendedDay == todayDay {
                                cell.receivedTimeString = "오늘"
                            }
                        }
                    }
                } else {
                    // 몇년 전
                    // ex) 22.08.31
                    let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
                    cell.receivedTimeString = date
                }
            } else {
                cell.receivedTimeString = ""
            }
        }
    }
    
    // 해당 인덱스의 채팅방을 채팅방 목록의 맨 위로 옮긴다
    private func moveToTopOfList(roomIndex: Int) {
        let itemToMove = self.chattingRoomList[roomIndex]
        self.chattingRoomList.remove(at: roomIndex)
        self.chattingRoomList.insert(itemToMove, at: 0) // 배열의 첫번째로 넣기
        let nowIndexPath = IndexPath(row: roomIndex, section: 0)
        let destinationIndexPath = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async {
            // 해당 채팅방을 채팅방 목록 맨 위로 이동
            self.chattingTableView.moveRow(at: nowIndexPath, to: destinationIndexPath)
            self.chattingTableView.reloadRows(at: [destinationIndexPath], with: .automatic)
        }
    }
    
    /* 테이블뷰 셀의 마지막 데이터까지 스크롤 했을 때 이를 감지해주는 함수 */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 하는 게 채팅방 목록일 때, 데이터가 존재할 때에만 실행
        if scrollView == chattingTableView, chattingRoomList.count != 0 {
            let position = scrollView.contentOffset.y
            print("pos", position)
            
            // 현재 화면에 테이블뷰 셀이 몇개까지 들어가는지
            let maxCellNum = chattingTableView.bounds.size.height / chattingTableView.rowHeight
            // '몇 번째 셀'이 위로 사라질 때 다음 데이터를 불러올지
            let boundCellNum = 10 - maxCellNum
            print("Seori", maxCellNum, boundCellNum)
            
            // 마지막 데이터에 도달했을 때 다음 데이터 10개를 불러온다
            if position > ((chattingTableView.rowHeight) * (boundCellNum + (10 * CGFloat(cursor)))) {
                // 마지막 페이지가 아니라면, 다음 커서의 배달 목록을 불러온다
                if !isFinalPage {
                    cursor += 1
                    print("DEBUG: 채팅방 목록 cursor", cursor)
                    // 데이터 로딩 표시 띄우기
                    self.chattingTableView.tableFooterView = createSpinnerFooter()
                    // 다음 커서의 채팅방 목록 조회 API 호출
                    getChatRoomList()
                }
            }
        }
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
    
    /* 준비 중입니다 화면 띄우기 */
    private func showReadyView() {
        view.addSubview(readyView)
        readyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(filterStackView.snp.bottom).offset(8)
        }
    }
    
    private func removeReadyView() {
        readyView.removeFromSuperview()
    }
    
    // MARK: - @objc Functions
    
    /* 필터를 탭하면 텍스트 색깔이 바뀌도록 */
    @objc
    private func tapFilterLabel(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        
        // label 색 변경
        // 선택돼있던 label이 아니었다면, mainColor로 바꿔준다
        if label.textColor != .mainColor {
            // 원래 선택돼있던 label 색깔은 해제한다. -> 필터 1개만 선택 가능
            if selectedLabel != nil {
                // 색깔 원상복귀
                selectedLabel?.textColor = .init(hex: 0xD8D8D8)
                // 이전에 선택돼있던 게 심부름/거래 였으면 준비 중입니다 뷰 삭제
                if selectedLabel?.text != "배달파티" {
                    removeReadyView()
                }
            }
            label.textColor = .mainColor
            selectedLabel = label
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ChattingListViewController: UITableViewDataSource, UITableViewDelegate {
    /* 채팅방 목록 갯수 설정 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell 갯수 판단", chattingRoomList.count)
        return chattingRoomList.count
    }

    /* 채팅방 목록 셀 내용 구성 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListTableViewCell.identifier, for: indexPath) as? ChattingListTableViewCell else { return UITableViewCell() }
        let chattingRoom = chattingRoomList[indexPath.row]
        
        // 채팅방 타이틀 설정
        cell.titleLabel.text = chattingRoom.roomTitle ?? "배달파티 채팅방"
        // 가장 최신 메세지와 그 메세지의 전송시간 받아오기
        self.setRecentMessageAndTime(cell: cell,
                                     messageContents: chattingRoom.recentMsg ?? "",
                                     messageTime: chattingRoom.time ?? "",
                                     row: indexPath.row)
        // 안 읽은 메세지 개수 띄우기
        if (chattingRoom.unreadedMsgCnt ?? 0 > 0) {
            cell.unreadMessageCountLabel.text = "+\(chattingRoom.unreadedMsgCnt!)"
        }
        
        return cell
    }

    /* 채팅방 셀이 클릭될 때 실행되는 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chattingVC = ChattingViewController()
        // 해당 채팅방 uuid값 받아서 이동
        chattingVC.roomId = chattingRoomList[indexPath.row].roomId
        chattingVC.roomName = chattingRoomList[indexPath.row].roomTitle
        // TODO: - 여기서도 MaxMatching 값 넘겨줘야 되지 않나
        
        // RabbitMQ Connection 끊기
        conn?.close()
        navigationController?.pushViewController(chattingVC, animated: true)
    }
}

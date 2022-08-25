//
//  ChattingListVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/06.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FormatCreater {
    static let sharedLongFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    static let sharedShortFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    static let sharedDayFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private init() { }
}

/* 채팅방 목록을 볼 수 있는 메인 채팅탭 */
class ChattingListViewController: UIViewController {
    
    // MARK: - Properties
    
    // 현재 선택되어 있는 필터의 label
    var selectedLabel: UILabel? = nil {
        didSet {
            if selectedLabel?.text != "배달파티" {
                showReadyView()
            }
        }
    }
    
    // 채팅 더미 데이터
    var chattingRoomList: [RoomInfoDetailModel] = [] {
        didSet {
            chattingTableView.reloadData()
        }
    }
    var roomUUIDList: [String] = []
    
    // 채팅 보관함 버튼 눌렀는지/안 눌렀는지 확인을 위해
    var isStorageOn: Bool = false
    
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    var listListener: ListenerRegistration?
    var recentMsgListener: ListenerRegistration?
    
    // MARK: - SubViews
    
    /* Filter Icon */
    let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "FilterImage"))
        imageView.tintColor = UIColor(hex: 0x2F2F2F)
        return imageView
    }()
    
    /* Category Filter */
    /* 필터뷰들을 묶어놓는 스택뷰 */
    let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    /* 테이블뷰 셀 하단에 블러뷰 */
    let blurView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
        // 그라데이션 적용
        view.setGradient(startColor: .init(hex: 0xFFFFFF, alpha: 0.0), endColor: .init(hex: 0xFFFFFF, alpha: 1.0))
        view.isUserInteractionEnabled = false // 블러뷰에 가려진 테이블뷰 셀이 선택 가능하도록 하기 위해
        return view
    }()
    
    let chattingTableView = UITableView()
    
    // 준비 중입니다 화면
    let readyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "ReadyImage"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(143)
        }
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0xFCFDFE)
        
        setFirestore()
        
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
        
        // 채팅방 목록 데이터 가져오기 (listener 설치)
        loadChattingRoomList()
    }
    
    /* 이 화면 나갈 때 리스너 해제 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let listListener = listListener,
              let recentMsgListener = recentMsgListener else { return }

        listListener.remove()
        recentMsgListener.remove()
    }
    
    // MARK: - Functions
    
    /* firestore 설정 */
    private func setFirestore() {
        settings.isPersistenceEnabled = false
        db.settings = settings
        db.clearPersistence()
    }
    
    /* 파티 채팅방 목록 조회 */
    private func loadChattingRoomList() {
        // 채팅방 목록에 접근할 레퍼런스 생성
        let roomsRef = db.collection("Rooms")
        
        guard let nickName = LoginModel.nickname else { return }
        print("DEBUG: 이 유저의 닉네임", nickName)
        
        // 배달파티 카테고리에 속하고, 종료되지 않은 채팅방 데이터만 가져올 쿼리 생성
        let query = roomsRef
            .whereField("roomInfo.category", isEqualTo: "배달파티")
            .whereField("roomInfo.isFinish", isEqualTo: false)
            .order(by: "roomInfo.updatedAt", descending: true)    // 채팅방 목록을 메세지 최신순으로 정렬
        
        // 해당 쿼리문의 결과값을 firestore에서 가져오기
        listListener = query.addSnapshotListener() {   // updatedAt으로 order되는 순서가 바뀌는 걸 감지하도록 listener로 변경
            (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("DEBUG: firestore를 통해 채팅방 목록 가져오기 성공")
                    self.chattingRoomList.removeAll()
                    self.roomUUIDList.removeAll()   // 배열 초기화 과정
                    
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        if let data = try? document.data(as: RoomInfoModel.self) {
                            let chattingRoom = data.roomInfo
                            guard let chattingRoom = chattingRoom else { return }
                            
                            // 그 중에 '이 유저가 속하는' 채팅방 정보만 가져온다!
                            for participants in data.roomInfo!.participants! {
                                if participants.participant == nickName {
                                    self.roomUUIDList.append(document.documentID)   // 이 채팅방의 uuid값을 배열에 추가
                                    self.chattingRoomList.append(chattingRoom)  // 이 채팅방을 채팅방 목록에 추가
                                    print("DEBUG:", self.chattingRoomList)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "채팅"
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "StorageBox"), style: .plain, target: self, action: #selector(tapStorageBox)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        chattingTableView.backgroundColor = .white
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
        
        chattingTableView.rowHeight = 81 + 6 + 6
        chattingTableView.separatorStyle = .none
    }
    
    /* 배열에 담긴 이름으로 Filter Views를 만들고 스택뷰로 묶는다 */
    private func setFilterStackView(filterNameArray: [String], width: [CGFloat], stackView: UIStackView) {
        for i in 0..<filterNameArray.count {
            let filterText = filterNameArray[i]
            let filterView: UIView = {
                let view = UIView()
                view.backgroundColor = .init(hex: 0xF8F8F8)
                view.layer.cornerRadius = 5
                view.snp.makeConstraints { make in
                    make.width.equalTo(width[i])
                    make.height.equalTo(35)
                }
                
                let label = UILabel()
                label.text = filterText
                label.font = .customFont(.neoMedium, size: 14)
                if filterText == "배달파티" {
                    // default로 배달파티 필터가 활성화 되어 있도록 설정
                    label.textColor = .mainColor
                    selectedLabel = label
                } else {
                    label.textColor = UIColor(hex: 0xD8D8D8)
                }
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
                
                return view
            }()
            
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
    
    @objc
    private func tapStorageBox() {
        isStorageOn = !isStorageOn
        print("DEBUG: 채팅 보관함 아이콘 클릭")
        if isStorageOn {
            view.addSubview(readyView)
            readyView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        } else {
            if selectedLabel?.text == "배달파티" {
                removeReadyView()
            } else {
                removeReadyView()
                showReadyView()
            }
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
        let index = indexPath.row
        // 채팅방 타이틀 설정
        cell.titleLabel.text = chattingRoomList[index].title ?? "디폴트 이름"
        
        /* firestore에서 채팅방의 가장 최근 메세지, 전송 시간 데이터 가져오기 */
        let roomDocRef = db.collection("Rooms").document(roomUUIDList[indexPath.row])
//        print("1111위치" + roomUUIDList[indexPath.row])
        // 해당 채팅방의 messages를 time을 기준으로 내림차순 정렬 후 처음의 1개(= 가장 최근 메세지)만 가져온다.
        recentMsgListener = roomDocRef.collection("Messages").order(by: "time", descending: true).limit(to: 1) .addSnapshotListener { querySnapshot, error in
//            print("2222위치" + self.roomUUIDList[indexPath.row])
                if let error = error {
                    print("Error retreiving collection: \(error)")
                }
                if let querySnapshot = querySnapshot,
                   let lastDocument = querySnapshot.documents.last {
                    if let messageContents = lastDocument["content"] as? String,
                       let messageTime = lastDocument["time"] as? String {
                        // 채팅방의 최근 메세지 설정
                        cell.recentMessageLabel.text = messageContents
                        
                        let nowTimeDate = Date()
                        let messageTimeDate = FormatCreater.sharedLongFormat.date(from: messageTime)!
                        
                        // 메세지가 전송된 날(일)을 저장, 오늘인지 구분하기 위해
                        let messageSendedDay = FormatCreater.sharedDayFormat.string(from: messageTimeDate)
                        let today = FormatCreater.sharedDayFormat.string(from: nowTimeDate)
                        
                        // (메세지 전송 시간 - 현재 시간) 의 값을 초 단위로 받아온다
                        let intervalSecs = Int(nowTimeDate.timeIntervalSince(messageTimeDate))
                        
                        // 각각 일, 시간, 분 단위로 변환
                        let hourTime = intervalSecs / 60 / 60 % 24
                        let minuteTime = intervalSecs / 60 % 60
                        
                        print("위치\(self.roomUUIDList[indexPath.row]) \(messageContents) \(messageSendedDay)일 \(hourTime)시간 \(minuteTime)분, 오늘은 \(today)일")
                        
                        /* 포맷팅 기준에 따라 최근 메세지의 전송 시간 설정 */
                        // 일이 다르면 다른 날로. 어제, 오늘.
                        if Int(today)! - 1 == Int(messageSendedDay) {
                            cell.receivedTimeString = "어제"
                        } else if (Int(today)! - Int(messageSendedDay)!) <= 3, (Int(today)! - Int(messageSendedDay)!) > 0 {
                            cell.receivedTimeString = "\(Int(today)! - Int(messageSendedDay)!)일 전"
                        } else if (Int(today)! - Int(messageSendedDay)!) > 3 {
                            // ex) 22.08.31
                            let testDate = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
                            cell.receivedTimeString = testDate
                        } else {
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
                            } else if messageSendedDay == today {
                                cell.receivedTimeString = "오늘"
                            }
                        }
                    }
                }
            }
        return cell
    }

    /* 채팅방 셀이 클릭될 때 실행되는 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀 데이터
//        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChattingListTableViewCell else { return }
        
        let chattingVC = ChattingViewController()
        // 해당 채팅방 uuid값 받아서 이동
        chattingVC.roomUUID = roomUUIDList[indexPath.row]
        navigationController?.pushViewController(chattingVC, animated: true)
    }
}

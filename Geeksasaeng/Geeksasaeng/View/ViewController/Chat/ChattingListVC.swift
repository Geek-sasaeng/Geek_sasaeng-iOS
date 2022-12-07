//
//  ChattingListVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/06.
//

import UIKit

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
    
    private init() { }
}

/* 채팅방 목록을 볼 수 있는 메인 채팅탭 */
class ChattingListViewController: UIViewController {
    
    // MARK: - Properties
    
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
    private var chattingRoomList: [ChatRoomInfo]? = []
    
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
        
        // 채팅방 목록 데이터 가져오기
        getChatRoomList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    private func addRoomListData(result: [ChatRoomInfo]?) {
        result?.forEach {
            // 데이터를 배열에 추가
            self.chattingRoomList!.append($0)
            print("DEBUG: 받아온 채팅방 목록 데이터", $0)
            print("DEBUG: 채팅방 목록 데이터 현황", chattingRoomList)
        }
        
        // 데이터 로딩 표시 제거
        DispatchQueue.main.async {
            self.chattingTableView.tableFooterView = nil
        }
        
        // 테이블뷰 리로드
        DispatchQueue.main.async {
            self.chattingTableView.reloadData()
        }
    }
    
    /* 채팅방 목록, 커서 초기화 함수 */
    private func removeRoomListData() {
        chattingRoomList?.removeAll()
        cursor = 0
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
    
    // TODO: - 연결된 큐를 통해 채팅방의 가장 최근 메세지, 전송 시간 데이터 가져와서 포맷팅
    private func getRecentMessageAndTime(cell: ChattingListTableViewCell, row: Int) {
//        let roomDocRef = db.collection("Rooms").document(roomUUIDList[row])
//        // 해당 채팅방의 messages를 time을 기준으로 내림차순 정렬 후 처음의 1개(= 가장 최근 메세지)만 가져온다.
//        recentMsgListener = roomDocRef.collection("Messages").order(by: "time", descending: true).limit(to: 1) .addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error retreiving collection: \(error)")
//            }
//            if let querySnapshot = querySnapshot,
//               let lastDocument = querySnapshot.documents.last {
//                if let messageContents = lastDocument["content"] as? String,
//                   let messageTime = lastDocument["time"] as? String {
//                    // 채팅방의 최근 메세지 설정
//                    cell.recentMessageLabel.text = messageContents
//
//                    // 현재 시간과 마지막 메세지 전송시간
//                    let nowTimeDate = Date()
//                    let messageTimeDate = FormatCreater.sharedLongFormat.date(from: messageTime)!
//
//                    // 현재가 몇 년도 몇 월 며칠인지.
//                    let calendar = Calendar.current
//                    let todayComponents = calendar.dateComponents([.year, .month, .day],
//                                                             from: nowTimeDate)
//                    let todayYear = todayComponents.year
//                    let todayMonth = todayComponents.month
//                    let todayDay = todayComponents.day
//
//                    // 마지막 메세지 전송시간이 몇 년도 몇 월 며칠인지.
//                    let messageTimeComponents = calendar.dateComponents([.year, .month, .day],
//                                                             from: messageTimeDate)
//                    let messageSendedYear = messageTimeComponents.year
//                    let messageSendedMonth = messageTimeComponents.month
//                    let messageSendedDay = messageTimeComponents.day
//
//                    // (메세지 전송 시간 - 현재 시간) 의 값을 초 단위로 받아온다
//                    let intervalSecs = Int(nowTimeDate.timeIntervalSince(messageTimeDate))
//
//                    // 각각 일, 시간, 분 단위로 변환
//                    let hourTime = intervalSecs / 60 / 60 % 24
//                    let minuteTime = intervalSecs / 60 % 60
//
//                    /* 포맷팅 기준에 따라 최근 메세지의 전송 시간 설정 */
//                    // 같은 해
//                    if todayYear == messageSendedYear {
//                        // 몇달 전
//                        if todayMonth! > messageSendedMonth! {
//                            let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
//                            cell.receivedTimeString = date
//                        } else {
//                            // 같은 달
//                            if todayDay! - 1 == messageSendedDay! {
//                                // 하루 전
//                                cell.receivedTimeString = "어제"
//                            } else if (todayDay! - messageSendedDay!) <= 3, (todayDay! - messageSendedDay!) > 0 {
//                                // 3일 이내
//                                cell.receivedTimeString = "\(todayDay! - messageSendedDay!)일 전"
//                            } else if (todayDay! - messageSendedDay!) > 3 {
//                                // 3일 초과
//                                // ex) 22.08.31
//                                let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
//                                cell.receivedTimeString = date
//                            } else {
//                                // 같은 날
//                                if hourTime == 0 {
//                                    if minuteTime <= 9 {
//                                        // 최근 메세지의 전송 시간 설정
//                                        cell.receivedTimeString = "방금"
//                                    } else if minuteTime > 9, minuteTime <= 59 {
//                                        // 최근 메세지의 전송 시간 설정
//                                        cell.receivedTimeString = "\(minuteTime)분 전"
//                                    }
//                                } else if hourTime >= 1, hourTime <= 12 {
//                                    cell.receivedTimeString = "\(hourTime)시간 전"
//                                } else if messageSendedDay == todayDay {
//                                    cell.receivedTimeString = "오늘"
//                                }
//                            }
//                        }
//                    } else {
//                        // 몇년 전
//                        // ex) 22.08.31
//                        let date = FormatCreater.sharedShortFormat.string(from: messageTimeDate)
//                        cell.receivedTimeString = date
//                    }
//                }
//            }
//        }
    }
    
    /* 테이블뷰 셀의 마지막 데이터까지 스크롤 했을 때 이를 감지해주는 함수 */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 하는 게 채팅방 목록일 때, 데이터가 존재할 때에만 실행
        if scrollView == chattingTableView, chattingRoomList?.count != 0 {
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
                    print("DEBUG: cursor", cursor)
                    // 다음 커서의 채팅방 목록 조회 API 호출
                    getChatRoomList()
                    // 데이터 로딩 표시 띄우기
                    self.chattingTableView.tableFooterView = createSpinnerFooter()
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
        
        /* 새로고침 기능 */
        // refresh 기능을 위해 tableView의 UIRefreshControl 객체를 초기화
        chattingTableView.refreshControl = UIRefreshControl()
        // refresh로 위에 생기는 부분 배경색 설정
        chattingTableView.refreshControl?.backgroundColor = .white
        chattingTableView.refreshControl?.tintColor = .mainColor
//        chattingTableView.refreshControl?.subviews.first?.alpha = 0
        // refresh 하면 실행될 함수 연결
        chattingTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
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
    
    /* 채팅 보관함 아이콘 클릭시 실행되는 함수 */
    @objc
    private func tapStorageBox() {
        print("DEBUG: 채팅 보관함 아이콘 클릭")
        let chattingStorageVC = ChattingStorageViewController()
        self.navigationController?.pushViewController(chattingStorageVC, animated: true)
    }
    
    /* 새로고침 기능 */
    @objc
    private func pullToRefresh() {
        // 데이터가 적재된 상황에서 맨 위로 올려 새로고침을 했다면, 배열을 초기화시켜서 처음 10개만 다시 불러온다
        print("DEBUG: 적재된 데이터 \(chattingRoomList?.count)개 삭제")
        removeRoomListData()
        
        // 채팅방 목록 조회 API 호출
        print("Seori 채팅방 다시 불러옴")
        getChatRoomList()
        
        // 채팅방 목록 테이블뷰 새로고침
        chattingTableView.reloadData()
        // 당기는 게 끝나면 refresh도 끝나도록
        chattingTableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ChattingListViewController: UITableViewDataSource, UITableViewDelegate {
    /* 채팅방 목록 갯수 설정 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell 갯수 판단", chattingRoomList?.count)
        return chattingRoomList?.count ?? 0
    }

    /* 채팅방 목록 셀 내용 구성 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListTableViewCell.identifier, for: indexPath) as? ChattingListTableViewCell else { return UITableViewCell() }
        let index = indexPath.row
        
        // 채팅방 타이틀 설정
        cell.titleLabel.text = chattingRoomList?[index].roomTitle ?? "배달파티 채팅방"
        // 가장 최신 메세지와 그 메세지의 전송시간 받아오기
//        self.getRecentMessageAndTime(cell: cell, row: indexPath.row)
        
        return cell
    }

    /* 채팅방 셀이 클릭될 때 실행되는 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chattingVC = ChattingViewController()
        // 해당 채팅방 uuid값 받아서 이동
        chattingVC.roomUUID = chattingRoomList?[indexPath.row].roomId
        chattingVC.roomName = chattingRoomList?[indexPath.row].roomTitle
        navigationController?.pushViewController(chattingVC, animated: true)
    }
}

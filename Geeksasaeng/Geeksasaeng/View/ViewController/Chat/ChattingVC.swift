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
        return textView
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = .customFont(.neoMedium, size: 16)
        button.setTitleColor(.mainColor, for: .normal)
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
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            return button
        }()
        var sendDeliveryConfirmButton: UIButton = {
            let button = UIButton()
            button.setTitle("배달 완료 알림 보내기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            return button
        }()
        var CloseMatchingButton: UIButton = {
            let button = UIButton()
            button.setTitle("매칭 마감하기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            return button
        }()
        var forcedExitButton: UIButton = {
            let button = UIButton()
            button.setTitle("강제 퇴장시키기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            return button
        }()
        var endOfChatButton: UIButton = {
            let button = UIButton()
            button.setTitle("나가기", for: .normal)
            button.addTarget(self, action: #selector(tapEndOfChatButton), for: .touchUpInside)
            return button
        }()
        
        [showMenuButton, sendDeliveryConfirmButton, CloseMatchingButton, forcedExitButton, endOfChatButton].forEach {
            // attributes
            $0.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            $0.titleLabel?.font =  .customFont(.neoMedium, size: 18)
            
            // layouts
            view.addSubview($0)
        }
        showMenuButton.snp.makeConstraints { make in
            make.top.equalTo(settingButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        sendDeliveryConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(showMenuButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        CloseMatchingButton.snp.makeConstraints { make in
            make.top.equalTo(sendDeliveryConfirmButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        forcedExitButton.snp.makeConstraints { make in
            make.top.equalTo(CloseMatchingButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        endOfChatButton.snp.makeConstraints { make in
            make.top.equalTo(forcedExitButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
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
    
    var firstRoomInfo = true
    var firstMessage = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setFirestore()
        loadParticipants()
        loadMessages()
        setCollectionView()
        addSubViews()
        setLayouts()
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
        collectionView.register(ParticipantCell.self, forCellWithReuseIdentifier: "ParticipantCell")
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
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
    

//    private func addParticipant() {
//        // 불러온 걸 배열에 저장했다가 본인 닉네임 append -> update
//        guard let roomUUID = roomUUID else { return }
//
//        db.collection("Rooms").document(roomUUID).getDocument { documentSnapshot, error in
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                print("참가자 추가")
//                if let document = documentSnapshot {
//                    if let data = try? document.data(as: RoomInfoModel.self) {
//                        var participants = data.roomInfo?.participants
//                        participants?.append(LoginModel.nickname ?? "")
//
//                        self.db.collection("Rooms").document("TestRoom1").updateData(["roomInfo" : ["participants": participants]])
//                    }
//                }
//            }
//        }
//    }

    
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
                        self.contents.append(cellContents(cellType: .participant, message: nil, roomInfo: data))
                        self.currentMatching = participants.count // 참여자가 늘어나면 currentMatching에 추가
                        if self.currentMatching == roomInfo.maxMatching {
                            self.contents.append(cellContents(cellType: .maxMatching, message: nil, roomInfo: data))
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
                           let time = data["time"] as? String {
                            self.contents.append(cellContents(cellType: .message,
                                                              message: MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl, time: time),
                                                              roomInfo: nil))

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
        showOptionMenu(optionViewForOwner, UIScreen.main.bounds.height / 2)
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
                }
            )
        }
    }
    
    @objc
    private func keyboardDown() {
        // reportBarView 위치 제자리로
        self.bottomView.transform = .identity
    }
    
    @objc func tapCollectionView() {
        view.endEditing(true)
        
        if visualEffectView != nil { // nil이 아니라면, 즉 옵션뷰가 노출되어 있다면
            showChattRoom(optionViewForOwner)
            view.subviews.forEach {
                if $0 == exitView {
                    $0.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func tapSendButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let message = contentsTextView.text {
            guard let roomUUID = roomUUID else { return }
            db.collection("Rooms").document(roomUUID).collection("Messages").document(UUID().uuidString).setData([
                "content": message,
                "nickname": LoginModel.nickname ?? "홍길동",
                "userImgUrl": LoginModel.userImgUrl ?? "https://",
                "time": formatter.string(from: Date())
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
        }
    }
    
    @objc
    private func tapOptionButtonInView(_ sender: UIButton) {
        // 클릭한 버튼의 superView가 그냥 optionView인지 optionViewForAuthor인지 파라미터로 보내주는 것
        guard let nowView = sender.superview else { return }
        showChattRoom(nowView)
    }
    
    private func showChattRoom(_ nowView: UIView) {
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
        db.collection("Rooms").document(roomUUID).updateData(["roomInfo.participants" : FieldValue.arrayRemove([LoginModel.nickname ?? ""])])
        
        navigationController?.popViewController(animated: true)
    }
    
    private func getMessageLabelHeight(text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = .customFont(.neoMedium, size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 200
        label.sizeToFit()
        label.setNeedsDisplay()
        
        return label.frame.height
    }
    
    private func getSystemLabelHeight(text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = .customFont(.neoMedium, size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.preferredMaxLayoutWidth = 200
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
        case .participant:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
            cell.participantLabel.text =  "\(contents[indexPath.row].roomInfo?.roomInfo?.participants?.last ?? "") 님이 입장하셨습니다"
            return cell
        case .maxMatching:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
            cell.participantLabel.text = "모든 파티원이 입장을 마쳤습니다!\n안내에 따라 메뉴를 입력해주세요"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.nicknameLabel.text = contents[indexPath.row].message?.nickname
            if contents[indexPath.row].message?.nickname == LoginModel.nickname { // 같은 사람이 연속으로 보낼 때
                cell.rightMessageLabel.text = contents[indexPath.row].message?.content
                cell.nicknameLabel.textAlignment = .right
                cell.rightMessageLabel.sizeToFit()
                cell.rightTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
                cell.rightUnReadCountLabel.text = "3" // 안 읽은 사람 수 넣기
                cell.leftTimeLabel.isHidden = true
                cell.leftUnReadCountLabel.isHidden = true
                cell.leftMessageLabel.isHidden = true
                cell.leftImageView.isHidden = true
                if indexPath.row > 0 {
                    if contents[indexPath.row].message?.nickname == contents[indexPath.row - 1].message?.nickname {
                        // nicknameLabel 지워야 함
//                        for subView in cell.subviews {
//                            if subView.tag == 22 {
//                                subView.removeFromSuperview()
//                            }
//                        }
                        cell.rightImageView.isHidden = true
                    } else {
                        cell.rightImageView.isHidden = false
                    }
                } else {
                    cell.rightImageView.isHidden = false
                }
                cell.rightTimeLabel.isHidden = false
                cell.rightUnReadCountLabel.isHidden = false
            } else {
                cell.leftMessageLabel.text = contents[indexPath.row].message?.content
                cell.nicknameLabel.textAlignment = .left
                cell.leftMessageLabel.sizeThatFits(view.frame.size)
                cell.leftTimeLabel.text = "오후 9:00"
                cell.leftUnReadCountLabel.text = "3"
                cell.rightTimeLabel.isHidden = true
                cell.rightUnReadCountLabel.isHidden = true
                cell.rightMessageLabel.isHidden = true
                cell.rightImageView.isHidden = true
                cell.leftImageView.isHidden = false
                cell.leftTimeLabel.isHidden = false
                cell.leftUnReadCountLabel.isHidden = false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch contents[indexPath.row].cellType {
        case .message:
            // content의 크기에 맞는 라벨을 정의하고 해당 라벨의 높이가 40 초과 (두 줄 이상) or 40 (한 줄) 비교하여 높이 적용
            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")

            if indexPath.row > 0 {
                if contents[indexPath.row].message?.nickname == contents[indexPath.row - 1].message?.nickname { // 같은 사용자가 연속적으로 보낼 때
                    if labelHeight == 19.0 {
                        cellSize = CGSize(width: view.bounds.width, height: 55)
                    } else {
                        cellSize = CGSize(width: view.bounds.width, height: labelHeight + 36) // 55 - 19 = 36
                    }
                } else { // 다른 사용자가 보냈을 때
                    if labelHeight == 19.0 {
                        cellSize = CGSize(width: view.bounds.width, height: 65)
                    } else {
                        cellSize = CGSize(width: view.bounds.width, height: labelHeight + 21) // 40 - 19
                    }
                }
            } else { // 첫 번째 메세지일 때
                if labelHeight == 19.0 {
                    cellSize = CGSize(width: view.bounds.width, height: 40)
                } else {
                    cellSize = CGSize(width: view.bounds.width, height: labelHeight + 21) // 40 - 19
                }
            }
        case .participant:
            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].roomInfo?.roomInfo?.participants?.last ?? "")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight + 12) // padding top, bottom = 6
        case .maxMatching:
            let labelHeight = getMessageLabelHeight(text: "모든 파티원이 입장을 마쳤습니다!\n안내에 따라 메뉴를 입력해주세요")
            cellSize = CGSize(width: view.bounds.width, height: labelHeight + 12)
        default:
            cellSize = CGSize(width: view.bounds.width, height: 40)
        }
        
        return cellSize
    }
    
}

enum cellType {
    case participant
    case message
    case maxMatching
}

struct cellContents {
    var cellType: cellType?
    var message: MessageModel?
    var roomInfo: RoomInfoModel?
}


// TODO: - UI: contents[indexPath.row]로 닉네임 비교하니까 후에 없어져버림, 그리고 닉네임을 isHidden으로 하고 없는 게 아니기 때문에 그만큼의 간격이 더 생겨버림
// MARK: - 새로운 cell을 만들자, 그러면 일단 nicknameLabel은 해결된다. 이전 index와 nickname을 비교하는 로직은 다시 생각해 봐야,,
// MARK: - 전역으로 lastSender를 두면 ? cellType이 .message일 경우 nickname을 lastSender에 넣어뒀다가 새로운 메세지마다 nickname을 lastSender와 비교하고, 일치하면 nicknameLabel이 없는 cell을 보여주면 ? 불일치 시, nicknameLabel이 있는 라벨 -> 이러면,,일단 본인이냐 타인이냐를 먼저 나눠서 right, left를 hidden하고 lastSender와 같은지 비교해야겠네

// TODO: - Function: 읽은 사람 수 count, 나가기(방장일 때의 로직 처리만 남았음)

// MARK: - message 보낼 때 현재 채팅방 안에 들어와 있는 사람 수를 체크하고, 총 인원에 비해 안 들어와 있는 사람 수를 저장(메세지 보낼 때 같이)했다가 cell의 unReadLabel에 출력

// 채팅화면 들어올 때 본인 닉네임 뒤로 + 본인 참여 시점 뒤로 메세지 -> 띄워야 하는데 ... -> 참가자별 참여 시점을 ,, 넣어야 할까
// 참여 시점을 넣었다 -> participants, message 모두 contents 안에 넣어야 하기 때문에 participant time, message time 을 비교해야함
// 즉, 본인이 참여한 시간 이후의 참여자, 메세지들을 모아 놓고 두 개를 합쳐서 시간을 비교해서 정렬 (배열의 정렬)


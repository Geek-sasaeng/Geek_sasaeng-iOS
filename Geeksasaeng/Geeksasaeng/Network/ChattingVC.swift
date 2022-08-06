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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        collectionView.addGestureRecognizer(gesture)
        return collectionView
    }()
    
    /* bottomView components */
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        return view
    }()
    let menuButton: UIButton = {
        let button = UIButton()
        button.tintColor = .init(hex: 0x636363)
        button.setImage(UIImage(systemName: "rectangle.fill"), for: .normal)
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
    
    // MARK: - Properties
    var cellType: [cellContents] = [
        cellContents(cellType: .participant, contents: "apple님이 입장하였습니다"),
        cellContents(cellType: .participant, contents: "neoneo님이 입장하였습니다"),
        cellContents(cellType: .participant, contents: "seori님이 입장하였습니다"),
        cellContents(cellType: .message, contents: "안녕하세요"),
        cellContents(cellType: .message, contents: "네 안녕하세요"),
        cellContents(cellType: .message, contents: "메뉴 선택하셨나요?"),
        cellContents(cellType: .message, contents: "저는 돈가스 먹을게요")
    ]
    // TODO: - firestore에 participant가 들어올 경우 cellType: .participant로 해서 cellType.append
    let db = Firestore.firestore()
    var messages: [MessageModel] = []
    var userNickname: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        loadMessages()
        setCollectionView()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // TODO: - 채팅방 이름으로 title config
        self.navigationItem.title = "채팅방 이름"
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    }
    
    private func addSubViews() {
        [menuButton, contentsTextView, sendButton].forEach {
            bottomView.addSubview($0)
        }
        
        [collectionView, bottomView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(69)
        }
        
        menuButton.snp.makeConstraints { make in
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
            make.left.equalTo(menuButton.snp.right).offset(13)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
    }
    
    private func loadMessages() {
        db.collection("Rooms").document("TestRoom1").collection("Messages").order(by: "date").addSnapshotListener { querySnapshot, error in
            self.messages = []

            if let e = error {
                print(e.localizedDescription)
            } else {
                querySnapshot?.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let data = diff.document.data()
                        if let content = data["content"] as? String,
                           let nickname = data["nickname"] as? String,
                           let userImgUrl = data["userImgUrl"] as? String {
                            print(data, nickname, userImgUrl)
                            self.messages.append(MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl))

                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: true)
                            }
                        }
                    }
                }
//                if let snapshotDocuments = querySnapshot?.documents {
//                    snapshotDocuments.forEach { doc in
//                        let data = doc.data()
//                        if let content = data["content"] as? String,
//                           let nickname = data["nickname"] as? String,
//                           let userImgUrl = data["userImgUrl"] as? String {
//                            print(data, nickname, userImgUrl)
//                            self.messages.append(MessageModel(content: content, nickname: nickname, userImgUrl: userImgUrl))
//
//                            DispatchQueue.main.async {
//                                self.collectionView.reloadData()
//                                self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: true)
//                            }
//                        }
//                    }
//                }
            }
        }
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
    
    @objc func tapContentView() {
        view.endEditing(true)
    }
    
    // TODO: - TestRoom -> 서버에서 파티 생성, 상세조회 시 주는 고유 값으로 설정
    @objc func tapSendButton() {
        if let message = contentsTextView.text {
            db.collection("Rooms").document("TestRoom1").collection("Messages").document(UUID().uuidString).setData([
                "content": message,
                "nickname": LoginModel.nickname ?? "홍길동",
                "userImgUrl": LoginModel.userImgUrl ?? "https://"
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
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch cellType[indexPath.row].cellType {
//        case .participant:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
//            cell.participantLabel.text = cellType[indexPath.row].contents
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
//            cell.messageLabel.text = cellType[indexPath.row].contents
//            return cell
//        }
        let message = messages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        if message.nickname == LoginModel.nickname { // 보낸 사람이 자신이라면
            cell.leftImageView.isHidden = true // 왼쪽 imageView hidden
        } else {
            cell.rightImageView.isHidden = true
        }
        
        cell.messageLabel.text = message.content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width, height: 39)
        return cellSize
    }
    
}

enum cellType {
    case participant
    case message
}

struct cellContents {
    var cellType: cellType?
    var contents: String?
}

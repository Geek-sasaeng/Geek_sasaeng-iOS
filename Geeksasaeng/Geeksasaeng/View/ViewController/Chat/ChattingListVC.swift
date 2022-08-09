//
//  ChattingListVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/06.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

/* 채팅방 목록을 볼 수 있는 메인 채팅탭 */
class ChattingListViewController: UIViewController {
    
    // MARK: - Properties
    
    // 현재 선택되어 있는 필터의 label
    var selectedLabel: UILabel? = nil
    // 채팅 더미 데이터
    var chattingRoomList: [RoomInfoDetailModel] = [] {
        didSet {
            chattingTableView.reloadData()
        }
    }
    
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0xFCFDFE)
        
        setFirestore()
        loadChattingRoomList()
        
        setAttributes()
        setFilterStackView(filterNameArray: ["배달파티", "심부름", "거래"],
                           width: [80, 67, 54],
                           stackView: filterStackView)
        addSubViews()
        setLayouts()
        setTableView()
        setLabelTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chattingTableView.reloadData()
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
        db.collection("Rooms").getDocuments {
            (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if let data = try? document.data(as: RoomInfoModel.self) {
                            let chattingRoom = data.roomInfo
                            guard let chattingRoom = chattingRoom else { return }
                            self.chattingRoomList.append(chattingRoom)
                            print("DEBUG:", self.chattingRoomList)
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
            }
            label.textColor = .mainColor
            selectedLabel = label
        } else {
            // 선택돼있던 label이 재선택된 거면, 원래 색깔로 되돌려 놓는다 - 현재 선택된 필터 0개
            label.textColor = .init(hex: 0xD8D8D8)
            selectedLabel = nil
        }
    }
    
    @objc
    private func tapStorageBox() {
        // TODO: - 채팅 보관함으로 이동
        print("DEBUG: 채팅 보관함 아이콘 클릭")
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
        return cell
    }

    /* 채팅방 셀이 클릭될 때 실행되는 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀 데이터
//        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChattingListTableViewCell else { return }
        
        // 해당 채팅방으로 이동
        let chattingVC = ChattingViewController()
        // uuid값 더미데이터로 일단 넣어두고 테스트 완료
        chattingVC.roomUUID = "5e349b9b-549f-4c9b-971e-d00daf0bf24e"
//        chattingVC.maxMatching = detailData.maxMatching
        navigationController?.pushViewController(chattingVC, animated: true)
    }
}
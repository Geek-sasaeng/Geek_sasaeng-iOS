//
//  ForcedExitVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/09/28.
//

import UIKit
import SnapKit
import Then

// TODO: - 블러뷰 배경 터치 하면 alertview 없애기
class ForcedExitViewController: UIViewController {
    
    // MARK: - SubViews
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let userTableView = UITableView()
    
    let noticeLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 12)
        $0.textColor = .mainColor
        $0.text = "* 송급을 완료한 사용자는 강제퇴장이 불가합니다"
    }
    
    let bottomView = UIView().then {
        $0.backgroundColor = .init(hex: 0x94D5F1)
    }
    let countNumLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 16)
        $0.textColor = .white
    }
    lazy var nextButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.neoBold, size: 16)
        $0.isEnabled = false
        $0.setTitle("퇴장시킬 파티원을 선택해 주세요", for: .normal)
        $0.setImage(UIImage(named: "Arrow"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    var forcedExitConfirmView: UIView?
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    
    var partyId: Int?
    var roomId: String?
    var memberInfoList: [InfoForForcedExitModelResult]?
    var selectedMemberInfoList: [InfoForForcedExitModelResult] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsersInfo()
        setAttributes()
        setTableView()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "강제 퇴장시키기"
    }
    
    // MARK: - Initialization
    
    init(partyId: Int, roomId: String) {
        super.init(nibName: nil, bundle: nil)
        self.partyId = partyId
        self.roomId = roomId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    // 강제퇴장 뷰를 위한 채팅 참여자들 정보 불러오기
    private func getUsersInfo() {
        let input = InfoForForcedExitInput(partyId: self.partyId, roomId: self.roomId)
        ChatAPI.getInfoForForcedExit(input: input) { isSuccess, resultArray in
            if isSuccess {
                if let resultArray = resultArray {
                    self.memberInfoList = resultArray
                    self.userTableView.reloadData()
                }
            } else {
                self.showToast(viewController: self, message: "참여자들을 불러오는 데 실패했어요",
                          font: .customFont(.neoBold, size: 13), color: .mainColor)
            }
        }
    }
    
    private func setAttributes() {
        self.view.backgroundColor = .white
        userTableView.backgroundColor = .white
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        if let count = memberInfoList?.count {
            countNumLabel.text = "0/\(count) 명"
        } else {
            countNumLabel.text = "0/\(0) 명"
        }
    }
    
    private func setTableView() {
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.register(ForcedExitTableViewCell.self, forCellReuseIdentifier: ForcedExitTableViewCell.identifier)
        
        userTableView.rowHeight = 58
        userTableView.separatorStyle = .none
    }
    
    private func addSubViews() {
        [countNumLabel, nextButton].forEach {
            bottomView.addSubview($0)
        }
        [userTableView, noticeLabel, bottomView].forEach {
            containerView.addSubview($0)
        }
        view.addSubview(containerView)
    }
    
    private func setLayouts() {
        containerView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        userTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(55 + 59)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(83)
        }

        bottomView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        countNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(29)
            make.top.equalToSuperview().inset(17)
        }
        
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(17)
        }
    }
    
    private func createBlurView() {
        if visualEffectView == nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            visualEffectView.layer.opacity = 0.6
            visualEffectView.frame = view.frame
            visualEffectView.isUserInteractionEnabled = false
            view.addSubview(visualEffectView)
            self.visualEffectView = visualEffectView
        }
    }
    
    /* 강제퇴장되는 유저의 라벨(스택뷰) 생성 */
    private func createStackView(selectedMembers: [InfoForForcedExitModelResult]) -> UIStackView {
        var views: [UIStackView] = []
        selectedMembers.forEach {
            let profileImgUrl = URL(string: $0.userProfileImgUrl ?? "")
            let profileImageView = UIImageView().then {
                $0.kf.setImage(with: profileImgUrl)
                $0.layer.masksToBounds = true
                $0.layer.cornerRadius = 10
            }
            profileImageView.snp.makeConstraints { make in
                make.width.equalTo(19)
                make.height.equalTo(20)
            }
            
            let nickNameLabel = UILabel()
            nickNameLabel.text = $0.userName
            nickNameLabel.font = .customFont(.neoBold, size: 13)
            
            let subStackView = UIStackView(arrangedSubviews: [profileImageView, nickNameLabel])
            subStackView.snp.makeConstraints { make in
                make.width.equalTo(28 + nickNameLabel.getWidth(text: nickNameLabel.text ?? ""))
            }
            subStackView.axis = .horizontal
            subStackView.spacing = 9
            
            views.append(subStackView)
        }
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.width.equalTo(256)
        }
        
        return stackView // stackView 안에 stackView 구조
    }
    
    private func setForcedExitAlertView(stackView: UIStackView) {
        /* 강제퇴장 확인 Alert View & Alert View에 들어갈 Cmoponents */
        let view = UIView().then { view in
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 7
            view.snp.makeConstraints { make in
                make.width.equalTo(256)
                make.height.equalTo((stackView.arrangedSubviews.count * 20) + ((stackView.arrangedSubviews.count - 1) * 15) + 303)
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
                $0.text = "강제 퇴장시키기"
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
                // MARK: - 확인 버튼 addTarget 안 먹어서 일단 X버튼에 강퇴 연결해놓음
                $0.addTarget(self, action: #selector(self.tapExitConfirmButton), for: .touchUpInside)
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
                $0.text = "위 파티원을 강제로\n퇴장시킬 시 이 사용자는\n더 이상 참여할 수 없어요.\n퇴장을 진행할까요?"
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
            
            [stackView, contentLabel, lineView, confirmButton].forEach {
                bottomSubView.addSubview($0)
            }
            stackView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(35)
            }
            contentLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(stackView.snp.bottom).offset(38)
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
        
        forcedExitConfirmView = view
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func removeForcedExitConfirmView() {
        forcedExitConfirmView?.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
    }
    
    @objc
    private func tapNextButton() {
        createBlurView()
        
        let stackView = createStackView(selectedMembers: selectedMemberInfoList)
        setForcedExitAlertView(stackView: stackView)
        
        guard let forcedExitConfirmView = forcedExitConfirmView else { return }
        view.addSubview(forcedExitConfirmView)
        forcedExitConfirmView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // 확인 버튼 눌렀을 때 실행 -> 채팅방 강제퇴장 API 호출
    @objc
    private func tapExitConfirmButton() {
        let selectedChatMemberIdList = selectedMemberInfoList.map { infoList in
            infoList.chatMemberId ?? ""
        }
        let selectedMemberIdList = selectedMemberInfoList.map { infoList in
            infoList.memberId ?? 0
        }
        let input = ForcedExitInput(removedChatMemberIdList: selectedChatMemberIdList, roomId: self.roomId!)
        ChatAPI.forcedExitChat(input) { model in
            print(input)
            if let model = model {
                if model.code == 1000 {
                    let partyInput = ForcedExitPartyInput(membersId: selectedMemberIdList, partyId: self.partyId)
                    // 배달파티 강제퇴장 API 호출
                    PartyAPI.forcedExitParty(partyInput) { model in
                        if let model = model {
                            // 채팅, 파티 모두 강제퇴장 완료
                            if model.code == 1000 {
                                self.showToast(viewController: self,
                                               message: "강제 퇴장이 완료되었습니다",
                                               font: .customFont(.neoBold, size: 15),
                                               color: .mainColor)
                            }
                        }
                    }
                } else if model.code == 2026 {
                    self.showToast(viewController: self,
                                   message: "송금을 완료한 멤버는 방에서 퇴장시킬 수 없습니다",
                                   font: .customFont(.neoBold, size: 15),
                                   color: .mainColor)
                }
            } else {
                self.showToast(viewController: self,
                               message: "강제퇴장에 실패했습니다",
                               font: .customFont(.neoBold, size: 15),
                               color: .mainColor)
            }
        }
    }
}

extension ForcedExitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberInfoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForcedExitTableViewCell.identifier, for: indexPath) as? ForcedExitTableViewCell else { return UITableViewCell() }
        let row = memberInfoList?[indexPath.row]
        
        let profileImgUrl = URL(string: row?.userProfileImgUrl ?? "")
        cell.userProfileImage.kf.setImage(with: profileImgUrl)
        cell.userName.text = row?.userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ForcedExitTableViewCell else { return }
        
        selectedCell.cellIsSelected = !selectedCell.cellIsSelected
        
        // 선택 시
        if selectedCell.cellIsSelected == false {
            selectedCell.checkBox.image = UIImage(named: "CheckedSquare")
            selectedCell.userName.font = .customFont(.neoBold, size: 14)
            guard let memberInfo = memberInfoList?[indexPath.row] else { return }
            selectedMemberInfoList.append(memberInfo)
            countNumLabel.text = "\(selectedMemberInfoList.count)/\(memberInfoList?.count ?? 0) 명"
        } else { // 선택 해제 시
            selectedCell.checkBox.image = UIImage(named: "UncheckedSquare")
            selectedCell.userName.font = .customFont(.neoMedium, size: 14)
            guard let memberInfo = memberInfoList?[indexPath.row] else { return }
            selectedMemberInfoList = selectedMemberInfoList.filter {
                $0.memberId != memberInfo.memberId
            }
            countNumLabel.text = "\(selectedMemberInfoList.count)/\(memberInfoList?.count ?? 0) 명"
        }
        
        /* selectedMemberInfoList의 수가 0이면 other color + "선택해 주세요" / 1 이상이면 mainColor + "다음" */
        if selectedMemberInfoList.count == 0 {
            bottomView.backgroundColor = .init(hex: 0x94D5F1)
            nextButton.isEnabled = false
            nextButton.setTitle("퇴장시킬 파티원을 선택해 주세요", for: .normal)
        } else {
            bottomView.backgroundColor = .mainColor
            nextButton.isEnabled = true
            nextButton.setTitle("다음", for: .normal)
        }
    }
}

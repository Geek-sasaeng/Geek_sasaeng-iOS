//
//  ForcedExitVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/09/28.
//

import UIKit
import SnapKit
import Then

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
        $0.imageEdgeInsets = .init(top: 0, left: 11, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    var forcedExitConfirmView: UIView?
    
    var visualEffectView: UIVisualEffectView?
    
    // MARK: - Properties
    var users = ["apple", "neo", "seori", "zero", "runa", "runa", "runa", "runa", "runa", "runa", "runa", "runa", "runa"]
    var selectedUsers: [String]? = []
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.backgroundColor = .white
        
        setAttributes()
        setTableView()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "강제 퇴장시키기"
    }
    
    
    // MARK: - Functions
    private func setAttributes() {
        self.view.backgroundColor = .white
        countNumLabel.text = "0/\(users.count) 명"
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
            make.bottom.equalToSuperview().inset(55)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(83)
        }

        bottomView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        countNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(29)
            make.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
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
    private func createStackView(users: [String]) -> UIStackView {
        var views: [UIStackView] = []
        users.forEach {
            let imageView = UIImageView(image: UIImage(named: "ProfileImage"))
            imageView.snp.makeConstraints { make in
                make.width.equalTo(19)
                make.height.equalTo(20)
            }
            
            let label = UILabel()
            label.text = $0
            label.font = .customFont(.neoBold, size: 13)
            
            let subStackView = UIStackView(arrangedSubviews: [imageView, label])
            subStackView.snp.makeConstraints { make in
                make.width.equalTo(28 + label.getWidth(text: label.text ?? ""))
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
                $0.addTarget(self, action: #selector(self.removeForcedExitConfirmView), for: .touchUpInside)
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
                $0.text = "위 파티원을 강제로\n퇴장시킬 시 이 사용자는\n더 이상 참여할 수 없습니다.\n계속하시겠습니까?"
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
                // MARK: - addTarget 기능 구현
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
    
    @objc
    private func removeForcedExitConfirmView() {
        forcedExitConfirmView?.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
        visualEffectView = nil
    }
    
    @objc
    private func tapNextButton() {
        createBlurView()
        
        guard let selectedUsers = selectedUsers else { return }
        let stackView = createStackView(users: selectedUsers)
        setForcedExitAlertView(stackView: stackView)
        
        guard let forcedExitConfirmView = forcedExitConfirmView else { return }
        view.addSubview(forcedExitConfirmView)
        forcedExitConfirmView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension ForcedExitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForcedExitTableViewCell.identifier, for: indexPath) as? ForcedExitTableViewCell else { return UITableViewCell() }
        
        cell.userName.text = users[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ForcedExitTableViewCell else { return }
        
        if selectedCell.cellIsSelected == false {
            selectedCell.cellIsSelected = true
            selectedUsers?.append(users[indexPath.row])
            selectedCell.checkBox.image = UIImage(systemName: "checkmark.square.fill")
            selectedCell.userProfileImage.image = UIImage(named: "ProfileImage")
            selectedCell.userName.font = .customFont(.neoBold, size: 14)
            countNumLabel.text = "\(selectedUsers?.count ?? 0)/\(users.count) 명"
        } else {
            selectedCell.cellIsSelected = false
            selectedUsers = selectedUsers?.filter { $0 != users[indexPath.row] }
            selectedCell.checkBox.image = UIImage(systemName: "checkmark.square")
            selectedCell.userProfileImage.image = UIImage(named: "ForcedExit_unSelectedProfile")
            selectedCell.userName.font = .customFont(.neoMedium, size: 14)
            countNumLabel.text = "\(selectedUsers?.count ?? 0)/\(users.count) 명"
        }
        
        /* selectedUsers의 수가 0이면 other color + "선택해 주세요" / 1이상이면 mainColor + "다음" */
        if selectedUsers?.count == 0 {
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

// 1. ChattingVC에서 넘어올 때 송금하기 상단 뷰가 위로 밀리는 현상

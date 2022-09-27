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
        $0.backgroundColor = .green
    }
    
    let userTableView = UITableView()
    
    let bottomView = UIView().then {
        $0.backgroundColor = .mainColor
    }
    let countNumLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 16)
        $0.textColor = .white
    }
    let nextButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.neoBold, size: 16)
        $0.setTitle("다음", for: .normal)
        $0.setImage(UIImage(named: "Arrow"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = .init(top: 0, left: 11, bottom: 0, right: 0)
    }
    
    
    // MARK: - Properties
    var users = ["apple", "neo", "seori", "zero", "runa", "runa", "runa", "runa", "runa", "runa", "runa", "runa", "runa"]
    var selectedUsers: [String]?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.backgroundColor = .red
        
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
        [userTableView, bottomView].forEach {
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
            countNumLabel.text = "\(selectedUsers?.count)/\(users.count) 명"
            print(selectedUsers)
        } else {
            selectedCell.cellIsSelected = false
            selectedUsers = selectedUsers?.filter { $0 != users[indexPath.row] }
            selectedCell.checkBox.image = UIImage(systemName: "checkmark.square")
            selectedCell.userProfileImage.image = UIImage(named: "ForcedExit_unSelectedProfile")
            selectedCell.userName.font = .customFont(.neoMedium, size: 14)
            countNumLabel.text = "\(selectedUsers?.count)/\(users.count) 명"
            print(selectedUsers)
        }
    }
}

// 1. selectedUsers.append 작동 x

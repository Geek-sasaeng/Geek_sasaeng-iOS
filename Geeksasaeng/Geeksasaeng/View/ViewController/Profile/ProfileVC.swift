//
//  ProfileVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/16.
//

import UIKit

import SnapKit
import Then
import Kingfisher

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    var ongoingPartyList: [UserInfoPartiesModel] = [] {
        didSet {
            ongoingTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 118 / 2
    }
    let levelIconImageView = UIImageView(image: UIImage(named: "LevelIcon")).then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 37 / 2
        // 테두리 그림자 생성
        $0.layer.shadowRadius = 5
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.masksToBounds = false
    }
    
    let degreeLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    let dotImageView = UIImageView(image: UIImage(named: "Dot"))
    let univLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    let nickNameLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 17)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    let levelGuideView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF1F5F9)
        $0.layer.cornerRadius = 39 / 2
        let guideLabel = UILabel().then {
            // TODO: - 남은 학기 계산해서 표시
            $0.text = "복학까지 2학기 남았어요"
            $0.font = .customFont(.neoMedium, size: 14)
            $0.textColor = .mainColor
        }
        $0.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // 신입생 lv 이미지
    let freshmanView = UIView().then {
        $0.layer.cornerRadius = 11 / 2
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(11)
        }
        $0.backgroundColor = .mainColor
    }
    // 복학생 lv 이미지
    let returningStudentView = UIView().then {
        $0.layer.cornerRadius = 7 / 2
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(7)
        }
        $0.backgroundColor = .init(hex: 0xD9D9D9)
    }
    // 졸업생 lv 이미지
    let graduateView = UIView().then {
        $0.layer.cornerRadius = 7 / 2
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(7)
        }
        $0.backgroundColor = .init(hex: 0xD9D9D9)
    }
    
    // level 정보에 관한 스택뷰들
    let levelViewStackView = UIStackView()
    let levelLabelStackView = UIStackView()
    
    // level 바
    let freshmanBar = UIView().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 2.5
    }
    let totalBar = UIView().then {
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        $0.layer.cornerRadius = 2.5
    }
    
    let ongoingLabel = UILabel().then {
        $0.text = "진행 중인 활동"
        $0.font = .customFont(.neoMedium, size: 16)
        $0.textColor = .init(hex: 0x2F2F2F)
    }
    
    let ongoingTableView = UITableView()
    
    /* 구분선 View */
    let separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    
    /* 공지사항 옆에 파란색 동그라미 */
    let noticeCheckAlarmView = UIView().then {
        $0.backgroundColor = .mainColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5 / 2
    }
    
    /* 공지사항, 나의 활동 보기, 나의 정보, 문의하기, 이용 약관 보기 */
    let noticeLabel = UILabel().then { $0.text = "공지사항" }
    let myActivityLabel = UILabel().then { $0.text = "나의 활동 보기" }
    let myInfoLabel = UILabel().then { $0.text = "나의 정보" }
    let contactUsLabel = UILabel().then { $0.text = "문의하기" }
    let termsOfUseLabel = UILabel().then { $0.text = "서비스 이용 약관 보기" }
    
    // 공지사항 contents 뷰
    let noticeView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .init(hex: 0xEFEFEF)
        
        let noticeImageView = UIImageView(image: UIImage(named: "NoticeImage"))
        $0.addSubview(noticeImageView)
        noticeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(17)
        }
        
        let noticeContentLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .init(hex: 0x2F2F2F)
            $0.text = "긱사생 이용자분들께 알립니다. 본 공지는 더미 데이터입니다."
        }
        $0.addSubview(noticeContentLabel)
        noticeContentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(noticeImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    // 공지사항, 나의 활동 보기, 나의 정보, 문의하기, 이용 약관 보기 옆의 화살표 버튼
    let noticeArrowButton = UIButton()
    let myActivityArrowButton = UIButton()
    let myInfoArrowButton = UIButton()
    let contactUsArrowButton = UIButton()
    let termsOfUseArrowButton = UIButton()
    
    // 구분선들
    let firstLineView = UIView()
    let secondLineView = UIView()
    let thirdLineView = UIView()
    let fourthLineView = UIView()
    
    // 버전 표시
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "ver. 1.0"
        label.textColor = .init(hex: 0xA8A8A8)
        label.font = .customFont(.neoMedium, size: 12)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributes()
        
        /* 스택뷰 설정 */
        setStackView(passedArray: [freshmanView, returningStudentView, graduateView], stackView: levelViewStackView)
        setStackView(passedArray: ["신입생", "복학생", "졸업생"], stackView: levelLabelStackView)
        
        setUserInfo()
        addSubViews()
        setLayouts()
        setTableView()
    }
    
    // MARK: - Functions
    
    private func setUserInfo() {
        UserInfoAPI.getUserInfo { isSuccess, result in
            let url = URL(string: result.profileImgUrl!)
            self.profileImageView.kf.setImage(with: url)
            self.degreeLabel.text = result.dormitoryName
            self.univLabel.text = result.universityName
            self.nickNameLabel.text = result.nickname
            self.ongoingPartyList = result.parties!
        }
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 정보"
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "Bell"), style: .plain, target: self, action: #selector(tapBellButton)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    
        ongoingTableView.backgroundColor = .white
        
        /* 서비스 labels Attrs 설정 */
        [ noticeLabel, myActivityLabel, myInfoLabel, contactUsLabel, termsOfUseLabel].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x2F2F2F)
        }
        
        [firstLineView, secondLineView, fourthLineView].forEach {
            $0.backgroundColor = .init(hex: 0xF8F8F8)
        }
        
        /* 화살표 버튼들 */
        [ noticeArrowButton, myActivityArrowButton, myInfoArrowButton, contactUsArrowButton, termsOfUseArrowButton ].forEach {
            $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
        }
        /* 타겟 설정 */
        myInfoArrowButton.addTarget(self, action: #selector(tapMyInfoButton), for: .touchUpInside)
    }
    
    // 스택뷰 구성
    private func setStackView(passedArray: [Any], stackView: UIStackView) {
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        if let viewArray = passedArray as? [UIView] {
            stackView.spacing = 110
            for view in viewArray {
                stackView.addArrangedSubview(view)
            }
        } else {
            let stringArray = passedArray as! [String]
            stackView.spacing = 85
            for string in stringArray {
                let label = UILabel().then {
                    $0.font = .customFont(.neoMedium, size: 12)
                    $0.textColor = .init(hex: 0x636363)
                    $0.text = string
                }
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            profileImageView,
            levelIconImageView,
            degreeLabel, dotImageView, univLabel,
            nickNameLabel,
            levelGuideView,
            levelViewStackView,
            totalBar, freshmanBar,
            levelLabelStackView,
            ongoingLabel,
            ongoingTableView,
            separateView,
            noticeCheckAlarmView,
            noticeLabel,
            noticeView, noticeArrowButton,
            firstLineView,
            myActivityLabel, myActivityArrowButton,
            secondLineView,
            myInfoLabel, myInfoArrowButton,
            thirdLineView,
            contactUsLabel, contactUsArrowButton,
            fourthLineView,
            termsOfUseLabel, termsOfUseArrowButton,
            versionLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.width.equalTo(view.safeAreaLayoutGuide)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(versionLabel.snp.bottom).offset(21)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(118)
        }
        levelIconImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(3)
            make.left.equalTo(profileImageView.snp.left).offset(-6)
            make.width.height.equalTo(37)
        }
        
        dotImageView.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(18)
            make.width.height.equalTo(3)
        }
        degreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dotImageView)
            make.right.equalTo(dotImageView.snp.left).offset(-5)
        }
        univLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dotImageView)
            make.left.equalTo(dotImageView.snp.right).offset(5)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(univLabel.snp.bottom).offset(4)
        }
        levelGuideView.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(13)
            make.centerX.equalTo(nickNameLabel)
            make.width.equalTo(180)
            make.height.equalTo(39)
        }
        levelViewStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelGuideView.snp.bottom).offset(17)
            make.height.equalTo(11)
        }
        totalBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(44)
            make.top.equalTo(levelViewStackView.snp.bottom).offset(9)
            make.height.equalTo(5)
        }
        freshmanBar.snp.makeConstraints { make in
            make.top.left.equalTo(totalBar)
            make.width.equalTo((UIScreen.main.bounds.width - 44 - 44) / 3)
            make.height.equalTo(5)
        }
        levelLabelStackView.snp.makeConstraints { make in
            make.centerX.equalTo(totalBar)
            make.top.equalTo(totalBar.snp.bottom).offset(11)
        }
        
        ongoingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelLabelStackView.snp.bottom).offset(38)
        }
        ongoingTableView.snp.makeConstraints { make in
            make.top.equalTo(ongoingLabel.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(42)
            make.height.equalTo(9 + 44 + 9 + 44 + 9 + 44)
        }
        separateView.snp.makeConstraints { make in
            make.top.equalTo(ongoingTableView.snp.bottom).offset(31)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        noticeCheckAlarmView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(11)
            make.left.equalToSuperview().inset(81)
            make.width.height.equalTo(5)
        }
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeCheckAlarmView.snp.bottom).offset(1)
            make.left.equalToSuperview().inset(24)
        }
        noticeView.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(13)
            make.left.equalToSuperview().inset(29)
            make.right.equalToSuperview().inset(27)
            make.height.equalTo(42)
        }
        firstLineView.snp.makeConstraints { make in
            make.top.equalTo(noticeView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(19)
            make.height.equalTo(1)
        }
        myActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        secondLineView.snp.makeConstraints { make in
            make.top.equalTo(myActivityLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        thirdLineView.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        contactUsLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        fourthLineView.snp.makeConstraints { make in
            make.top.equalTo(contactUsLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        termsOfUseLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        
        noticeArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(noticeLabel)
            make.right.equalToSuperview().inset(31)
        }
        myActivityArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(myActivityLabel)
            make.right.equalToSuperview().inset(31)
        }
        myInfoArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(myInfoLabel)
            make.right.equalToSuperview().inset(31)
        }
        contactUsArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(contactUsLabel)
            make.right.equalToSuperview().inset(31)
        }
        termsOfUseArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(termsOfUseLabel)
            make.right.equalToSuperview().inset(31)
        }
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(termsOfUseLabel.snp.bottom).offset(43)
        }
    }
    
    private func setTableView() {
        ongoingTableView.dataSource = self
        ongoingTableView.delegate = self
        ongoingTableView.register(OngoingTableViewCell.self, forCellReuseIdentifier: OngoingTableViewCell.identifier)
        
        ongoingTableView.rowHeight = 53
        ongoingTableView.separatorColor = .none
        ongoingTableView.separatorStyle = .none
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapBellButton() {
        print("DEBUG: 종 버튼 클릭")
    }
    
    @objc
    private func tapPencilButton() {
        print("DEBUG: 연필 버튼 클릭")
    }
    
    @objc
    private func tapMyInfoButton() {
        print("DEBUG: 나의 정보 화살표 클릭")
        let myInfoVC = MyInfoViewController()
        navigationController?.pushViewController(myInfoVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingPartyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OngoingTableViewCell.identifier, for: indexPath) as? OngoingTableViewCell else { return UITableViewCell() }
        
        // index에 따른 title, partyId 설정
        cell.partyTitle = ongoingPartyList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let partyId = ongoingPartyList[indexPath.row].id else { return }
        let partyVC = PartyViewController(partyId: partyId)
        self.navigationController?.pushViewController(partyVC, animated: true)
    }
}

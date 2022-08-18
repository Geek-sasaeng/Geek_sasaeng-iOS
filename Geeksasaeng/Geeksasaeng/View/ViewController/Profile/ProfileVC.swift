//
//  ProfileVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/16.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    var ongoingPartyIdList: [Int] = []
    
    // MARK: - SubViews
    
    // 스크롤뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DefaultProfile"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 118 / 2
        return imageView
    }()
    let levelIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TempLevelIcon"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 37 / 2
        // 테두리 그림자 생성
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "별별학사"
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    let dotImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Dot"))
        return imageView
    }()
    let univLabel: UILabel = {
        let label = UILabel()
        label.text = "별별대학교"
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "NEO1"
        label.font = .customFont(.neoBold, size: 17)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    // 신입생 lv 이미지
    let freshmanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        imageView.image = UIImage(named: "TempLevelImage")
        return imageView
    }()
    // 복학생 lv 이미지
    let returningStudentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        imageView.image = UIImage(named: "TempLevelImage")
        return imageView
    }()
    // 졸업생 lv 이미지
    let graduateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        imageView.image = UIImage(named: "TempLevelImage")
        return imageView
    }()
    
    // level 정보에 관한 스택뷰들
    let levelImageStackView = UIStackView()
    let levelLabelStackView = UIStackView()
    
    // level 바
    let freshmanBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 2.5
        return view
    }()
    let totalBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    let ongoingLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 중인 활동"
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    let ongoingTableView = UITableView()
    
    /* 구분선 View */
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    /* 공지사항 옆에 파란색 동그라미 */
    let noticeCheckAlarmView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 5 / 2
        return view
    }()
    
    /* 공지사항, 나의 활동 보기, 나의 정보, 문의하기, 이용 약관 보기 */
    let noticeLabel = UILabel()
    let myActivityLabel = UILabel()
    let myInfoLabel = UILabel()
    let contactUsLabel = UILabel()
    let termsOfUseLabel = UILabel()
    
    // 공지사항 contents 뷰
    let noticeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .init(hex: 0xEFEFEF)
        
        let noticeImageView = UIImageView(image: UIImage(named: "NoticeImage"))
        view.addSubview(noticeImageView)
        noticeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(17)
        }
        
        let noticeContentLabel: UILabel = {
            let label = UILabel()
            label.font = .customFont(.neoMedium, size: 13)
            label.textColor = .init(hex: 0x2F2F2F)
            label.text = "긱사생 이용자분들께 알립니다. 본 공지는 더미 데이터입니다."
            return label
        }()
        view.addSubview(noticeContentLabel)
        noticeContentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(noticeImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(16)
        }
        
        return view
    }()
    
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
        setStackView(passedArray: [freshmanImageView, returningStudentImageView, graduateImageView], stackView: levelImageStackView)
        setStackView(passedArray: ["신입생", "복학생", "졸업생"], stackView: levelLabelStackView)
        
        addSubViews()
        setLayouts()
        setTableView()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 정보"
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(named: "Bell"), style: .plain, target: self, action: #selector(tapBellButton)
                           ), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    
        /* 서비스 labels Attrs 설정 */
        [ noticeLabel, myActivityLabel, myInfoLabel, contactUsLabel, termsOfUseLabel].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x2F2F2F)
        }
        
        noticeLabel.text = "공지사항"
        myActivityLabel.text = "나의 활동 보기"
        myInfoLabel.text = "나의 정보"
        contactUsLabel.text = "문의하기"
        termsOfUseLabel.text = "서비스 이용 약관 보기"
        
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
        if let imageArray = passedArray as? [UIImageView] {
            stackView.axis = .horizontal
            stackView.sizeToFit()
            stackView.layoutIfNeeded()
            stackView.distribution = .fillProportionally
            stackView.alignment = .center
            stackView.spacing = 95
            
            for imageView in imageArray {
                stackView.addArrangedSubview(imageView)
            }
        } else {
            let stringArray = passedArray as! [String]
            stackView.axis = .horizontal
            stackView.sizeToFit()
            stackView.layoutIfNeeded()
            stackView.distribution = .fillProportionally
            stackView.alignment = .center
            stackView.spacing = 75
            
            for string in stringArray {
                let label = UILabel()
                label.font = .customFont(.neoMedium, size: 12)
                label.textColor = .init(hex: 0x636363)
                label.text = string
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
            levelImageStackView,
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
        levelImageStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(22)
        }
        totalBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(44)
            make.top.equalTo(levelImageStackView.snp.bottom).offset(9)
            make.height.equalTo(5)
        }
        freshmanBar.snp.makeConstraints { make in
            make.top.left.equalTo(totalBar)
            make.width.equalTo((UIScreen.main.bounds.width - 44 - 44) / 3)
            make.height.equalTo(5)
        }
        levelLabelStackView.snp.makeConstraints { make in
            make.centerX.equalTo(totalBar)
            make.top.equalTo(totalBar.snp.bottom).offset(12)
        }
        
        ongoingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelLabelStackView.snp.bottom).offset(49)
        }
        ongoingTableView.snp.makeConstraints { make in
            make.top.equalTo(ongoingLabel.snp.bottom).offset(27-9)
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
//        ongoingTableView.
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
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OngoingTableViewCell.identifier, for: indexPath) as? OngoingTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        /* 가장 최근에 참여한 배달 파티 3개 가져오는 API 호출 */
        RecentPartyViewModel.requestGetRecentPartyList { result in
            // 성공 시에만 title, partyId 설정
            cell.partyTitle = result[row].title
            
            guard let partyId = result[row].id else { return }
            self.ongoingPartyIdList.append(partyId)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partyVC = PartyViewController()
        partyVC.partyId = ongoingPartyIdList[indexPath.row]
        self.navigationController?.pushViewController(partyVC, animated: true)
    }
}

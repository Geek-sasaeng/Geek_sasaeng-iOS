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
import KakaoSDKTalk
import SafariServices

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    var naverLoginVM = naverLoginViewModel()
    var safariVC: SFSafariViewController?
    var myActivities: [EndedDeliveryPartyList] = [] {
        didSet {
            myActivityCollectionView.reloadData()
        }
    }
    var updatedAt: [String] = []
    
    
    // MARK: - SubViews
    
    /* MyInfo View가 올라가는 background View */
    let backgroundView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    
    /* grade & 복학까지 ~ 가 들어있는 view */
    let gradeView = UIView().then { view in
        view.backgroundColor = .mainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // TODO: - gradeLabel, remainLabel getUserInfo API에서 불러와야 함
        let gradeLabel = UILabel().then {
            $0.font = .customFont(.neoBold, size: 12)
            $0.textColor = .white
            $0.text = "신입생"
        }
        let separateImageView = UIImageView(image: UIImage(named: "MyInfoSeparateIcon"))
        let remainLabel = UILabel().then {
            $0.font = .customFont(.neoMedium, size: 12)
            $0.textColor = .white
            $0.text = "복학까지 5학점 남았어요"
        }
        let arrowImageView = UIImageView(image: UIImage(named: "MyInfoArrowIcon"))
        
        [ gradeLabel, separateImageView, remainLabel, arrowImageView ].forEach {
            view.addSubview($0)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        separateImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(gradeLabel.snp.right).offset(12)
        }
        remainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(separateImageView.snp.right).offset(12)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(remainLabel.snp.right).offset(6)
        }
    }
    
    /* 내 정보 View Components */
    let heartImageView = UIImageView(image: UIImage(named: "MyInfoCardIcon"))
    let nicknameLabel = UILabel().then {
        $0.font = .customFont(.neoBold, size: 20)
    }
    let universityLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = .init(hex: 0x636363)
    }
    let dormitoryLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = .init(hex: 0x636363)
    }
    let profileImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 54
    }
    
    /* 내 정보 view */
    lazy var myInfoView = UIView().then { view in
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.setViewShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.17).cgColor, shadowOpacity: 1, shadowRadius: 7)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMyInfoView))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 나의 활동 보기 옆의 화살표 버튼
    lazy var myActivityArrowButton = UIButton().then {
        $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
        $0.addTarget(self, action: #selector(tapMyActivityArrowButton), for: .touchUpInside)
    }
    /* 나의 활동 container view */
    lazy var myActivityContainerView = UIView()
    
    /* 나의 활동 view (활동 내역이 있을 때) */
    lazy var existMyActivityView = UIView().then { view in
        view.isUserInteractionEnabled = true
        let showMyActivityLabel = UILabel().then {
            $0.text = "나의 활동 보기"
            $0.font = .customFont(.neoMedium, size: 15)
        }
        
        [ showMyActivityLabel, self.myActivityArrowButton].forEach {
            view.addSubview($0)
        }
        showMyActivityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27)
            make.left.equalToSuperview().inset(24)
        }
        myActivityArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(showMyActivityLabel.snp.centerY)
            make.right.equalToSuperview().inset(30)
        }
    }
    let myActivityCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 7
        
        let screenWidth = UIScreen.main.bounds.width
        $0.itemSize = CGSize(width: (screenWidth-54)/3, height: 84 + 17 + 22)
        
        $0.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    lazy var myActivityCollectionView = UICollectionView(frame: .zero, collectionViewLayout: myActivityCollectionViewFlowLayout)
    
    /* 나의 활동 view (활동 내역이 없을 때) */
    let noneMyActivityView = UIView().then { view in
        let noneActivityLabel = UILabel().then {
            $0.text = "진행한 활동이 없어요"
            $0.font = .customFont(.neoMedium, size: 18)
            $0.textColor = .init(hex: 0x636363)
        }
        let noneActivityImageView = UIImageView(image: UIImage(named: "NoneActivityIcon"))
        
        [ noneActivityLabel, noneActivityImageView ].forEach {
            view.addSubview($0)
        }
        
        noneActivityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(40)
        }
        noneActivityImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
    }
    
    /* 구분선 View */
    let separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    let firstLineView = UIView()
    let secondLineView = UIView()
    
    /* 나의 정보 수정, 문의하기, 이용 약관 보기, 로그아웃 */
    let editMyInfoLabel = UILabel().then { $0.text = "나의 정보 수정" }
    let customerServiceLabel = UILabel().then { $0.text = "고객센터" }
    let logoutLabel = UILabel().then { $0.text = "로그아웃"}
    
    lazy var withdrawalMembershipButton = UIButton().then {
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoMedium, size: 13)
        $0.makeBottomLine(color: 0xA8A8A8, width: 48, height: 1, offsetToTop: -8)
        $0.setTitle("회원탈퇴", for: .normal)
        $0.addTarget(self, action: #selector(tapWithdrawalMembershipButton), for: .touchUpInside)
    }
    
    // 나의 정보 수정, 문의하기, 이용 약관 보기, 로그아웃 옆의 화살표 버튼
    let editMyInfoArrowButton = UIButton()
    let customerServiceButton = UIButton()
    let logoutArrowButton = UIButton()
    
    lazy var logoutView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "로그아웃"
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
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
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
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(186)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "서비스 사용이 제한되며,\n로그인이 필요해요.\n로그아웃을 진행할까요?"
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
            $0.addTarget(self, action: #selector(self.tapLogoutConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
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
    
    lazy var withdrawalMembershipView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.text = "회원탈퇴"
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
            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
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
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(186)
        }
        
        let contentLabel = UILabel().then {
            $0.text = "긱사생 서비스를 더 이상\n이용할 수 없어요.\n탈퇴를 진행할까요?"
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
            $0.addTarget(self, action: #selector(self.tapWithdrawalMembershipConfirmButton), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(23)
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
    
    var visualEffectView: UIVisualEffectView?

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributes()
        setCollectionView()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 나의 활동 3개 띄우기
        self.getUserInfo()
        self.getUserActivities()
        
        // 다른 VC에서 여기에 토스트 메세지를 띄우기 위한 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(completeChangingPw), name: NSNotification.Name("CompleteChangingPw"), object: nil)
    }
    
    // MARK: - Functions
    
    // 배경의 블러뷰를 터치하면 띄워진 뷰와 블러뷰가 같이 사라지도록 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == self.visualEffectView {
            visualEffectView?.removeFromSuperview()
            // view에 addSubview가 된 즉, 현재 띄워져있는 뷰인지 확인
            if logoutView.isDescendant(of: view) {
                logoutView.removeFromSuperview()
            } else if withdrawalMembershipView.isDescendant(of: view) {
                withdrawalMembershipView.removeFromSuperview()
            }
        }
    }
    
    private func getUserInfo() {
        MyLoadingView.shared.show()
        
        UserInfoAPI.getUserInfo { isSuccess, result in
            MyLoadingView.shared.hide()
            
            if isSuccess {
                self.nicknameLabel.text = result.nickname
                self.universityLabel.text = result.universityName
                self.dormitoryLabel.text = result.dormitoryName
                
                let url = URL(string: result.profileImgUrl!)
                self.profileImageView.kf.setImage(with: url)
            }
        }
    }
    
    // 나의 활동 3개 데이터 보여주기
    private func getUserActivities() {
        MyLoadingView.shared.show()
        
        // 목록의 최상단 3개를 가져와서 보여준다
        UserInfoAPI.getMyActivityList(cursor: 0) { isSuccess, result in
            MyLoadingView.shared.hide()
            
            // 활동 내역이 있냐 없냐에 따라 맞는 뷰 띄워주기
            if let parties = result?.endedDeliveryPartiesVoList {
                if parties.count == 0 { // 활동 내역이 없을 때
                    self.showNoneMyActivityView()
                } else { // 있으면 내역 띄우기
                    self.showExistMyActivityView()
                }
            } else { // 활동 내역이 없을 때
                self.showNoneMyActivityView()
            }
            
            if isSuccess {
                if let result = result {
                    guard var parties = result.endedDeliveryPartiesVoList else { return }
                    // 3개보다 많으면 그 뒤에 데이터들은 안 쓴다
                    if parties.count > 3 {
                        let endIdx = parties.index(parties.startIndex, offsetBy: 2)
                        parties = Array(parties[...endIdx])
                    }
                    self.myActivities = parties
                    
                    parties.forEach {
                        let str = $0.updatedAt
                        let endIdx = str?.index(str!.startIndex, offsetBy: 10)
                        self.updatedAt.append(String(str![...endIdx!]))
                    }
                }
            } else {
                self.showToast(viewController: self, message: "나의 활동을 불러오지 못했어요", font: .customFont(.neoBold, size: 15), color: .mainColor)
            }
        }
    }
    
    private func setCollectionView() {
        myActivityCollectionView.backgroundColor = .white
        myActivityCollectionView.dataSource = self
        myActivityCollectionView.delegate = self
        myActivityCollectionView.register(MyActivityCollectionViewCell.self, forCellWithReuseIdentifier: MyActivityCollectionViewCell.identifier)
    }
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 정보"
        
        /* 서비스 labels Attrs 설정 */
        [ editMyInfoLabel, customerServiceLabel, logoutLabel ].forEach {
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x2F2F2F)
        }
        
        /* 구분선 설정 */
        [firstLineView, secondLineView].forEach {
            $0.backgroundColor = .init(hex: 0xF8F8F8)
        }
        
        /* 화살표 버튼들 */
        [ editMyInfoArrowButton, customerServiceButton, logoutArrowButton ].forEach {
            $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
        }
        
        /* 타겟 설정 */
        editMyInfoArrowButton.addTarget(self, action: #selector(tapEditMyInfoButton), for: .touchUpInside)
        logoutArrowButton.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
        customerServiceButton.addTarget(self, action: #selector(tapcustomerServiceButton), for: .touchUpInside)
        
        gradeView.isUserInteractionEnabled = true
        let gestureToGradeView = UITapGestureRecognizer(target: self, action: #selector(showUserStageView))
        gradeView.addGestureRecognizer(gestureToGradeView)
    }
    
    private func createBlurView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    private func addSubViews() {
        [ heartImageView, nicknameLabel, universityLabel, dormitoryLabel, profileImageView ].forEach {
            myInfoView.addSubview($0)
        }
        myInfoView.addSubview(gradeView)
        backgroundView.addSubview(myInfoView)
        
        [
            backgroundView,
            myActivityContainerView,
            separateView,
            editMyInfoLabel, editMyInfoArrowButton, firstLineView,
            customerServiceLabel, customerServiceButton, secondLineView,
            logoutLabel, logoutArrowButton,
            withdrawalMembershipButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(285)
        }
        
        gradeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        heartImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(heartImageView.snp.top)
            make.left.equalToSuperview().inset(50)
        }
        universityLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.left.equalTo(nicknameLabel.snp.left)
        }
        dormitoryLabel.snp.makeConstraints { make in
            make.top.equalTo(universityLabel.snp.bottom).offset(10)
            make.left.equalTo(universityLabel.snp.left)
        }
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(36)
            make.width.height.equalTo(108)
        }
        
        myInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(166)
        }
        
        myActivityContainerView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(162)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(myActivityContainerView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }

        editMyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        firstLineView.snp.makeConstraints { make in
            make.top.equalTo(editMyInfoLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(19)
            make.height.equalTo(1)
        }

        customerServiceLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }
        secondLineView.snp.makeConstraints { make in
            make.top.equalTo(customerServiceLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(1)
        }
        
        logoutLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLineView.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(24)
        }

        editMyInfoArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(editMyInfoLabel)
            make.right.equalToSuperview().inset(31)
        }
        customerServiceButton.snp.makeConstraints { make in
            make.centerY.equalTo(customerServiceLabel)
            make.right.equalToSuperview().inset(31)
        }
        logoutArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutLabel)
            make.right.equalToSuperview().inset(31)
        }
        
        withdrawalMembershipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoutLabel.snp.bottom).offset(100)
        }
    }
    
    // 진행한 활동 내역이 없다는 뷰 띄우기
    private func showNoneMyActivityView() {
        self.existMyActivityView.removeFromSuperview()
        self.myActivityContainerView.addSubview(self.noneMyActivityView)
        self.noneMyActivityView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // 진행한 활동 내역 띄우기
    private func showExistMyActivityView() {
        self.noneMyActivityView.removeFromSuperview()
        
        self.myActivityContainerView.addSubview(self.existMyActivityView)
        self.existMyActivityView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        self.existMyActivityView.addSubview(self.myActivityCollectionView)
        self.myActivityCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapMyInfoView() {
        let profileCardVC = ProfileCardViewController()
        profileCardVC.modalPresentationStyle = .overFullScreen
        profileCardVC.modalTransitionStyle = .crossDissolve
        self.present(profileCardVC, animated: true)
    }
    
    // 나의 활동 목록 화면으로 이동
    @objc
    private func tapMyActivityArrowButton() {
        let activityListVC = ActivityListViewController()
        activityListVC.modalPresentationStyle = .overFullScreen
        activityListVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(activityListVC, animated: true)
    }
    
    @objc
    private func tapEditMyInfoButton() {
        let editMyInfoVC = EditMyInfoViewController()
        self.navigationController?.pushViewController(editMyInfoVC, animated: true)
    }
    
    @objc
    private func tapcustomerServiceButton() {
        let customerServiceVC = CustomerServiceViewController()
        self.navigationController?.pushViewController(customerServiceVC, animated: true)
    }
    
    @objc
    private func tapLogoutButton() {
        createBlurView()
        view.addSubview(logoutView)
        logoutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(256)
            make.height.equalTo(236)
        }
    }
    
    @objc
    private func tapWithdrawalMembershipButton() {
        createBlurView()
        view.addSubview(withdrawalMembershipView)
        withdrawalMembershipView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(256)
            make.height.equalTo(236)
        }
    }
    
    @objc
    private func tapXButton() {
        visualEffectView?.removeFromSuperview()
        logoutView.removeFromSuperview()
        withdrawalMembershipView.removeFromSuperview()
    }
    
    @objc
    private func tapLogoutConfirmButton() {
        MyLoadingView.shared.show()
        
        UserDefaults.standard.set("nil", forKey: "jwt") // delete local jwt
        naverLoginVM.resetToken() // delete naver login token
        
        LoginAPI.logout { isSuccess in
            MyLoadingView.shared.hide()
            
            if isSuccess {
                print("DEBUG: 로그아웃 완료")
                
                let rootVC = LoginViewController()
                UIApplication.shared.windows.first?.rootViewController = rootVC
                self.view.window?.rootViewController?.dismiss(animated: true)
                
                // 로그인 VC에 토스트 메세지 띄우기
                NotificationCenter.default.post(name: NSNotification.Name("CompleteLogout"), object: nil)
            }
        }
    }
    
    @objc
    private func tapWithdrawalMembershipConfirmButton() {
        MyLoadingView.shared.show()
        
        let input = MemberDeleteInput(checkPassword: "apple123!", password: "apple123!")
        UserInfoAPI.deleteMember(input, memberId: LoginModel.memberId!) { isSuccess in
            MyLoadingView.shared.hide()
            
            if isSuccess {
                print("DEBUG: 회원 탈퇴 완료")
                
                let rootVC = LoginViewController()
                UIApplication.shared.windows.first?.rootViewController = rootVC
                self.view.window?.rootViewController?.dismiss(animated: true)
                
                // 로그인 VC에 토스트 메세지 띄우기
                NotificationCenter.default.post(name: NSNotification.Name("CompleteWithdrawal"), object: nil)
            } else {
                print("회원 탈퇴 실패")
            }
        }
    }
    
    @objc
    private func showUserStageView() {
        let userStageVC = UserStageViewController()
        self.navigationController?.pushViewController(userStageVC, animated: true)
    }
    
    // 비밀번호 변경을 완료했을 때 토스트 메세지 띄우기
    @objc
    private func completeChangingPw(_ notification: Notification) {
        self.showToast(viewController: self, message: "비밀번호를 변경하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 225)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.myActivities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyActivityCollectionViewCell.identifier, for: indexPath) as? MyActivityCollectionViewCell else { return UICollectionViewCell() }
        
        cell.titleLabel.text = myActivities[indexPath.row].title
        cell.updatedAtLabel.text = updatedAt[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedPartyId = myActivities[indexPath.row].id else { return }
        
        let partyVC = PartyViewController(partyId: selectedPartyId, isEnded: true)
        self.navigationController?.pushViewController(partyVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

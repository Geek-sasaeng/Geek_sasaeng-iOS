//
//  PartyVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

class PartyViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    // TODO: - 파티 상세보기 API로부터 데이터 가져와야 함 일단은 임시 데이터
    // 배달 예정 시간까지 남은 초(Seconds) 데이터
    var currentSeconds: Int? = 10000

    // 남은 시간 1초마다 구해줄 타이머
    var timer: DispatchSourceTimer?
    
    // MARK: - Subviews
    
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
    
    // 외부 참조가 필요해서 이 버튼만 밖에 빼놓음!
    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("신고하기", for: .normal)
        // TODO: - 신고하기 뷰 연결 필요
//        button.addTarget(self, action: #selector(showReportView), for: .touchUpInside)
        return button
    }()
    
    /* 오른쪽 상단의 옵션 탭 눌렀을 때 나오는 옵션 뷰 */
    lazy var optionView: UIView = {
        // 등장 애니메이션을 위해 뷰의 생성 때부터 원점과 크기를 정해놓음
        let view = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.height - 563)))
        view.backgroundColor = .white
        
        // 왼쪽 하단의 코너에만 cornerRadius를 적용
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        /* 옵션뷰에 있는 ellipsis 버튼
         -> 원래 있는 버튼을 안 가리게 & 블러뷰에 해당 안 되게 할 수가 없어서 옵션뷰 위에 따로 추가함 */
        lazy var ellipsisButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "EllipsisOption"), for: .normal)
            button.tintColor = .init(hex: 0x2F2F2F)
            // 옵션뷰 나온 상태에서 ellipsis button 누르면 사라지도록
            button.addTarget(self, action: #selector(showPartyPost), for: .touchUpInside)
            return button
        }()
        view.addSubview(ellipsisButton)
        ellipsisButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(23)
        }
        
        /* 옵션뷰에 있는 버튼 */
        var editButton: UIButton = {
            let button = UIButton()
            button.setTitle("수정하기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            // TODO: - 수정하기 뷰 연결 필요
            button.addTarget(self, action: #selector(showEditView), for: .touchUpInside)
            return button
        }()
        var deleteButton: UIButton = {
            let button = UIButton()
            button.setTitle("삭제하기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            // MARK: - 삭제하기 뷰 연결 필요
            button.addTarget(self, action: #selector(showDeleteView), for: .touchUpInside)
            return button
        }()
        
        [editButton, deleteButton, reportButton].forEach {
            // attributes
            $0.setTitleColor(UIColor.init(hex: 0x2F2F2F), for: .normal)
            $0.titleLabel?.font =  .customFont(.neoMedium, size: 18)
            
            // layouts
            view.addSubview($0)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(ellipsisButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    /* 배경 블러 처리를 위해 추가한 visualEffectView */
    var visualEffectView: UIVisualEffectView?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "ProfileImage")
        imageView.layer.cornerRadius = 13
        return imageView
    }()
    
    var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "네오"
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 13)
        return label
    }()
    
    var postingTime: UILabel = {
        let label = UILabel()
        label.text = "05/15 23:57"
        label.font = .customFont(.neoRegular, size: 11)
        label.textColor = .init(hex: 0xD8D8D8)
        return label
    }()
    
    var hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "# 같이 먹고 싶어요"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "중식 같이 먹어요 같이 먹자"
        label.font = .customFont(.neoBold, size: 20)
        label.textColor = .black
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구.어쩌구 저쩌구."
        label.font = .customFont(.neoLight, size: 15)
        label.textColor = .init(hex: 0x5B5B5B)
        label.numberOfLines = 0
        return label
    }()
    
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    var verticalStackView: UIStackView = {
        
        var timeStackView: UIStackView = {
            var orderLabel: UILabel = {
                let label = UILabel()
                label.text = "주문 예정 시간"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var orderReserveDateLabel: UILabel = {
                let label = UILabel()
                label.text = "05월 15일"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var orderReserveTimeLabel: UILabel = {
                let label = UILabel()
                label.text = "23시 00분"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            
            let stackView = UIStackView(arrangedSubviews: [orderLabel, orderReserveDateLabel, orderReserveTimeLabel])
            stackView.spacing = 36
            return stackView
        }()
        
        var matchingStackView: UIStackView = {
            var matchingLabel: UILabel = {
                let label = UILabel()
                label.text = "매칭 현황"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var matchingDataLabel: UILabel = {
                let label = UILabel()
                label.text = "2/4"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            
            let stackView = UIStackView(arrangedSubviews: [matchingLabel, matchingDataLabel])
            stackView.spacing = 63
            return stackView
        }()
        
        var categoryStackView: UIStackView = {
            var categoryLabel: UILabel = {
                let label = UILabel()
                label.text = "카테고리"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var categoryDataLabel: UILabel = {
                let label = UILabel()
                label.text = "중식"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            
            let stackView = UIStackView(arrangedSubviews: [categoryLabel, categoryDataLabel])
            stackView.spacing = 66
            return stackView
        }()
        
        var storeLinkStackView: UIStackView = {
            var storeLinkLabel: UILabel = {
                let label = UILabel()
                label.text = "식당 링크"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var storeLinkDataLabel: UILabel = {
                let label = UILabel()
                label.text = "???"
                label.numberOfLines = 1
                label.lineBreakMode = .byCharWrapping
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            
            let stackView = UIStackView(arrangedSubviews: [storeLinkLabel, storeLinkDataLabel])
            stackView.spacing = 63
            return stackView
        }()
        
        var locationStackView: UIStackView = {
            var pickupLocationLabel: UILabel = {
                let label = UILabel()
                label.text = "수령 장소"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            var pickupLocationDataLabel: UILabel = {
                let label = UILabel()
                label.text = "제1기숙사 후문"
                label.textColor = .init(hex: 0x2F2F2F)
                label.font = .customFont(.neoMedium, size: 13)
                return label
            }()
            
            let stackView = UIStackView(arrangedSubviews: [pickupLocationLabel, pickupLocationDataLabel])
            stackView.spacing = 63
            return stackView
        }()
        
        [
            timeStackView,
            matchingStackView,
            categoryStackView,
            storeLinkStackView,
            locationStackView
        ].forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        /* Vertical StackView */
        let stackView = UIStackView(arrangedSubviews: [
            timeStackView,
            matchingStackView,
            categoryStackView,
            storeLinkStackView,
            locationStackView
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .leading  // vertical stackview의 좌우 정렬 기준!
        stackView.distribution = .fill
        stackView.spacing = 24
        
        return stackView
    }()
    
    var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        return view
    }()
    
    var matchingStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    var matchingDataWhiteLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4 명"
        label.font = UIFont.customFont(.neoMedium, size: 16)
        label.textColor = .white
        return label
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.neoMedium, size: 16)
        label.textColor = .white
        return label
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("신청하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 16)
        return button
    }()
    
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Arrow")
        return imageView
    }()
    
    lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(298)
        }
        
        /* top View: 삭제하기 */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
        }
        
        /* set titleLabel */
        let titleLabel = UILabel()
        titleLabel.text = "삭제하기"
        titleLabel.textColor = UIColor(hex: 0xA8A8A8)
        titleLabel.font = .customFont(.neoRegular, size: 14)
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton()
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = UIColor(hex: 0x5B5B5B)
        cancelButton.titleLabel?.font = .customFont(.neoRegular, size: 15)
        cancelButton.addTarget(self, action: #selector(removeDeleteView), for: .touchUpInside)
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = UIColor.white
        view.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(206)
            make.top.equalTo(topSubView.snp.bottom)
        }
        
        let contentLabel = UILabel()
        let lineView = UIView()
        lazy var confirmButton = UIButton()
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set contentLabel */
        contentLabel.text = "파티글 삭제하기를 누를 시\n해당 글을 영구적으로\n지워집니다.\n삭제하시겠습니까?"
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .customFont(.neoRegular, size: 14)
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(193)
            make.height.equalTo(144)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        /* set lineView */
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.width.equalTo(230)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        /* set confirmButton */
        confirmButton.setTitleColor(.mainColor, for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .customFont(.neoRegular, size: 18)
        confirmButton.addTarget(self, action: #selector(removeDeleteView), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        return view
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setAttributes()
        startTimer()
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.scrollView.addSubview(matchingStatusView)
        
        [
            profileImageView,
            nickNameLabel,
            postingTime,
            hashTagLabel,
            titleLabel,
            contentLabel,
            separateView,
            verticalStackView,
            mapView
        ].forEach { contentView.addSubview($0) }
        [
            matchingDataWhiteLabel,
            remainTimeLabel,
            signUpButton,
            arrowImageView
        ].forEach { matchingStatusView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(23)
            make.width.height.equalTo(26)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        postingTime.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel.snp.right).offset(15)
            make.centerY.equalTo(nickNameLabel.snp.centerY)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(hashTagLabel.snp.bottom).offset(9)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.right.equalToSuperview().inset(23)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(34)
            make.height.equalTo(8)
            make.width.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(28)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(122)
        }
        
        matchingStatusView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(170)
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        matchingDataWhiteLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(29)
            make.centerY.equalTo(matchingStatusView.snp.centerY)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(matchingDataWhiteLabel.snp.right).offset(45)
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-11)
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(matchingDataWhiteLabel.snp.centerY)
            make.right.equalToSuperview().inset(29)
        }
        
    }
    
    private func setAttributes() {
        
        mapView.layer.cornerRadius = 5
        
        /* Navigation Bar Attrs */
        self.navigationItem.title = "파티 보기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // rightBarButton을 옵션 버튼으로 설정
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "EllipsisOption"), style: .plain, target: self, action: #selector(showOptionView)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
        // rightBarButtonItem의 default 위치에다가 inset을 줘서 위치를 맞춤
        navigationItem.rightBarButtonItem?.imageInsets = .init(top: -3, left: 0, bottom: 0, right: 20)
    }
    
    /* Ellipsis Button을 눌렀을 때 동작하는, 옵션뷰를 나타나게 하는 함수 */
    @objc private func showOptionView() {
        // 네비게이션 바보다 앞쪽에 위치하도록 설정
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(optionView)
        print("DEBUG: 옵션뷰의 위치", optionView.frame)
        
        // 레이아웃 설정
        optionView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().inset(150)
            make.bottom.equalTo(reportButton.snp.bottom).offset(25)
        }
        
        // 오른쪽 위에서부터 대각선 아래로 내려오는 애니메이션을 설정
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseOut,
            animations: { () -> Void in
                self.optionView.center.y += self.optionView.bounds.height
                self.optionView.center.x -= self.optionView.bounds.width
                self.optionView.layoutIfNeeded()
            },
            completion: nil
        )

        // 배경을 흐리게, 블러뷰로 설정
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
    }
    
    /* 옵션뷰가 나타난 후에, 배경의 블러뷰를 터치하면 옵션뷰와 블러뷰가 같이 사라지도록 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        showPartyPost()
        
        deleteView.removeFromSuperview()
    }
    
    // TODO: - 신청하기 View 탭바에 달라붙도록 구현해야 함............ 자료가 진짜 없다
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    /* 남은 시간 변경해줄 타이머 작동 */
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            
            if let currentSeconds = self.currentSeconds {
                // 1초마다 감소
                self.currentSeconds! -= 1
                
                // 초를 시간, 분, 초 단위로 변경
                let hourTime = currentSeconds / 60 / 60
                let minuteTime = currentSeconds / 60 % 60
                let secondTime = currentSeconds % 60
                
                // 텍스트 변경
                self.remainTimeLabel.text = "\(hourTime):\(minuteTime):\(secondTime)"
                
                if currentSeconds <= 0 {
                    // TODO: - 남은 시간 지나면?
                    self.timer?.cancel()
                }
            }
        })
        timer?.resume()
    }
    
    /* 이전 화면으로 돌아가기 */
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 파티 보기 화면으로 돌아가기 */
    @objc func showPartyPost() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseOut,
            animations: { () -> Void in
                // 사라질 때 자연스럽게 옵션뷰, 블러뷰에 애니메이션 적용
                self.optionView.center.y -= self.optionView.bounds.height
                self.optionView.center.x += self.optionView.bounds.width
                self.optionView.layoutIfNeeded()
                self.visualEffectView?.layer.opacity -= 0.6
            },
            completion: { _ in ()
                self.optionView.removeFromSuperview()
                self.visualEffectView?.removeFromSuperview()
            }
        )
    }
    
    @objc func showEditView() {
        optionView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
        
        let editPartyVC = EditPartyViewController()
        navigationController?.pushViewController(editPartyVC, animated: true)
    }
    
    @objc func showDeleteView() {
        optionView.removeFromSuperview()
        
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    @objc func removeDeleteView() {
        deleteView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
    }
}

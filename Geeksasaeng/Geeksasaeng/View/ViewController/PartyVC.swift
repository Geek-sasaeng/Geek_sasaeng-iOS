//
//  PartyVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//

import UIKit
import SnapKit

class PartyViewController: UIViewController {
    
    // MARK: - Subviews
    
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
    //        button.addTarget(self, action: #selector(showEditView), for: .touchUpInside)
            return button
        }()
        var deleteButton: UIButton = {
            let button = UIButton()
            button.setTitle("삭제하기", for: .normal)
            button.makeBottomLine(color: 0xEFEFEF, width: view.bounds.width - 40, height: 1, offsetToTop: 13)
            // MARK: - 삭제하기 뷰 연결 필요
    //        button.addTarget(self, action: #selector(showDeleteView), for: .touchUpInside)
            return button
        }()
        var reportButton: UIButton = {
            let button = UIButton()
            button.setTitle("신고하기", for: .normal)
            // MARK: - 신고하기 뷰 연결 필요
    //        button.addTarget(self, action: #selector(showReportView), for: .touchUpInside)
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
            return stackView
        }()
        
        [
            timeStackView,
            matchingStackView,
            categoryStackView,
            locationStackView
        ].forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 20
        }
        
        /* Vertical StackView */
        let stackView = UIStackView(arrangedSubviews: [
            timeStackView,
            matchingStackView,
            categoryStackView,
            locationStackView
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
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
    
    var peopleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "People")
        return imageView
    }()
    
    var matchingDataWhiteLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.textColor = .white
        return label
    }()
    
    var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
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
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayouts()
        setAttributes()
    }
    
    // MARK: - Functions
    
    private func setLayouts() {
        [
            profileImageView,
            nickNameLabel,
            postingTime,
            hashTagLabel,
            titleLabel,
            contentLabel,
            separateView,
            matchingStatusView,
            peopleImage,
            verticalStackView,
            mapView,
            matchingDataWhiteLabel,
            remainTimeLabel,
            signUpButton,
            arrowImageView
        ].forEach { self.view.addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(105)
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
            make.top.equalTo(verticalStackView.snp.bottom).offset(13)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(122)
        }
        
        matchingStatusView.snp.makeConstraints { make in
            let constant = tabBarController?.tabBar.frame.size.height
            make.bottom.equalToSuperview().inset(constant!)
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        peopleImage.snp.makeConstraints { make in
            make.centerY.equalTo(matchingStatusView.snp.centerY)
            make.left.equalToSuperview().inset(29)
        }
        
        matchingDataWhiteLabel.snp.makeConstraints { make in
            make.left.equalTo(peopleImage.snp.right).offset(12)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        remainTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(matchingDataWhiteLabel.snp.right).offset(33)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            make.left.equalTo(remainTimeLabel.snp.right).offset(62)
            make.centerY.equalTo(peopleImage.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { make in
            make.left.equalTo(signUpButton.snp.right).offset(11)
            make.centerY.equalTo(peopleImage.snp.centerY)
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
            make.bottom.equalToSuperview().inset(563)
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
}

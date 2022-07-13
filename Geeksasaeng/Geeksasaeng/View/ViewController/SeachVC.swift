//
//  SeachVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import UIKit
import SnapKit

class SeachViewController: UIViewController {
    
    // MARK: - Properties
    // TODO: - 추후에 서버에서 가져온 값으로 변경해야 함
    var recentSearchDataArray = ["중식", "한식", "이야기", "이야기", "이야기",
                                 "중식", "한식", "이야기", "이야기", "이야기"]
    var weeklyTopDataArray = ["치킨", "마라샹궈", "마라탕", "탕수육", "피자",
                              "족발", "빵", "냉면", "커피", "떡볶이"]
    
    // MARK: - Subviews
    
    /* 검색창 textField */
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .init(hex: 0x2F2F2F)
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEFEFEF),
                NSAttributedString.Key.font: UIFont.customFont(.neoMedium, size: 20)
            ]
        )
        textField.makeBottomLine(323)
        return textField
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .init(hex: 0x2F2F2F)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    var recentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        return label
    }()
    
    var dormitoryWeeklyTopLabel: UILabel = {
        let label = UILabel()
        // TODO: - 추후에 기숙사 정보 받아와서 넣기
        label.text = "제1기숙사 Weekly TOP 10"
        return label
    }()
    
    var tagGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 태그는 어때요?"
        return label
    }()
    
    /* 최근 검색어 기록 Collection View */
    var recentSearchCollectionView: UICollectionView = {
        // 레이아웃 설정
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // 셀 사이 좌우 간격 설정
        layout.minimumInteritemSpacing = 20
        
        // 컬렉션뷰 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.tag = 1
        
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    /* Weekly Top 10 Collection View */
    var weeklyTopCollectionView: UICollectionView = {
        // 레이아웃 설정
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // 셀 사이 좌우 간격 설정
        layout.minimumLineSpacing = 70
        layout.minimumInteritemSpacing = 4
        
        // 컬렉션뷰 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.tag = 2
        
        // indicator 숨김
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    /* 구분선 View */
    var firstSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    var secondSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    /* 배경에 있는 로고 이미지 */
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: - svg 파일로 하니까 색이 너무너무 연하다... 네오한테 말 해봐야 될 듯
        imageView.image = UIImage(named: "SearchBackLogo")
        return imageView
    }()
    
    /* 해시태그 예시 View */
    lazy var hashTagEx1View = createHashTagView(text: "#같이 먹고 싶어요")
    lazy var hashTagEx2View = createHashTagView(text: "#따로 또 같이")
    lazy var hashTagEx3View = createHashTagView(text: "#음식에 진심인 사람들과 함께 해요")
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [recentSearchLabel, dormitoryWeeklyTopLabel, tagGuideLabel].forEach {
            setMainTextAttributes($0)
        }
        setLayouts()
        setCollectionView(recentSearchCollectionView)
        setCollectionView(weeklyTopCollectionView)
    }
    
    // MARK: - Functions
    
    /* 공통 속성 설정 */
    private func setMainTextAttributes(_ label: UILabel) {
        label.textColor = .init(hex: 0x2F2F2F)
        label.font = .customFont(.neoMedium, size: 18)
    }
    
    private func setLayouts() {
        [
            searchTextField,
            searchButton,
            recentSearchLabel, dormitoryWeeklyTopLabel, tagGuideLabel,
            recentSearchCollectionView,
            weeklyTopCollectionView,
            firstSeparateView, secondSeparateView,
            hashTagEx1View, hashTagEx2View, hashTagEx3View,
            logoImageView
        ].forEach { view.addSubview($0) }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(53)
            make.left.equalToSuperview().inset(30)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.right.equalToSuperview().inset(33)
            make.width.height.equalTo(24)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(122)
        }
        dormitoryWeeklyTopLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(firstSeparateView.snp.bottom).offset(21)
        }
        tagGuideLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(secondSeparateView.snp.bottom).offset(22)
        }
        
        recentSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalTo(firstSeparateView.snp.top).offset(-18)
        }
        
        weeklyTopCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dormitoryWeeklyTopLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(70)
            make.bottom.equalTo(secondSeparateView.snp.top).offset(-15)
        }
        
        firstSeparateView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(61)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        secondSeparateView.snp.makeConstraints { make in
            make.top.equalTo(dormitoryWeeklyTopLabel.snp.bottom).offset(187)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        hashTagEx1View.snp.makeConstraints { make in
            make.top.equalTo(tagGuideLabel.snp.bottom).offset(17)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(138)
            make.height.equalTo(34)
        }
        hashTagEx2View.snp.makeConstraints { make in
            make.centerY.equalTo(hashTagEx1View)
            make.left.equalTo(hashTagEx1View.snp.right).offset(19)
            make.width.equalTo(111)
            make.height.equalTo(34)
        }
        hashTagEx3View.snp.makeConstraints { make in
            make.top.equalTo(hashTagEx1View.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(242)
            make.height.equalTo(34)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(143)
            make.top.equalTo(hashTagEx3View.snp.bottom).offset(30)
        }
    }
    
    /* collection view 등록 */
    private func setCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        
        if collectionView.tag == 1 {
            collectionView.register(RecentSearchCollectionViewCell.self,
                                      forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        } else {
            collectionView.register(WeeklyTopCollectionViewCell.self,
                                      forCellWithReuseIdentifier: WeeklyTopCollectionViewCell.identifier)
        }
    }
    
    /* 해시태그 예시 뷰들 생성 */
    // TODO: - 태그가 피그마처럼 고정적으로 3개인 건가? 아니라면 구조 바꿔야 할 듯
    private func createHashTagView(text: String) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .init(hex: 0xF8F8F8)
        
        let label = UILabel()
        label.text = text
        label.textColor = .mainColor
        label.font = .customFont(.neoMedium, size: 14)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        return view
    }
    
    // 이전 화면으로 돌아가기
//    @objc func back(sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
//    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SeachViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // cell 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return recentSearchDataArray.count
        } else {
            return weeklyTopDataArray.count
        }
    }
    
    // cell 내용 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            // RecentSearchCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 텍스트(검색어 기록) 설정
            cell.recentSearchLabel.text = recentSearchDataArray[indexPath.item]
            return cell
        } else {
            // WeeklyTopCollectionViewCell 타입의 cell 생성
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyTopCollectionViewCell.identifier, for: indexPath) as? WeeklyTopCollectionViewCell else {
                return UICollectionViewCell() }
            
            // cell의 텍스트(검색어 순위, 검색어) 설정
            cell.rankLabel.text = String(indexPath.item + 1)
            cell.searchLabel.text = weeklyTopDataArray[indexPath.item]
            return cell
        }
    }
    
    // 각 cell의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: recentSearchDataArray[indexPath.item].size(withAttributes: nil).width + 25, height: 28)
        } else {
            return CGSize(width: 75, height: 28)
        }
    }
}

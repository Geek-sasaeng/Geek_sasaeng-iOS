//
//  ActivityListVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/17.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class ActivityListViewController: UIViewController {
    
    // MARK: - Properties
    
    // 현재 선택되어 있는 필터의 label
    private var selectedLabel: UILabel? = nil {
        didSet {
            if selectedLabel?.text != "배달파티" {
                showReadyView()
            }
        }
    }
    // 나의 활동 목록의 마지막 페이지인지 여부 확인
    var isFinalPage = false
    // 목록에서 현재 커서 위치
    var cursor = 0
    // 나의 활동 목록 데이터가 저장되는 배열
    var activityList: [EndedDeliveryPartyList] = []
    
    // MARK: - Subviews
    
    let mainTitleLabel = UILabel().then {
        $0.text = "내가 만들었던 활동들을 한 눈에 확인해보세요"
        $0.numberOfLines = 0
        $0.font = .customFont(.neoMedium, size: 24)
        $0.textColor = .black
    }
    
    /* Filter Icon */
    let filterImageView = UIImageView(image: UIImage(named: "FilterImage")).then {
        $0.tintColor = UIColor(hex: 0x2F2F2F)
    }
    
    /* Category Filter */
    /* 필터뷰들을 묶어놓는 스택뷰 */
    let filterStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .horizontal
        $0.alignment = .top
        $0.distribution = .equalSpacing
    }
    
    /* Table View */
    let activityTableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    // 준비 중입니다 화면
    let readyView = UIView().then {
        $0.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "ReadyImage"))
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(143)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        setFilterStackView(filterNameArray: ["배달파티", "심부름", "거래"],
                           width: [80, 67, 54],
                           stackView: filterStackView)
        addSubViews()
        setLayouts()
        setTableView()
        setLabelTap()
        
        /* 나의 활동 목록 데이터 로딩 */
        getActivityList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // 하단 탭바를 숨긴다
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 하단 탭바가 나타나게 해야한다
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "나의 활동 보기"
        
        // label 행간 설정
        let attrString = NSMutableAttributedString(string: mainTitleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        mainTitleLabel.attributedText = attrString
        
        // 테이블뷰 attrs
        activityTableView.backgroundColor = .white
        activityTableView.rowHeight = 81 + 6 + 6
        activityTableView.separatorStyle = .none
        activityTableView.showsVerticalScrollIndicator = false
    }
    
    private func addSubViews() {
        [
            mainTitleLabel,
            filterImageView,
            filterStackView,
            activityTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        /* Category Tap */
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(232)
        }
        
        /* Category Filter */
        filterImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(36)
            make.width.equalTo(23)
            make.height.equalTo(15)
        }
        filterStackView.snp.makeConstraints { make in
            make.left.equalTo(filterImageView.snp.right).offset(17)
            make.centerY.equalTo(filterImageView)
            make.width.equalTo(80 + 67 + 54 + 18)
        }
        
        /* TableView */
        activityTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(filterImageView.snp.bottom).offset(36)
        }
    }
    
    private func setTableView() {
        activityTableView.dataSource = self
        activityTableView.delegate = self
        activityTableView.register(MyActivityListTableViewCell.self, forCellReuseIdentifier: MyActivityListTableViewCell.identifier)
        
        activityTableView.rowHeight = 85 + 12 + 12
    }
    
    /* 배열에 담긴 이름으로 Filter Views를 만들고 스택뷰로 묶는다 */
    private func setFilterStackView(filterNameArray: [String], width: [CGFloat], stackView: UIStackView) {
        for i in 0..<filterNameArray.count {
            let filterText = filterNameArray[i]
            let filterView = UIView().then {
                $0.backgroundColor = .init(hex: 0xF8F8F8)
                $0.layer.cornerRadius = 5
                $0.snp.makeConstraints { make in
                    make.width.equalTo(width[i])
                    make.height.equalTo(35)
                }
                
                let label = UILabel().then {
                    $0.text = filterText
                    $0.font = .customFont(.neoMedium, size: 14)
                }
                if filterText == "배달파티" {
                    // default로 배달파티 필터가 활성화 되어 있도록 설정
                    label.textColor = .mainColor
                    selectedLabel = label
                } else {
                    label.textColor = UIColor(hex: 0xD8D8D8)
                }
                $0.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
            }
            
            // Stack View에 추가
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
    
    /* 나의 활동 목록 정보 API로 불러오기 */
    private func getActivityList() {
        // 푸터뷰(= 데이터 받아올 때 테이블뷰 맨 아래 새로고침 표시 뜨는 거) 생성
        self.activityTableView.tableFooterView = createSpinnerFooter()
        
        /* 나의 활동 목록 불러오기 API 요청 */
        UserInfoAPI.getMyActivityList(cursor: cursor) { [weak self] isSuccess, result in
            if isSuccess {
                guard let result = result,
                      let data = result.endedDeliveryPartiesVoList,
                      let isFinalPage = result.finalPage else { return }
                print("DEBUG: 마지막 페이지인가?", isFinalPage)
                
                // 마지막 페이지인지 아닌지 전달
                self!.isFinalPage = isFinalPage
                // 활동 데이터 추가
                self!.addActivityData(result: data)
            } else {
                self!.showToast(viewController: self!, message: "나의 활동을 불러오는 데 실패했어요",
                          font: .customFont(.neoBold, size: 13), color: .mainColor)
            }
        }
    }
    
    /* 서버로부터 받아온 response를 처리하는 함수. res가 성공이면 셀에 데이터를 추가해준다 */
    private func addActivityData(result: [EndedDeliveryPartyList]) {
        result.forEach {
            // 데이터를 배열에 추가
            self.activityList.append($0)
            print("DEBUG: 받아온 나의 활동 데이터", $0)
        }
        
        DispatchQueue.main.async {
            // 데이터 로딩 표시 제거
            self.activityTableView.tableFooterView = nil
            // 테이블뷰 리로드
            self.activityTableView.reloadData()
        }
    }
    
    /* 무한 스크롤로 마지막 데이터까지 가면 나오는(= FooterView) 데이터 로딩 표시 생성 */
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        spinner.color = .mainColor
        
        return footerView
    }
    
    /* 테이블뷰 셀의 마지막 데이터까지 스크롤 했을 때 이를 감지해주는 함수 */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 데이터가 존재할 때, 마지막 페이지가 아닐 때에만 실행
        if activityList.count != 0 && !isFinalPage {
            let position = scrollView.contentOffset.y
            print("pos", position)
            
            // 현재 화면에 테이블뷰 셀이 몇개까지 들어가는지
            let maxCellNum = activityTableView.bounds.size.height / activityTableView.rowHeight
            // '몇 번째 셀'이 위로 사라질 때 다음 데이터를 불러올지
            let boundCellNum = 10 - maxCellNum
            
            // 마지막 데이터에 도달했을 때 다음 데이터 10개를 불러온다
            if position > ((activityTableView.rowHeight) * (boundCellNum + (10 * CGFloat(cursor)))) {
                // 다음 커서의 나의 활동을 불러온다
                cursor += 1
                print("DEBUG: cursor", cursor)
                // 나의 활동 목록 API 호출
                getActivityList()
            }
        }
    }
    
    private func showReadyView() {
        view.addSubview(readyView)
        readyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(filterImageView.snp.bottom).offset(36)
        }
    }
    
    private func removeReadyView() {
        readyView.removeFromSuperview()
    }
    
    // MARK: - @objc Functions
    
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
                // 이전에 선택돼있던 게 심부름/거래 였으면 준비 중입니다 뷰 삭제
                if selectedLabel?.text != "배달파티" {
                    removeReadyView()
                }
            }
            label.textColor = .mainColor
            selectedLabel = label
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension ActivityListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyActivityListTableViewCell.identifier, for: indexPath) as? MyActivityListTableViewCell else { return UITableViewCell() }
        
        // 현재 row의 셀 데이터
        let nowData = activityList[indexPath.row]
        let date = FormatCreater.sharedLongFormat.date(from: nowData.updatedAt!)
        
        cell.partyTitleLabel.text = nowData.title
        cell.peopleLabel.text = "\(nowData.maxMatching ?? 0)"
        cell.foodCategoryLabel.text = nowData.foodCategory
        
        // 뒤에 시간 자르기
        let endIdx = nowData.updatedAt!.index(nowData.updatedAt!.startIndex, offsetBy: 9)
        // -를 .으로 바꾸기
        cell.dateLabel.text = String(nowData.updatedAt![...endIdx]).replacingOccurrences(of: "-", with: ".")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let partyId = activityList[indexPath.row].id else { return }
        // 나의 활동 보기에서 파티 보기로 넘어갈 때에는 종료된 파티를 보는 것이니까 isEnded를 true로 준다.
        let partyVC = PartyViewController(partyId: partyId, isEnded: true)
        self.navigationController?.pushViewController(partyVC, animated: true)
    }
}

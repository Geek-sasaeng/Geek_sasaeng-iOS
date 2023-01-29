//
//  ReportUserViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/10/03.
//

import UIKit

/* 채팅 화면의 사용자 정보 팝업뷰에서 신고하기 버튼 클릭시 뜨는 뷰 */
class ReportUserViewController: UIViewController {
    
    // MARK: - Properties
    
    // 테이블뷰 셀의 label로 들어갈 신고 카테고리 항목들을 정의
    let userReportCategoryData = ["비매너 사용자예요", "욕설을 해요", "성희롱을 해요", "사기를 당했어요", "거래 및 환불 신고", "기타 사유 선택"]
    
    // 신고하기 탭이 눌린 현재 배달파티의 id값
    var partyId: Int?
    // 유저 id값
    var memberId: Int?
    
    // MARK: - Subviews
    
    let userReportLabel = UILabel().then {
        $0.setTextAndColorAndFont(text: "사용자 신고", textColor: .black, font: .customFont(.neoMedium, size: 16))
    }
    
    /* 사용자 신고 카테고리들이 들어갈 테이블뷰 */
    let userReportTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.tag = 2
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setTableView()
        setAttributes()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Initialization
    
    init(partyId: Int, memberId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.partyId = partyId
        self.memberId = memberId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        /* Navigation Bar Attrs */
        self.navigationItem.title = "신고하기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // 테이블뷰 구분선 제거
        userReportTableView.separatorStyle = .none
    }
    
    private func addSubViews() {
        [
            userReportLabel,
            userReportTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        // 사용자 신고
        userReportLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.equalToSuperview().inset(29)
        }
        
        userReportTableView.snp.makeConstraints { make in
            make.top.equalTo(userReportLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(29)
            make.height.equalTo(userReportTableView.rowHeight * CGFloat(userReportCategoryData.count))
        }
    }
    
    /* 테이블뷰 세팅 */
    private func setTableView() {
        userReportTableView.delegate = self
        userReportTableView.dataSource = self
        userReportTableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.identifier)
        
        // 테이블뷰 셀 높이 설정
        userReportTableView.rowHeight = 41   // 11 + 11 + 19
    }
    
    // MARK: - @objc Functions
    
    /* 기타 사유 선택 카테고리가 아닌 화살표를 눌렀을 때 실행되는 함수 */
    @objc
    private func tapReportArrowButton(_ sender: UIButton) {
        // 태그 번호에 따라 파티 게시글 신고 화살표인지, 사용자 신고의 화살표인지 확인
        var passedText: String?
        passedText = userReportCategoryData[sender.tag]
        
        // 신고하기 카테고리 label text값과 id값, 파티 id값, 유저 id값 전달
        let reportDetailVC = ReportDetailViewController(
            labelText: passedText!,
            reportCategoryId: sender.tag + 1,
            partyId: partyId,
            memberId: memberId)
        
        self.navigationController?.pushViewController(reportDetailVC, animated: true)
    }
    
    /* 기타 사유 선택 카테고리 화살표를 눌렀을 때 실행되는 함수 */
    @objc
    private func tapReportEtcArrowButton(_ sender: UIButton) {
        // 신고하기 카테고리 id값, 파티 id값, 유저 id값 전달
        let reportDetailEtcVC = ReportDetailEtcViewController(reportCategoryId: sender.tag + 1, partyId: partyId, memberId: memberId)
        
        self.navigationController?.pushViewController(reportDetailEtcVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ReportUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    /* 셀 갯수 설정 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReportCategoryData.count
    }
    
    /* 셀 내용 구성 -> 두 테이블을 구분해서 매치되는 배열의 데이터를 label text로 지정 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        
        cell.reportCategoryLabel.text = userReportCategoryData[indexPath.row]
        cell.arrowButton.tag = indexPath.row
        
        // target 연결
        if indexPath.row == userReportCategoryData.count - 1 {
            // 기타 사유 선택
            cell.arrowButton.addTarget(self, action: #selector(tapReportEtcArrowButton), for: .touchUpInside)
        } else {
            cell.arrowButton.addTarget(self, action: #selector(tapReportArrowButton), for: .touchUpInside)
        }
        return cell
    }
}

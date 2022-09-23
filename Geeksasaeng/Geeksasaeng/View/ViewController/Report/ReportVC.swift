//
//  ReportViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/21.
//

import UIKit
import SnapKit

class ReportViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    // 테이블뷰 셀의 label로 들어갈 신고 카테고리 항목들을 정의
    let postReportCategoryData = ["광고 같아요", "사기가 의심돼요", "배달 정보가 부정확해요", "기타 사유 선택"]
    let userReportCategoryData = ["비매너 사용자예요", "욕설을 해요", "성희롱을 해요", "사기를 당했어요", "거래 및 환불 신고", "기타 사유 선택"]
    
    // 신고하기 탭이 눌린 현재 배달파티의 id값
    var partyId: Int?
    // 유저 id값
    var memberId: Int?
    
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
    
    let postReportLabel: UILabel = {
        let label = UILabel()
        label.setTextAndColorAndFont(text: "파티 게시글 신고", textColor: .black, font: .customFont(.neoMedium, size: 16))
        return label
    }()
    let userReportLabel: UILabel = {
        let label = UILabel()
        label.setTextAndColorAndFont(text: "사용자 신고", textColor: .black, font: .customFont(.neoMedium, size: 16))
        return label
    }()
    
    /* 파티 게시글 신고 카테고리들이 들어갈 테이블뷰 */
    let postReportTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.tag = 1
        return tableView
    }()
    
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    /* 사용자 신고 카테고리들이 들어갈 테이블뷰 */
    let userReportTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.tag = 2
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        
        [postReportTableView,
         userReportTableView].forEach { setTableView($0) }
        setAttributes()
        addSubViews()
        setLayouts()
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
        postReportTableView.separatorStyle = .none
        userReportTableView.separatorStyle = .none
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            postReportLabel,
            postReportTableView,
            separateView,
            userReportLabel,
            userReportTableView
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.right.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        // 스크롤뷰 안에 들어갈 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        // 파티 게시글 신고
        postReportLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(29)
            make.top.equalToSuperview()
        }
        
        postReportTableView.snp.makeConstraints { make in
            make.top.equalTo(postReportLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(29)
            print(postReportTableView.rowHeight)
            make.height.equalTo(postReportTableView.rowHeight * CGFloat(postReportCategoryData.count))
        }
        
        // 구분선 뷰
        separateView.snp.makeConstraints { make in
            make.top.equalTo(postReportTableView.snp.bottom).offset(40)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        // 사용자 신고
        userReportLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(51)
            make.left.equalToSuperview().inset(29)
        }
        
        userReportTableView.snp.makeConstraints { make in
            make.top.equalTo(userReportLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(29)
            make.height.equalTo(userReportTableView.rowHeight * CGFloat(userReportCategoryData.count))
        }
    }
    
    /* 테이블뷰 세팅 */
    private func setTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.identifier)
        
        // 테이블뷰 셀 높이 설정
        tableView.rowHeight = 41   // 11 + 11 + 19
    }
    
    // MARK: - @objc Functions
    
     /* 이전 화면으로 돌아가기 */
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 기타 사유 선택 카테고리가 아닌 화살표를 눌렀을 때 실행되는 함수 */
    @objc
    private func tapReportArrowButton(_ sender: UIButton) {
        // 태그 번호에 따라 파티 게시글 신고 화살표인지, 사용자 신고의 화살표인지 확인
        var passedText: String?
        if sender.tag < 4 {
            passedText = postReportCategoryData[sender.tag]
        } else {
            passedText = userReportCategoryData[sender.tag - 4]
        }
        
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

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    /* 셀 갯수 설정 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return postReportCategoryData.count
        } else {
            return userReportCategoryData.count
        }
    }
    
    /* 셀 내용 구성 -> 두 테이블을 구분해서 매치되는 배열의 데이터를 label text로 지정 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        
        if tableView.tag == 1 {
            cell.reportCategoryLabel.text = postReportCategoryData[indexPath.row]
            cell.arrowButton.tag = indexPath.row
            
            // target 연결
            if indexPath.row == postReportCategoryData.count - 1 {
                // 기타 사유 선택
                cell.arrowButton.addTarget(self, action: #selector(tapReportEtcArrowButton), for: .touchUpInside)
            } else {
                cell.arrowButton.addTarget(self, action: #selector(tapReportArrowButton), for: .touchUpInside)
            }
            return cell
        } else {
            cell.reportCategoryLabel.text = userReportCategoryData[indexPath.row]
            cell.arrowButton.tag = indexPath.row + 4    // 파티 게시글 신고 화살표 태그 번호랑 이어지도록 4부터 시작하게 함.
            
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
}

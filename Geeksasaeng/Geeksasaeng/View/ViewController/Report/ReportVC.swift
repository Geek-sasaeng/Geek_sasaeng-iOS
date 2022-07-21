//
//  ReportViewController.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/21.
//

import UIKit
import SnapKit

class ReportViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    var postReportLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 게시글 신고"
        label.font = .customFont(.neoMedium, size: 16)
        label.textColor = .black
        return label
    }()
    var userReportLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 신고"
        label.font = .customFont(.neoMedium, size: 16)
        label.textColor = .black
        return label
    }()
    
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    var postReportOptionStackView = UIStackView()
    var userReportOptionStackView = UIStackView()
    
    var arrowStackViewOne = UIStackView()
    var arrowStackViewTwo = UIStackView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // 파티 게시글 신고 항목 labels를 스택뷰로 설정
        setVerticalLabelList(["광고 같아요", "사기가 의심돼요", "배달 정보가 부정확해요", "기타 사유 선택"], postReportOptionStackView)
        // 사용자 신고 항목 labels를 스택뷰로 설정
        setVerticalLabelList(["비매너 사용자예요", "욕설을 해요", "성희롱을 해요", "사기를 당했어요", "거래 및 환불 신고", "기타 사유 선택"], userReportOptionStackView)
        
        // 화살표 갯수만큼 스택뷰로 설정
        setArrowStackView(num: 4, stackView: arrowStackViewOne)
        setArrowStackView(num: 6, stackView: arrowStackViewTwo)
        
        // 스택뷰들 속성 설정
        [
            postReportOptionStackView, userReportOptionStackView,
            arrowStackViewOne, arrowStackViewTwo
        ].forEach {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .leading
            $0.spacing = 22
        }
    }
    
    private func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            postReportLabel,
            postReportOptionStackView,
            arrowStackViewOne,
            separateView,
            userReportLabel,
            userReportOptionStackView,
            arrowStackViewTwo
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
        postReportOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(postReportLabel.snp.bottom).offset(41)
            make.left.equalToSuperview().inset(45)
            make.height.equalTo(154)
        }
        arrowStackViewOne.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(46)
            make.top.equalTo(postReportLabel.snp.bottom).offset(41)
            make.height.equalTo(154)
        }
        
        // 구분선 뷰
        separateView.snp.makeConstraints { make in
            make.top.equalTo(postReportOptionStackView.snp.bottom).offset(51)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        // 사용자 신고
        userReportLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(51)
            make.left.equalToSuperview().inset(29)
        }
        userReportOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(userReportLabel.snp.bottom).offset(41)
            make.left.equalToSuperview().inset(45)
            make.height.equalTo(228)
        }
        arrowStackViewTwo.snp.makeConstraints { make in
            make.top.equalTo(userReportLabel.snp.bottom).offset(41)
            make.right.equalToSuperview().inset(46)
            make.height.equalTo(228)
        }
    }
    
    /* 여러 개의 label을 Vertical Label list로 구성한다 */
    private func setVerticalLabelList(_ strDataArr: [String], _ stackView: UIStackView) {
        for i in 0..<strDataArr.count {
            /* Filter Label */
            let filterLabel = UILabel()
            filterLabel.textColor = .init(hex: 0x636363)
            filterLabel.font = .customFont(.neoMedium, size: 14)
            filterLabel.text = strDataArr[i]
            
            /* Stack View */
            stackView.addArrangedSubview(filterLabel)
        }
    }
    
    /* 화살표 갯수만큼 스택뷰로 구성 */
    private func setArrowStackView(num: Int, stackView: UIStackView) {
        for _ in 0..<num {
            /* Buttons */
            let arrowButton = UIButton()
            arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            arrowButton.tintColor = .init(hex: 0xA8A8A8)
            arrowButton.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0)
            
            /* Stack View */
            stackView.addArrangedSubview(arrowButton)
        }
    }
    
    // MARK: - Objc Functions
    
     /* 이전 화면으로 돌아가기 */
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

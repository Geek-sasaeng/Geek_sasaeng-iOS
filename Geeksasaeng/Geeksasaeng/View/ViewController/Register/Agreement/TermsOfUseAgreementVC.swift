//
//  TermsOfUseAgreementVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/01.
//

import UIKit
import SnapKit

class TermsOfUseAgreementViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var agreementView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    /* 1. 개인정보 처리방침 */
    lazy var processingPolicyTitleLabel = createNeoBoldSixteen(text: "1. 개인정보 처리방침")
    lazy var processingPolicyContentLabel = createNeoRegularFourteen(text: "개인정보 처리방침은 긱사생(이하 \"회사\"라 합니다)이 특정한 가입절차를 거친 이용자들만 이용 가능한 폐쇄형 서비스를 제공함에 있어, 개인정보를 어떻게 수집·이용·보관·파기하는지에 대한 정보를 담은 방침을 의미합니다. 개인정보 처리방침은 개인정보보호법 등 국내 개인정보 보호 법령을 모두 준수하고 있습니다. 본 개인정보 처리방침에서 정하지 않은 용어의 정의는 서비스 이용약관을 따릅니다.")
    lazy var separateViewBetweenOneTwo = createSeparateView()
    
    /* 2. 수집하는 개인정보의 항목 */
    lazy var collectionItemTitleLabel = createNeoBoldSixteen(text: "2. 수집하는 개인정보의 항목")
    lazy var collectionItemContentLabel = createNeoRegularFourteen(text: "회사는 서비스 제공을 위해 다음 항목 중 최소한의 개인정보를 수집합니다.")
    lazy var collectionItemFirstDotLabel = createNeoMediumFifteen(text: "· 회원가입 시 수집되는 개인정보")
    lazy var collectionItemUnderFirstDotLabel = createNeoRegularFourteen(text: "학교, 기숙사, 아이디, 이메일, 이름, 휴대전화 번호, 생년월일, 성별, 입학연도, 닉네임, 연계정보(CI, DI)")
    lazy var collectionItemSecondDotLabel = createNeoMediumFifteen(text: "· 별도로 수집되는 개인정보")
    lazy var collectionItemLabelOne = createNeoMediumFourteen(text: "1. 학교 인증을 한 경우")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    private func addSubViews() {
        [
            processingPolicyTitleLabel, processingPolicyContentLabel, separateViewBetweenOneTwo,
            collectionItemTitleLabel, collectionItemContentLabel, collectionItemFirstDotLabel, collectionItemUnderFirstDotLabel, collectionItemSecondDotLabel, collectionItemLabelOne
        ].forEach {
            contentsView.addSubview($0)
        }
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
        
        view.addSubview(containerView)
        containerView.addSubview(agreementView)
    }
    
    private func setLayouts() {
        containerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        agreementView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        /* 1. 개인정보 처리방침 */
        processingPolicyTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(93)
            make.left.equalToSuperview().inset(23)
        }
        processingPolicyContentLabel.snp.makeConstraints { make in
            make.top.equalTo(processingPolicyTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
            make.right.equalToSuperview().inset(26)
        }
        separateViewBetweenOneTwo.snp.makeConstraints { make in
            make.top.equalTo(processingPolicyContentLabel.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        /* 2. 수집하는 개인정보의 항목 */
        collectionItemTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separateViewBetweenOneTwo.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(23)
        }
        collectionItemContentLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionItemTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
            make.right.equalToSuperview().inset(26)
        }
        collectionItemFirstDotLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionItemContentLabel.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(42)
        }
        collectionItemUnderFirstDotLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionItemFirstDotLabel.snp.bottom).offset(9)
            make.left.equalToSuperview().inset(60)
            make.right.equalToSuperview().inset(26)
        }
        collectionItemSecondDotLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionItemUnderFirstDotLabel.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(42)
        }
        collectionItemLabelOne.snp.makeConstraints { make in
            make.top.equalTo(collectionItemSecondDotLabel.snp.bottom).offset(9)
            make.left.equalToSuperview().inset(66)
        }
        
        
        contentsView.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.height + 100)
        }
        
    }
    
    
    private func createNeoBoldSixteen(text: String) -> UILabel {
        let label = UILabel()
        label.font = .customFont(.neoBold, size: 16)
        label.text = text
        return label
    }
    
    private func createNeoRegularFourteen(text: String) -> UILabel {
        let label = UILabel()
        label.font = .customFont(.neoRegular, size: 14)
        label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }
    
    private func createNeoMediumFifteen(text: String) -> UILabel {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 15)
        label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }
    
    private func createNeoMediumFourteen(text: String) -> UILabel {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 14)
        label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }
    
    private func createSeparateView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF8F8F8)
        return view
    }
}


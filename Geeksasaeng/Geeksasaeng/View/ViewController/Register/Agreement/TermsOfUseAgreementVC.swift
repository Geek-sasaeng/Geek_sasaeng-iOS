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
    lazy var separateViewUnderNumOne = createSeparateView()
    
    /* 2. 수집하는 개인정보의 항목 */
    lazy var collectionItemTitleLabel = createNeoBoldSixteen(text: "2. 수집하는 개인정보의 항목")
    lazy var collectionItemContentLabel = createNeoRegularFourteen(text: "회사는 서비스 제공을 위해 다음 항목 중 최소한의 개인정보를 수집합니다.")
    lazy var collectionItemFirstDotLabel = createNeoMediumFifteen(text: "· 회원가입 시 수집되는 개인정보")
    lazy var collectionItemUnderFirstDotLabel = createNeoRegularFourteen(text: "학교, 기숙사, 아이디, 이메일, 이름, 휴대전화 번호, 생년월일, 성별, 입학연도, 닉네임, 연계정보(CI, DI)")
    lazy var collectionItemSecondDotLabel = createNeoMediumFifteen(text: "· 별도로 수집되는 개인정보")
    lazy var collectionItemLabelOne = createNeoMediumFourteen(text: "1. 학교 인증을 한 경우")
    lazy var collectionItemLabelOne_One = createNeoRegularFourteen(text: "학교 이메일")
    lazy var collectionItemLabelTwo = createNeoMediumFourteen(text: "2. 프로필 사진을 지정할 경우")
    lazy var collectionItemLabelTwo_One = createNeoRegularFourteen(text: "프로필 사진")
    lazy var collectionItemLabelThree = createNeoMediumFourteen(text: "3. 이벤트·행사 참여를 할 경우")
    lazy var collectionItemLabelThree_One = createNeoRegularFourteen(text: "이름, 전화번호, 주소, 타 서비스 고유번호")
    lazy var collectionItemLabelFour = createNeoMediumFourteen(text: "3. 제휴·광고·게시 요청을 할 경우")
    lazy var collectionItemLabelFour_One = createNeoRegularFourteen(text: "단체명, 대표자·담당자 정보(이름, 이메일, 전화번호, 직책)")
    lazy var collectionItemImportantLabel_One = createNeoMediumTwelve(text: "※ 각 항목 또는 추가적으로 수집이 필요한 개인정보 및 개인정보를 포함한 자료는 이용자 응대 과정과 서비스 내부 알림 수단 등을 통해 별도의 동의 절차를 거쳐 요청·수집될 수 있습니다.")
    lazy var collectionItemImportantLabel_Two = createNeoMediumTwelve(text: "※ 서비스 이용 과정에서 기기 정보(유저 에이전트), 이용기록, 로그 기록(IP 주소, 접속 시간)이 자동으로 수집될 수 있습니다.")
    lazy var separateViewUnderNumTwo = createSeparateView()
    
    /* 3. 수집한 개인정보의 처리 목적 */
    lazy var purposeTitleLabel = createNeoBoldSixteen(text: "3. 수집한 개인정보의 처리 목적")
    lazy var purposeContentLabel = createNeoRegularFourteen(text: "수집된 개인정보는 다음의 목적에 한해 이용됩니다.")
    lazy var purposeDot_One = createNeoMediumFourteen(text: "·")
    lazy var purposeDot_Two = createNeoMediumFourteen(text: "·")
    lazy var purposeDot_Three = createNeoMediumFourteen(text: "·")
    lazy var purposeDot_Four = createNeoMediumFourteen(text: "·")
    lazy var purposeDot_Five = createNeoMediumFourteen(text: "·")
    lazy var purposeDotLabel_One = createNeoMediumFifteen(text: "가입 및 탈퇴 의사 확인, 회원 식별, 재학생 확인 등 회원 관리")
    lazy var purposeDotLabel_Two = createNeoMediumFifteen(text: "서비스 제공 및 기존·신규 시스템 개발·유지·개선")
    lazy var purposeDotLabel_Three = createNeoMediumFifteen(text: "불법·약관 위반 게시물 게시 등 부정행위 방지를 위한 운영 시스템 개발·유지·개선")
    lazy var purposeDotLabel_Four = createNeoMediumFifteen(text: "악성 사용자 방지를 위한 운영 시스템 개발·유지·개선")
    lazy var purposeDotLabel_Five = createNeoMediumFifteen(text: "문의·제휴·광고·이벤트·게시 관련 요청응대 및 처리")
    lazy var separateViewUnderNumThree = createSeparateView()
    
    /* 4. 개인정보의 제3자 제공 */
    lazy var provisionTitleLabel = createNeoBoldSixteen(text: "4. 개인정보의 제3자 제공")
    lazy var provisionContentLabel = createNeoRegularFourteen(text: "회사는 회원의 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 사유가 있을 경우 제공할 수 있습니다.")
    lazy var provisionDotLabel_One = createNeoMediumFifteen(text: "· 회원이 제휴사의 서비스를 이용하기 위해 개인정보 제공을 회사에 요청할 경우")
    lazy var provisionDotLabel_Two = createNeoMediumFifteen(text: "· 관련법에 따른 규정에 의한 경우")
    lazy var provisionDotLabel_Three = createNeoMediumFifteen(text: "· 이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우")
    lazy var provisionDotLabel_Four = createNeoMediumFifteen(text: "· 영업의 양수 등")
    lazy var separateViewUnderNumFour = createSeparateView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    private func addSubViews() {
        [
            processingPolicyTitleLabel, processingPolicyContentLabel,
            separateViewUnderNumOne,
            collectionItemTitleLabel, collectionItemContentLabel, collectionItemFirstDotLabel, collectionItemUnderFirstDotLabel, collectionItemSecondDotLabel, collectionItemLabelOne, collectionItemLabelOne_One, collectionItemLabelTwo, collectionItemLabelTwo_One, collectionItemLabelThree, collectionItemLabelThree_One, collectionItemLabelFour, collectionItemLabelFour_One, collectionItemImportantLabel_One, collectionItemImportantLabel_Two,
            separateViewUnderNumTwo,
            purposeTitleLabel, purposeContentLabel, purposeDot_One, purposeDot_Two, purposeDot_Three, purposeDot_Four, purposeDot_Five,
            purposeDotLabel_One, purposeDotLabel_Two, purposeDotLabel_Three, purposeDotLabel_Four, purposeDotLabel_Five,
            separateViewUnderNumThree, provisionTitleLabel, provisionContentLabel, provisionDotLabel_One, provisionDotLabel_Two, provisionDotLabel_Three, provisionDotLabel_Four,
            separateViewUnderNumFour
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
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        contentsView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(separateViewUnderNumThree.snp.bottom).offset(94)
        }
        
        agreementView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
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
        separateViewUnderNumOne.snp.makeConstraints { make in
            make.top.equalTo(processingPolicyContentLabel.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        /* 2. 수집하는 개인정보의 항목 */
        collectionItemTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separateViewUnderNumOne.snp.bottom).offset(31)
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
        collectionItemLabelOne_One.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelOne.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(82)
        }
        collectionItemLabelTwo.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelOne_One.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(66)
        }
        collectionItemLabelTwo_One.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelTwo.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(82)
        }
        collectionItemLabelThree.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelTwo_One.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(66)
        }
        collectionItemLabelThree_One.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelThree.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(82)
        }
        collectionItemImportantLabel_One.snp.makeConstraints { make in
            make.top.equalTo(collectionItemLabelThree_One.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(42)
            make.right.equalToSuperview().inset(26)
        }
        collectionItemImportantLabel_Two.snp.makeConstraints { make in
            make.top.equalTo(collectionItemImportantLabel_One.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(42)
            make.right.equalToSuperview().inset(26)
        }
        separateViewUnderNumTwo.snp.makeConstraints { make in
            make.top.equalTo(collectionItemImportantLabel_Two.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
    
        /* 3. 수집한 개인정보의 처리 목적 */
        purposeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separateViewUnderNumTwo.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(23)
        }
        purposeContentLabel.snp.makeConstraints { make in
            make.top.equalTo(purposeTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        purposeDot_One.snp.makeConstraints { make in
            make.top.equalTo(purposeContentLabel.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(42)
        }
        purposeDotLabel_One.snp.makeConstraints { make in
            make.top.equalTo(purposeContentLabel.snp.bottom).offset(27)
            make.left.equalTo(purposeDot_One.snp.right).offset(5)
            make.right.equalToSuperview().inset(41)
        }
        purposeDot_Two.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_One.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        purposeDotLabel_Two.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_One.snp.bottom).offset(16)
            make.left.equalTo(purposeDot_Two.snp.right).offset(5)
            make.right.equalToSuperview().inset(41)
        }
        purposeDot_Three.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Two.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        purposeDotLabel_Three.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Two.snp.bottom).offset(16)
            make.left.equalTo(purposeDot_Three.snp.right).offset(5)
            make.right.equalToSuperview().inset(41)
        }
        purposeDot_Four.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Three.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        purposeDotLabel_Four.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Three.snp.bottom).offset(16)
            make.left.equalTo(purposeDot_Four.snp.right).offset(5)
            make.right.equalToSuperview().inset(41)
        }
        purposeDot_Five.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Four.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        purposeDotLabel_Five.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Four.snp.bottom).offset(16)
            make.left.equalTo(purposeDot_Five.snp.right).offset(5)
            make.right.equalToSuperview().inset(41)
        }
        separateViewUnderNumThree.snp.makeConstraints { make in
            make.top.equalTo(purposeDotLabel_Five.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        /* 4. 개인정보의 제3자 제공 */
        provisionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separateViewUnderNumThree.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(19)
        }
        provisionContentLabel.snp.makeConstraints { make in
            make.top.equalTo(provisionTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(38)
        }
        provisionDotLabel_One.snp.makeConstraints { make in
            make.top.equalTo(provisionContentLabel.snp.bottom).offset(27)
            make.left.equalToSuperview().inset(42)
        }
        provisionDotLabel_Two.snp.makeConstraints { make in
            make.top.equalTo(provisionDotLabel_One.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        provisionDotLabel_Three.snp.makeConstraints { make in
            make.top.equalTo(provisionDotLabel_Two.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        provisionDotLabel_Four.snp.makeConstraints { make in
            make.top.equalTo(provisionDotLabel_Three.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(42)
        }
        separateViewUnderNumFour.snp.makeConstraints { make in
            make.top.equalTo(provisionDotLabel_Four.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(8)
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
    
    private func createNeoMediumTwelve(text: String) -> UILabel {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
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


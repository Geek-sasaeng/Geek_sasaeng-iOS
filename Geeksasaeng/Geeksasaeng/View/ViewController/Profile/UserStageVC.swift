//
//  UserStageVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/23.
//

import UIKit

import SnapKit
import Then

class UserStageViewController: UIViewController {
    
    // MARK: - Properties
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // MARK: - SubViews
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    // 콘텐츠뷰
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let mainTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "긱사생의 학년 기준을 알려드릴게요."
        $0.numberOfLines = 0
        $0.font = .customFont(.neoBold, size: 24)
        
        // label 행간 설정
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
    }
    
    let gradeGuideLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "긱사생에서는 회원의 활동 수에 따라 이수한 학점의 수가 계산됩니다."
        $0.numberOfLines = 0
        $0.font = .customFont(.neoMedium, size: 16)
        
        // label 행간 설정
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.34
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
    }
    
    let characterImageView = UIImageView().then {
        $0.image = UIImage(named: "Character")
    }
    
    let heartStageImageView = UIImageView().then {
        $0.image = UIImage(named: "HeartStage")
    }
    
    let userGradeLabel = UILabel().then {
        $0.text = "회원 등급"
    }
    let activityNumLabel = UILabel().then {
        $0.text = "누적 활동 수"
    }
    
    lazy var stageStackView = UIStackView().then {
        $0.axis = .vertical
        $0.sizeToFit()
        $0.layoutIfNeeded()
        $0.distribution = .fillProportionally
        $0.alignment = .center
        $0.spacing = 6
        
        // 안에 서브뷰 구성
        setStageStackView(gradeArray: ["신입생", "복학생", "졸업생"],
                          activityArray: ["-", "5번", "20번"],
                          spacingArray: [45, 37, 33],
                          stackView: $0)
    }
    
    let secondTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "나도 선배가 될 수 있어요."
        $0.font = .customFont(.neoBold, size: 16)
    }
    
    let upgradeGuideLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "긱사생에서 제공하는 서비스의 누적 활동 수가 5번 이상일 시, 처음 [신입] 단계에서 [복학] 단계로 업그레이드 되며, 누적 활동 수가 20번 이상일 시, [복학] 단계에서 [졸업] 단계로 업그레이드 됩니다."
        $0.numberOfLines = 0
        $0.font = .customFont(.neoMedium, size: 16)
        
        // label 행간 설정
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.34
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
    }
    
    let goToPartyLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.text = "이제 긱사생 활동을 더 즐기러 가볼까요?"
        $0.font = .customFont(.neoBold, size: 13)
    }
    
    lazy var goToPartyButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 5
        $0.setTitle("배달파티 하러 가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.addTarget(self, action: #selector(tapGoMainButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setAttributes()
        addSubViews()
        setLayouts()
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
    
    // stage를 알려주는 containerView를 만들고 StackView로 묶는다.
    private func setStageStackView(gradeArray: [String], activityArray: [String], spacingArray: [Int], stackView: UIStackView) {
        for i in 0..<gradeArray.count {
            let grade = gradeArray[i]
            let activity = activityArray[i]
            let spacing = spacingArray[i]
            let containerView: UIView = {
                let view = UIView()
                view.backgroundColor = .init(hex: 0xF1F5F9)
                view.layer.cornerRadius = 10
                
                let gradeLabel = UILabel()
                gradeLabel.text = grade
                gradeLabel.font = .customFont(.neoMedium, size: 14)
                
                let activityLabel = UILabel()
                activityLabel.text = activity
                activityLabel.font = .customFont(.neoMedium, size: 14)
                
                view.addSubview(gradeLabel)
                view.addSubview(activityLabel)
                gradeLabel.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().inset(22)
                }
                activityLabel.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(gradeLabel.snp.right).offset(spacing)
                }
                
                return view
            }()
            
            /* Stack View */
            stackView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(31)
            }
        }
    }
    
    private func setAttributes() {
        self.navigationItem.title = "사용자 단계 안내"
        
        [ userGradeLabel, activityNumLabel ].forEach {
            $0.font = .customFont(.neoRegular, size: 11)
            $0.textColor = .init(hex: 0xA8A8A8)
        }
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            mainTitleLabel,
            gradeGuideLabel,
            characterImageView, heartStageImageView,
            userGradeLabel, activityNumLabel, stageStackView,
            secondTitleLabel,
            upgradeGuideLabel,
            goToPartyLabel,
            goToPartyButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayouts() {
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 컨텐츠뷰
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(goToPartyButton.snp.bottom).offset(screenHeight / 27.6)
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().inset(34)
            make.width.equalTo(210)
        }
        
        gradeGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(mainTitleLabel.snp.left)
            make.right.equalToSuperview().inset(36)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(gradeGuideLabel.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(107)
            make.height.equalTo(127)
        }
        
        heartStageImageView.snp.makeConstraints { make in
            make.bottom.equalTo(characterImageView.snp.bottom).offset(-11)
            make.left.equalTo(characterImageView.snp.right).offset(16)
            make.width.equalTo(19)
            make.height.equalTo(97)
        }
        
        stageStackView.snp.makeConstraints { make in
            make.left.equalTo(heartStageImageView.snp.right).offset(7)
            make.right.equalToSuperview().inset(23)
            make.top.equalTo(gradeGuideLabel.snp.bottom).offset(48)
        }
        
        userGradeLabel.snp.makeConstraints { make in
            make.left.equalTo(stageStackView.snp.left).offset(20)
            make.bottom.equalTo(stageStackView.snp.top).offset(-4)
        }
        
        activityNumLabel.snp.makeConstraints { make in
            make.left.equalTo(userGradeLabel.snp.right).offset(18)
            make.centerY.equalTo(userGradeLabel)
        }
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(28)
            make.left.equalTo(mainTitleLabel.snp.left)
        }
        
        upgradeGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(secondTitleLabel.snp.left)
            make.right.equalToSuperview().inset(23)
        }
        
        goToPartyLabel.snp.makeConstraints { make in
            make.top.equalTo(upgradeGuideLabel.snp.bottom).offset(screenHeight / 8.88)
            make.centerX.equalToSuperview()
        }
        goToPartyButton.snp.makeConstraints { make in
            make.top.equalTo(goToPartyLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(51)
        }
    }
}

//
//  BankAccountVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit

import SnapKit
import Then

class BankAccountViewController: UIViewController {

    // MARK: - SubViews
    
    /* titleLabel: 계좌번호 입력하기 */
    let titleLabel = UILabel().then {
        $0.text = "계좌번호 입력하기"
        $0.font = .customFont(.neoMedium, size: 18)
        $0.textColor = .black
    }
    
    /* backbutton */
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    /* 은행 이름 입력하는 텍스트 필드 */
    lazy var bankTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "은행을 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
    }
    
    /* 계좌 번호 입력하는 텍스트 필드 */
    lazy var accountNumberTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "계좌번호를 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
    }
    
    /* 추후 수정이 가능합니다 */
    let guideLabel = UILabel().then {
        $0.text = "추후 수정이 가능합니다"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xA8A8A8)
    }
    
    /* 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setDeactivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    /* pageLabel: 1/2 */
    let pageLabel = UILabel().then {
        $0.text = "1/2"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xD8D8D8)
    }
    
    // MARK: - Properties
    
    var dormitoryInfo: DormitoryNameResult?
    // 프로토콜의 함수를 실행하기 위해 delegate를 설정
    var delegate: UpdateDeliveryDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(343)
        }
    }
    
    private func addSubViews() {
        [
            titleLabel, backButton,
            bankTextField,
            accountNumberTextField,
            guideLabel,
            nextButton,
            pageLabel
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
        bankTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(37)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(248)
        }
        accountNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(bankTextField.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(248)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
            make.width.equalTo(262)
            make.height.equalTo(51)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-23)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions
    
    /* 다음 버튼 누르면 실행되는 함수 -> 파티 이름 입력하기 화면을 보여줌 */
    @objc
    private func tapNextButton() {
        if let bank = bankTextField.text,
           let accountNumber = accountNumberTextField.text {
            CreateParty.bank = bank
            CreateParty.accountNumber = accountNumber
        }
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = PartyNameViewController()
            childView.dormitoryInfo = self.dormitoryInfo
            childView.delegate = self.delegate
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    /* 백버튼 눌렀을 때 실행 -> 이전 화면으로 돌아간다 */
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
        NotificationCenter.default.post(name: NSNotification.Name("TapBackButtonFromBankAccountVC"), object: "true")
    }
    
    @objc
    private func changeValueTitleTextField() {
        guard let bankText = bankTextField.text,
              let accountNumberText = accountNumberTextField.text else { return }
                
        if bankText.count >= 1 && accountNumberText.count >= 1 {
            nextButton.setActivatedNextButton()
        }
    }
}
//
//  BankAccountVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit

class BankAccountViewController: UIViewController {

    // MARK: - SubViews
    
    /* titleLabel: 계좌번호 입력하기 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "계좌번호 입력하기"
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }()
    
    /* backbutton */
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    /* 은행 이름 입력하는 텍스트 필드 */
    lazy var bankTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "은행을 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        textField.makeBottomLine(248)
        textField.font = .customFont(.neoMedium, size: 15)
        textField.textColor = .init(hex: 0x5B5B5B)
        textField.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        return textField
    }()
    
    /* 계좌 번호 입력하는 텍스트 필드 */
    lazy var accountNumberTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "계좌번호를 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        textField.makeBottomLine(248)
        textField.font = .customFont(.neoMedium, size: 15)
        textField.textColor = .init(hex: 0x5B5B5B)
        textField.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        return textField
    }()
    
    /* 추후 수정이 가능합니다 */
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "추후 수정이 가능합니다"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xA8A8A8)
        return label
    }()
    
    /* 다음 버튼 */
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setDeactivatedNextButton()
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 1/2 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "1/2"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Properties
    var dormitoryInfo: DormitoryNameResult?
    
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
    
    /* 다음 버튼 누르면 실행되는 함수 -> 파티 이름 입력하기 화면을 보여줌 */
    @objc
    private func tapNextButton() {
        if let bank = bankTextField.text {
            CreateParty.bank = bank
        }
        
        if let accountNumber = accountNumberTextField.text {
            CreateParty.accountNumber = accountNumber
        }
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = PartyNameViewController()
            childView.dormitoryInfo = self.dormitoryInfo
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
        if bankTextField.text?.count ?? 0 >= 1
            && accountNumberTextField.text?.count ?? 0 >= 1 {
            nextButton.setActivatedNextButton()
        }
    }
}

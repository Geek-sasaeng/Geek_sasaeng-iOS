//
//  UrlVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/19.
//

import UIKit
import SnapKit

class EditUrlViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 매칭 인원 선택 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "식당 링크"
        label.font = .customFont(.neoMedium, size: 18)
        return label
    }()
    
    /* url 입력 텍스트 필드 */
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = .customFont(.neoRegular, size: 15)
        textField.placeholder = "입력하세요"
        textField.makeBottomLine(210)
        textField.textColor = .black
        return textField
    }()
    
    /* 건너뛰기 버튼 */
    lazy var passButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setActivatedNextButton()
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        addSubViews()
        setLayouts()
        setDefaultValueOfTextField()
    }
    
    // MARK: - Functions
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    private func addSubViews() {
        [titleLabel, urlTextField, passButton, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(48)
            make.width.equalTo(210)
        }
        
        passButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-33)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setDefaultValueOfTextField() {
        if let url = CreateParty.url {
            urlTextField.text = url
        }
    }
    
    @objc
    private func tapNextButton() {
        if let url = urlTextField.text {
            print("=======", url)
            CreateParty.url = url
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TapEditUrlButton"), object: "true")
    }
}

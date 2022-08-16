//
//  UrlVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/19.
//

import UIKit
import SnapKit

class UrlViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 매칭 인원 선택 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "식당 링크"
        label.font = .customFont(.neoMedium, size: 18)
        return label
    }()
    
    /* backbutton */
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    /* url 입력 텍스트 필드 */
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = .customFont(.neoRegular, size: 15)
        textField.placeholder = "입력하세요"
        textField.makeBottomLine()
        textField.textColor = .black
        return textField
    }()
    
    let urlTextFieldArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UrlArrow")
        return imageView
    }()
    
    let urlExplainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .customFont(.neoMedium, size: 16)
        label.text = "원하는 식당의 링크를 복사하여\n입력해주세요"
        return label
    }()
    
    let urlExampleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .customFont(.neoRegular, size: 11)
        label.text = "ex. 배달의 민족, 요기요"
        return label
    }()
    
    let urlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UrlImage")
        return imageView
    }()
    
    /* 건너뛰기 버튼 */
    lazy var passButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 15)
        button.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        button.addTarget(self, action: #selector(tapPassButton), for: .touchUpInside)
        return button
    }()
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setActivatedNextButton()
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 4/5 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "4/5"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    private func addSubViews() {
        [titleLabel, backButton, urlTextField, passButton, nextButton, pageLabel,
         urlTextFieldArrow, urlExplainLabel, urlExampleLabel, urlImageView].forEach {
            view.addSubview($0)
        }
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
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(48)
            make.width.equalTo(210)
        }
        
        urlTextFieldArrow.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
        }
        
        urlExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(urlTextFieldArrow.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        urlExampleLabel.snp.makeConstraints { make in
            make.top.equalTo(urlExplainLabel.snp.bottom).offset(4)
            make.left.equalTo(urlExplainLabel.snp.left)
        }
        
        urlImageView.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(38)
            make.right.equalToSuperview().inset(39)
            make.width.equalTo(144)
            make.height.equalTo(124)
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
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setDefaultValueOfTextField() {
        if let url = CreateParty.url {
            urlTextField.text = url
            return
        }
    }
    
    @objc
    private func tapNextButton() {
        if let url = urlTextField.text {
            CreateParty.url = url
        }
        
        if urlTextField.text?.count == 0 {
            CreateParty.url = "?"
        }
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = ReceiptPlaceViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapPassButton() {
        CreateParty.url = "?"
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = ReceiptPlaceViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
}

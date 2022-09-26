//
//  UrlVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/19.
//

import UIKit
import SnapKit
import Then

class UrlViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 매칭 인원 선택 */
    let titleLabel = UILabel().then {
        $0.text = "식당 링크"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    /* backbutton */
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    /* url 입력 텍스트 필드 */
    let urlTextField = UITextField().then {
        $0.font = .customFont(.neoRegular, size: 15)
        $0.placeholder = "입력하세요"
        $0.makeBottomLine()
        $0.textColor = .black
    }
    
    let urlTextFieldArrow = UIImageView().then {
        $0.image = UIImage(named: "UrlArrow")
    }
    
    let urlExplainLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .customFont(.neoMedium, size: 16)
        $0.text = "원하는 식당의 링크를 복사하여\n입력해주세요"
    }
    
    let urlExampleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .customFont(.neoRegular, size: 11)
        $0.text = "ex. 배달의 민족, 요기요"
    }
    
    let urlImageView = UIImageView().then {
        $0.image = UIImage(named: "UrlImage")
    }
    
    /* 건너뛰기 버튼 */
    lazy var passButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x5B5B5B), for: .normal)
        $0.titleLabel?.font = .customFont(.neoLight, size: 15)
        $0.makeBottomLine(color: 0x5B5B5B, width: 55, height: 1, offsetToTop: -8)
        $0.addTarget(self, action: #selector(tapPassButton), for: .touchUpInside)
    }
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setActivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    /* pageLabel: 4/5 */
    let pageLabel = UILabel().then {
        $0.text = "4/5"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xD8D8D8)
    }
    
    // MARK: - Properties
    
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
            make.height.equalTo(405)
        }
    }
    
    private func addSubViews() {
        [titleLabel, backButton, urlTextField, passButton, nextButton, pageLabel,
         urlTextFieldArrow, urlExplainLabel, urlExampleLabel, urlImageView].forEach {
            view.addSubview($0)
        }
        view.sendSubviewToBack(urlImageView)
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
    
    @objc
    private func tapNextButton() {
        if let url = urlTextField.text, !url.isEmpty {
            CreateParty.url = url
        } else {
            CreateParty.url = "URL을 입력하지 않았습니다"
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
        CreateParty.url = "URL을 입력하지 않았습니다"
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

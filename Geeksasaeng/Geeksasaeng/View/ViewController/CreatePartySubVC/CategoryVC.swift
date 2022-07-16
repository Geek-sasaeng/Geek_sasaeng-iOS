//
//  CategoryVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

// TODO: - 선택된 버튼 미리 띄우기

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 카테고리 선택 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 선택"
        label.font = .customFont(.neoMedium, size: 18)
        return label
    }()
    
    /* backbutton */
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    /* category labels */
    let korean: UIButton = {
        let button = UIButton()
        button.setTitle("한식", for: .normal)
        return button
    }()
    
    let western: UIButton = {
        let button = UIButton()
        button.setTitle("양식", for: .normal)
        return button
    }()
    
    let chinese: UIButton = {
        let button = UIButton()
        button.setTitle("중식", for: .normal)
        return button
    }()
    
    let japanese: UIButton = {
        let button = UIButton()
        button.setTitle("일식", for: .normal)
        return button
    }()
    
    let snack: UIButton = {
        let button = UIButton()
        button.setTitle("분식", for: .normal)
        return button
    }()
    
    let chicken: UIButton = {
        let button = UIButton()
        button.setTitle("치킨/피자", for: .normal)
        return button
    }()
    
    let rawfish: UIButton = {
        let button = UIButton()
        button.setTitle("회/돈까스", for: .normal)
        return button
    }()
    
    let fastfood: UIButton = {
        let button = UIButton()
        button.setTitle("패스트 푸드", for: .normal)
        return button
    }()
    
    let dessert: UIButton = {
        let button = UIButton()
        button.setTitle("디저트/음료", for: .normal)
        return button
    }()
    
    let etc: UIButton = {
        let button = UIButton()
        button.setTitle("기타", for: .normal)
        return button
    }()
    
    /* nextButton: 다음 버튼 */
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setDeactivatedNextButton()
        button.addTarget(self, action: #selector(showReceiptPlaceVC), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 3/4 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "3/4"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Properties
    var selectedCategory: UIButton?
    var data: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        setCategoryButtons()
        setSubViews()
        setLayouts()
        setDefaultValueOfButton()
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    func setCategoryButtons() {
        [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .customFont(.neoMedium, size: 14)
            $0.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
            $0.addTarget(self, action: #selector(tapCategoryButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setSubViews() {
        [
            titleLabel, backButton, nextButton, pageLabel,
            korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc
        ].forEach {
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
        
        [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(126)
                make.height.equalTo(38)
            }
        }
        
        [korean, chinese, snack, rawfish, dessert].forEach {
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(21)
            }
        }
        
        [western, japanese, chicken, fastfood, etc].forEach {
            $0.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(21)
            }
        }
        
        [korean, western].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(23)
            }
        }
        
        [chinese, japanese].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(korean.snp.bottom).offset(7)
            }
        }
        
        [snack, chicken].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(chinese.snp.bottom).offset(7)
            }
        }
        
        [rawfish, fastfood].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(snack.snp.bottom).offset(7)
            }
        }
        
        [dessert, etc].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(rawfish.snp.bottom).offset(7)
            }
        }
    }
    
    private func setDefaultValueOfButton() {
        if let category = CreateParty.category {
            [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
                if category == $0.titleLabel?.text {
                    $0.setTitleColor(.white, for: .normal)
                    $0.backgroundColor = .mainColor
                    selectedCategory = $0
                    nextButton.setActivatedNextButton()
                }
            }
        }
    }
    
    @objc func showReceiptPlaceVC() {
        CreateParty.category = data
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = ReceiptPlaceViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }

    @objc func tapCategoryButton(_ sender: UIButton) {
        if selectedCategory != nil {
            selectedCategory?.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
            selectedCategory?.backgroundColor = UIColor(hex: 0xEFEFEF)
            selectedCategory = sender
        } else {
            selectedCategory = sender
        }
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = .mainColor
        
        nextButton.setActivatedNextButton()
        
        data = sender.titleLabel?.text
    }
    
    @objc func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
}

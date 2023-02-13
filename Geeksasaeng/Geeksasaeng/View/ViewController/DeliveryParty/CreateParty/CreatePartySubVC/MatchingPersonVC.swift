//
//  MatchingPersonVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import Then

class MatchingPersonViewController: UIViewController {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var pickerViewData = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명"]
    var data: String? // CreateParty 전역 변수에 저장할 데이터
    
    // MARK: - SubViews
    /* titleLabel: 매칭 인원 선택 */
    let titleLabel = UILabel().then {
        $0.text = "매칭 인원 선택"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    /* backbutton */
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
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
    
    /* pageLabel: 2/5 */
    let pageLabel = UILabel().then {
        $0.text = "2/5"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xD8D8D8)
    }
    
    let personPickerView = UIPickerView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setPickerView()
        setDefaultValueOfPicker()
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.29)
            make.height.equalTo(screenHeight / 2.1)
        }
    }
    
    private func addSubViews() {
        [titleLabel, backButton, personPickerView, nextButton, pageLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight / 29.37)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(screenWidth / 12.67)
        }
        
        personPickerView.snp.makeConstraints { make in
            make.width.height.equalTo(screenWidth / 2.18)
            make.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.5)
            make.height.equalTo(screenHeight / 16.7)
            make.bottom.equalToSuperview().inset(screenHeight / 24.34)
            make.centerX.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(screenHeight / 85.2)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func tapNextButton() {
        // PickerView를 안 돌리고 화면 전환 했을 때, default 값 2명
        if data == nil {
            data = "2명"
            CreateParty.matchingPerson = "2명"
        } else {
            CreateParty.matchingPerson = data
        }
        
        // API Input에 저장
        if let data = data {
            if let intData = Int(data.replacingOccurrences(of: "명", with: "")) {
                CreateParty.maxMatching = intData
            }
        }
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = CategoryViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    private func setPickerView() {
        personPickerView.delegate = self
        personPickerView.dataSource = self
    }
    
    private func setDefaultValueOfPicker() {
        if let matchingPerson = CreateParty.matchingPerson {
            let value = Int(matchingPerson.replacingOccurrences(of: "명", with: "")) ?? 0
            personPickerView.selectRow(value - 2, inComponent: 0, animated: true)
        }
    }
    
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension MatchingPersonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = pickerViewData[row]
        label.font = .customFont(.neoMedium, size: 20)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 47
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        data = pickerViewData[row]
    }
    
}

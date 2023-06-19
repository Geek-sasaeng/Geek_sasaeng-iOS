//
//  MatchingPersonVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import Then

class EditMatchingPersonViewController: UIViewController {
    
    // MARK: - SubViews
    
    /* titleLabel: 매칭 인원 선택 */
    let titleLabel = UILabel().then {
        $0.text = "매칭 인원 선택"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setActivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    let personPickerView = UIPickerView()
    
    // MARK: - Properties
    
    var currentMatching: Int?
    var pickerViewData = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명"]
    var data: String? // CreateParty 전역 변수에 저장할 데이터
    
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
    
    // MARK: - Initialization
    
    init(currentMatching: Int) {
        super.init(nibName: nil, bundle: nil)
        self.currentMatching = currentMatching
        print("DEBUG: 현재 참여 인원", currentMatching)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        [titleLabel, personPickerView, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        personPickerView.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
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
    
    // MARK: - @objc Functions
    
    @objc
    private func tapNextButton() {
        // PickerView를 안 돌리고 화면 전환 했을 때, default 값은 수정 전의 모집 인원
        if data == nil {
            data = CreateParty.matchingPerson
        } else {
            CreateParty.matchingPerson = data
        }
        
        // API Input에 저장
        if let data = data {
            if let intData = Int(data.replacingOccurrences(of: "명", with: "")) {
                CreateParty.maxMatching = intData
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TapEditPersonButton"), object: "true")
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension EditMatchingPersonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = pickerViewData[row]
        // 현재 참여 인원 수보다 더 적은 수는 비활성화 색으로 설정
        if currentMatching! > row + 2 {
            label.textColor = .init(hex: 0xD8D8D8)
        } else {
            label.textColor = .black
        }
        label.font = .customFont(.neoMedium, size: 20)
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 47
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentMatching! > row + 2{
            // 현재 참여 인원수보다 더 적은 수를 pick하면 현재 참여 인원수로 넣어준다
            data = pickerViewData[currentMatching! - 2]
        } else {
            data = pickerViewData[row]
        }
    }
}

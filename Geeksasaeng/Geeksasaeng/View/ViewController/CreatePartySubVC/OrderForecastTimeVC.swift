//
//  OrderForecastTimeVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

// TODO: - datePicker에서 year 지우기

import UIKit
import SnapKit

class OrderForecastTimeViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 주문 예정 시간 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 예정 시간"
        label.font = .customFont(.neoMedium, size: 18)
        return label
    }()
    
    /* dateTextField: 현재 날짜 */
    let dateTextField: UITextField = {
        let textField = UITextField()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        textField.text = formatter.string(from: Date())
        textField.font = .customFont(.neoMedium, size: 32)
        textField.tintColor = .clear
        return textField
    }()
    
    /* tileLabel: 현재 시간 */
    let timeTextField: UITextField = {
        let textField = UITextField()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        textField.text = formatter.string(from: Date())
        textField.font = .customFont(.neoMedium, size: 20)
        textField.tintColor = .clear
        return textField
    }()
    
    /* orderAsSoonAsMatchButton: 매칭 시 바로 주문 토글 버튼 */
    let orderAsSoonAsMatchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = UIColor(hex: 0xD8D8D8)
        button.setTitle("  매칭 시 바로 주문", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 13)
        button.addTarget(self, action: #selector(tapOrderAsSoonAsMatchButton), for: .touchUpInside)
        return button
    }()
    
    /* nextButton: 다음 버튼 */
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setActivatedNextButton()
        button.addTarget(self, action: #selector(showMatchingPersonVC), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 1/4 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "1/4"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        setSubViews()
        setLayouts()
        setDatePicker()
        setTimePicker()
        setDefaultValueOfPicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    private func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(changedDatePickerValue), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ko_KR")
        dateTextField.inputView = datePicker
    }
    
    private func setTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(changedTimePickerValue), for: .valueChanged)
        timePicker.locale = Locale(identifier: "ko_KR")
        timeTextField.inputView = timePicker
    }
    
    private func setSubViews() {
        [titleLabel, dateTextField, timeTextField, orderAsSoonAsMatchButton, nextButton, pageLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
            make.centerX.equalToSuperview()
        }
        
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        orderAsSoonAsMatchButton.snp.makeConstraints { make in
            make.top.equalTo(timeTextField.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
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
    
    private func setDefaultValueOfPicker() {
        if let orderForecastTime = CreateParty.orderForecastTime {
            if let str = CreateParty.orderForecastTime?.replacingOccurrences(of: " ", with: "") {
                let startIdx = str.index(str.startIndex, offsetBy: 6)
                let dateRange = ..<startIdx // 월, 일
                let timeRange = startIdx... // 시, 분
                // TextField 초기값 설정
                dateTextField.text = "\(str[dateRange])"
                timeTextField.text = "\(str[timeRange])"
                
                // PickerView 초기값 설정
                let dateStr = str[dateRange].replacingOccurrences(of: "월", with: "-").replacingOccurrences(of: "일", with: "")
                let timeStr = str[timeRange].replacingOccurrences(of: "시", with: ":").replacingOccurrences(of: "분", with: "")
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy"
                let currentYears = formatter.string(from: Date())
                // 최종 문자열
                let formattedDate = "\(currentYears)-\(dateStr)"
                let formattedTime = "\(timeStr)"
                formatter.dateFormat = "yyyy-MM-dd"
                if let formattedDate = formatter.date(from: formattedDate) {
                    datePicker.setDate(formattedDate, animated: true)
                }
                formatter.dateFormat = "HH:mm"
                if let formattedTime = formatter.date(from: formattedTime) {
                    timePicker.setDate(formattedTime, animated: true)
                }
            }
        }
    }
    
    @objc func changedDatePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc func changedTimePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        timeTextField.text = formatter.string(from: timePicker.date)
        timeTextField.sendActions(for: .editingChanged)
    }
    
    @objc func tapOrderAsSoonAsMatchButton() {
        if orderAsSoonAsMatchButton.currentImage == UIImage(systemName: "checkmark.circle") {
            orderAsSoonAsMatchButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            orderAsSoonAsMatchButton.setTitleColor(.mainColor, for: .normal)
            orderAsSoonAsMatchButton.tintColor = .mainColor
        } else {
            orderAsSoonAsMatchButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            orderAsSoonAsMatchButton.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            orderAsSoonAsMatchButton.tintColor = UIColor(hex: 0xD8D8D8)
        }
    }
    
    @objc func showMatchingPersonVC() {
        // 날짜, 시간 정보 전역변수에 저장
        CreateParty.orderForecastTime = "\(dateTextField.text!)        \(timeTextField.text!)"
        
        if orderAsSoonAsMatchButton.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            CreateParty.orderAsSoonAsMatch = true
        } else {
            CreateParty.orderAsSoonAsMatch = false
        }
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = MatchingPersonViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
}

//
//  OrderForecastTimeVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit

class EditOrderForecastTimeViewController: UIViewController {
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
        textField.textColor = .black
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
        textField.textColor = .black
        return textField
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
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        addSubViews()
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
    
    private func addSubViews() {
        [titleLabel, dateTextField, timeTextField, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(94)
            make.centerX.equalToSuperview()
        }
        
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setDefaultValueOfPicker() {
        if let orderForecastTime = CreateParty.orderForecastTime {
            var str = orderForecastTime.replacingOccurrences(of: " ", with: "")
            print("===", str)
            let startIdx = str.index(str.startIndex, offsetBy: 7)
            let dateRange = ..<startIdx // 월, 일
            let timeRange = startIdx... // 시, 분
            str = str.replacingOccurrences(of: "월", with: "월 ")
            str = str.replacingOccurrences(of: "시", with: "시 ")
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
    
    @objc
    private func changedDatePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc
    private func changedTimePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        timeTextField.text = formatter.string(from: timePicker.date)
        timeTextField.sendActions(for: .editingChanged)
    }
    
    @objc
    private func tapNextButton() {
        // 날짜, 시간 정보 전역변수에 저장
        CreateParty.orderForecastTime = "\(dateTextField.text!)        \(timeTextField.text!)"
        
        // API Input에 저장
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePicker.date)
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: timePicker.date)
        CreateParty.orderTime = "\(date) \(time)"
        
        NotificationCenter.default.post(name: NSNotification.Name("TapEditOrderTimeButton"), object: "true")
    }
}

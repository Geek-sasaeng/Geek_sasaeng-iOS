//
//  CreatePartyVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/11.
//

import UIKit
import SnapKit

class CreatePartyViewController: UIViewController {
    // MARK: - SubViews
    var rightBarButtonItem: UIBarButtonItem = {
        let registerButton = UIButton()
        registerButton.setTitle("등록", for: .normal)
        registerButton.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        let barButton = UIBarButtonItem(customView: registerButton)
        barButton.isEnabled = false
        return barButton
    }()
    
    var eatTogetherButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = UIColor(hex: 0xD8D8D8)
        button.setTitle("  같이 먹고 싶어요", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoLight, size: 13)
        button.addTarget(self, action: #selector(tapEatTogetherButton), for: .touchUpInside)
        return button
    }()
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xA8A8A8)]
        )
        textField.font = .customFont(.neoMedium, size: 20)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: 0xEFEFEF).cgColor
        return textField
    }()
    
    var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .customFont(.neoRegular, size: 15)
        textView.refreshControl?.contentVerticalAlignment = .top
        textView.text = "내용을 입력하세요"
        textView.textColor = UIColor(hex: 0xD8D8D8)
        return textView
    }()
    
    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF8F8F8)
        return view
    }()
    
    var orderForecastTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "주문 예정 시간"
        return label
    }()
    
    var matchingPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "매칭 인원 선택"
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "카테고리 선택"
        return label
    }()
    
    var receiptPlace: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "수령 장소"
        return label
    }()
    
    var orderForecastTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle("7월 1일          22시 17분", for: .normal)
        button.titleLabel?.font = .customFont(.neoRegular, size: 13)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.setActivatedButton()
        return button
    }()
    
    var orderAsSoonAsMatchLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 12)
        label.textColor = UIColor(hex: 0xD8D8D8)
        label.text = "매칭 시 바로 주문"
        return label
    }()
    
    var selectedPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoRegular, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        label.backgroundColor = UIColor(hex: 0xEFEFEF)
        label.text = "      0/0"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        return label
    }()
    
    var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoRegular, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        label.backgroundColor = UIColor(hex: 0xEFEFEF)
        label.text = "      한식"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        return label
    }()
    
    var selectedPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoRegular, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        label.backgroundColor = UIColor(hex: 0xEFEFEF)
        label.text = "      제1기숙사 후문"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setDate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationItem.title = "파티 생성하기"
        contentsTextView.delegate = self
        
        // set barButtonItem
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func addSubViews() {
        [eatTogetherButton, titleTextField, contentsTextView, separateView,
         orderForecastTimeLabel, matchingPersonLabel, categoryLabel, receiptPlace,
         orderForecastTimeButton, orderAsSoonAsMatchLabel,
         selectedPersonLabel, selectedCategoryLabel, selectedPlaceLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        eatTogetherButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(105)
            make.left.equalToSuperview().inset(28)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(eatTogetherButton.snp.bottom).offset(11)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(314)
            make.height.equalTo(45)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(38)
            make.width.equalTo(294)
            make.height.equalTo(157)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(16)
            make.height.equalTo(8)
            make.width.equalToSuperview()
        }
        
        orderForecastTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(31)
            make.left.equalToSuperview().inset(28)
        }
        
        matchingPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().inset(28)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(matchingPersonLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(28)
        }
        
        receiptPlace.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(28)
        }
        
        orderForecastTimeButton.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(24)
            make.left.equalTo(orderForecastTimeLabel.snp.right).offset(35)
            make.width.equalTo(188)
            make.height.equalTo(30)
        }
        
        orderAsSoonAsMatchLabel.snp.makeConstraints { make in
            make.top.equalTo(orderForecastTimeButton.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(159)
        }
        
        selectedPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(orderAsSoonAsMatchLabel.snp.bottom).offset(19)
            make.left.equalTo(matchingPersonLabel.snp.right).offset(38)
            make.width.equalTo(188)
            make.height.equalTo(30)
        }
        
        selectedCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedPersonLabel.snp.bottom).offset(10)
            make.left.equalTo(selectedPersonLabel.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(30)
        }
        
        selectedPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedCategoryLabel.snp.bottom).offset(10)
            make.left.equalTo(selectedCategoryLabel.snp.left)
            make.width.equalTo(188)
            make.height.equalTo(30)
        }
    }
    
    /* 현재 날짜와 시간을 orderForecastTimeButton에 출력 */
    private func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일        HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        orderForecastTimeButton.setTitle(formatter.string(from: Date()), for: .normal)
    }
    
    // 이전 화면으로 돌아가기
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc func tapEatTogetherButton() {
        if eatTogetherButton.currentImage == UIImage(systemName: "checkmark.circle") {
            eatTogetherButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            eatTogetherButton.tintColor = .mainColor
            eatTogetherButton.setTitleColor(.mainColor, for: .normal)
        } else {
            eatTogetherButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            eatTogetherButton.tintColor = UIColor(hex: 0xD8D8D8)
            eatTogetherButton.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        }
    }
}

extension CreatePartyViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor(hex: 0xD8D8D8)
        }
    }
}

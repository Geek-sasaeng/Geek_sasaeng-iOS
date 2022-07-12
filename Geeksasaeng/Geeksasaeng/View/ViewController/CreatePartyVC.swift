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
        button.titleLabel?.font = .customFont(.neoRegular, size: 13)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.setActivatedButton()
        button.addTarget(self, action: #selector(showOrderForecaseTimeView), for: .touchUpInside)
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
    
    var visualEffectView: UIVisualEffectView?
    
    var orderForecastTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
        
        /* titleLabel: 주문 예정 시간 */
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "주문 예정 시간"
            label.font = .customFont(.neoMedium, size: 18)
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        /* dateLabel: 현재 날짜 */
        let dateLabel: UILabel = {
            let label = UILabel()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM월 dd일"
            formatter.locale = Locale(identifier: "ko_KR")
            label.text = formatter.string(from: Date())
            label.font = .customFont(.neoMedium, size: 32)
            return label
        }()
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
            make.centerX.equalToSuperview()
        }
        
        /* tileLabel: 현재 시간 */
        let timeLabel: UILabel = {
            let label = UILabel()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH시 mm분"
            formatter.locale = Locale(identifier: "ko_KR")
            label.text = formatter.string(from: Date())
            label.font = .customFont(.neoMedium, size: 20)
            return label
        }()
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        /* orderAsSoonAsMatchButton: 매칭 시 바로 주문 토글 버튼 */
        let orderAsSoonAsMatchButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            button.tintColor = UIColor(hex: 0xD8D8D8)
            button.setTitle("  매칭 시 바로 주문", for: .normal)
            button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            button.titleLabel?.font = .customFont(.neoLight, size: 13)
            button.addTarget(self, action: #selector(tapOrderAsSoonAsMatchButton(_:)), for: .touchUpInside)
            return button
        }()
        view.addSubview(orderAsSoonAsMatchButton)
        orderAsSoonAsMatchButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
        
        
        
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
            button.addTarget(self, action: #selector(showMatchingPersonView), for: .touchUpInside)
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        /* pageLabel: 1/4 */
        let pageLabel: UILabel = {
            let label = UILabel()
            label.text = "1/4"
            label.font = .customFont(.neoMedium, size: 13)
            label.textColor = UIColor(hex: 0xD8D8D8)
            return label
        }()
        view.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        print("DEBUG::: \(view.subviews)")
        return view
    }()
    
    var matchingPersonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
        
        /* titleLabel: 매칭 인원 선택 */
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "매칭 인원 선택"
            label.font = .customFont(.neoMedium, size: 18)
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        /* backbutton */
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            button.tintColor = UIColor(hex: 0x5B5B5B)
            return button
        }()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
        let personPicker: UIPickerView = {
            let pickerView = UIPickerView()
            return pickerView
        }()
        view.addSubview(personPicker)
        personPicker.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.center.equalToSuperview()
        }
        
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
            button.addTarget(self, action: #selector(showCategoryView), for: .touchUpInside)
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        /* pageLabel: 2/4 */
        let pageLabel: UILabel = {
            let label = UILabel()
            label.text = "2/4"
            label.font = .customFont(.neoMedium, size: 13)
            label.textColor = UIColor(hex: 0xD8D8D8)
            return label
        }()
        view.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
        
        /* titleLabel: 카테고리 선택 */
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "카테고리 선택"
            label.font = .customFont(.neoMedium, size: 18)
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        /* backbutton */
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            button.tintColor = UIColor(hex: 0x5B5B5B)
            return button
        }()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
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
            button.addTarget(self, action: #selector(showReceiptPlaceView), for: .touchUpInside)
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        /* pageLabel: 3/4 */
        let pageLabel: UILabel = {
            let label = UILabel()
            label.text = "3/4"
            label.font = .customFont(.neoMedium, size: 13)
            label.textColor = UIColor(hex: 0xD8D8D8)
            return label
        }()
        view.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    var receiptPlaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
        
        /* titleLabel: 수령 장소 */
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "수령 장소"
            label.font = .customFont(.neoMedium, size: 18)
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        /* backbutton */
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            button.tintColor = UIColor(hex: 0x5B5B5B)
            return button
        }()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
        /* nextButton: 다음 버튼 */
        let nextButton: UIButton = {
            let button = UIButton()
            button.setTitle("완료", for: .normal)
            button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            button.titleLabel?.font = .customFont(.neoBold, size: 20)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor(hex: 0xEFEFEF)
            button.clipsToBounds = true
            button.setActivatedNextButton()
            button.addTarget(self, action: #selector(removeAllSubViewsView), for: .touchUpInside)
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        /* pageLabel: 4/4 */
        let pageLabel: UILabel = {
            let label = UILabel()
            label.text = "4/4"
            label.font = .customFont(.neoMedium, size: 13)
            label.textColor = UIColor(hex: 0xD8D8D8)
            return label
        }()
        view.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    // MARK: - Properties
    var pickerViewData = ["1명", "2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명"]
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
        setDefaultDate()
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
    private func setDefaultDate() {
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
    
    /* show 주문 예정 시간 subView */
    @objc func showOrderForecaseTimeView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.orderForecastTimeView)
            self.orderForecastTimeView.snp.makeConstraints { make in
                make.center.equalTo(self.view.center)
            }
        }, completion: nil)
    }

    @objc func tapOrderAsSoonAsMatchButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "checkmark.circle") {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            sender.setTitleColor(.mainColor, for: .normal)
            sender.tintColor = .mainColor
        } else {
            sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            sender.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
            sender.tintColor = UIColor(hex: 0xD8D8D8)
        }
    }
    
    /* show 매칭 인원 선택 subView */
    @objc func showMatchingPersonView() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.matchingPersonView)
            self.matchingPersonView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    /* show 카테고리 선택 subView */
    @objc func showCategoryView() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.categoryView)
            self.categoryView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    /* show 수령 장소 subView */
    @objc func showReceiptPlaceView() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.receiptPlaceView)
            self.receiptPlaceView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    
    /* 모든 subView 제거 (완료 버튼 탭 시) */
    @objc func removeAllSubViewsView() {
        orderForecastTimeView.removeFromSuperview()
        matchingPersonView.removeFromSuperview()
        categoryView.removeFromSuperview()
        receiptPlaceView.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
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

extension CreatePartyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
}

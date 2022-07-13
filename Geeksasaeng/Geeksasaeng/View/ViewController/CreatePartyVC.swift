//
//  CreatePartyVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/11.
//

import UIKit
import SnapKit
import QuartzCore

class CreatePartyViewController: UIViewController {
    
    // MARK: - SubViews
    
    var deactivatedRightBarButtonItem: UIBarButtonItem = {
        let registerButton = UIButton()
        registerButton.setTitle("등록", for: .normal)
        registerButton.setTitleColor(UIColor(hex: 0xBABABA), for: .normal)
        let barButton = UIBarButtonItem(customView: registerButton)
        barButton.isEnabled = false
        return barButton
    }()
    
    var activatedRightBarButtonItem: UIBarButtonItem = {
        let registerButton = UIButton()
        registerButton.setTitle("등록", for: .normal)
        registerButton.setTitleColor(.mainColor, for: .normal)
        let barButton = UIBarButtonItem(customView: registerButton)
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
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xA8A8A8)]
        )
        textField.font = .customFont(.neoMedium, size: 20)
        
        // backgroundColor를 설정해 줬더니 borderStyle의 roundRect이 적용되지 않아서 따로 layer를 custom함
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: 0xEFEFEF).cgColor
        
        // placeholder와 layer 사이에 간격 설정
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        
        textField.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        return textField
    }()
    
    var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
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
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var matchingPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "매칭 인원 선택"
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "카테고리 선택"
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var receiptPlace: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 13)
        label.text = "수령 장소"
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var orderForecastTimeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .customFont(.neoRegular, size: 13)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.setActivatedButton()
        button.addTarget(self, action: #selector(showOrderForecaseTimeVC), for: .touchUpInside)
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
    
    // MARK: - Properties
    var settedOptions = false
    var editedContentsTextView = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setDelegate()
        setNavigationBar()
        setLayouts()
        setDefaultDate()
        setNotificationCenter()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /* Blur View 터치 시 서브뷰 사라지게 구현해야 함 */
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if touch?.view == self.view {
//            let viewControllers = self.children
//            viewControllers.forEach {
//                $0.removeFromParent()
//            }
//        }
//    }
    
    private func setDelegate() {
        contentsTextView.delegate = self
        titleTextField.delegate = self
    }
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
        self.navigationItem.title = "파티 생성하기"
        self.navigationItem.titleView?.tintColor = .init(hex: 0x2F2F2F)
        
        // set barButtonItem
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("TapConfirmButton"), object: nil, queue: nil) { notification in
            let result = notification.object as! String
            if result == "true" {
                // 각 서브뷰에서 저장된 전역변수 데이터 출력
                if let orderForecastTime = CreateParty.orderForecastTime {
                    self.orderForecastTimeButton.layer.shadowRadius = 0
                    self.orderForecastTimeButton.setTitle(orderForecastTime, for: .normal)
                    self.orderForecastTimeButton.titleLabel?.font = .customFont(.neoMedium, size: 13)
                    self.orderForecastTimeButton.backgroundColor = UIColor(hex: 0xF8F8F8)
                    self.orderForecastTimeButton.setTitleColor(.black, for: .normal)
                }
                
                if CreateParty.orderAsSoonAsMatch ?? false {
                    self.orderAsSoonAsMatchLabel.textColor = .mainColor
                } else {
                    self.orderAsSoonAsMatchLabel.textColor = UIColor(hex: 0xD8D8D8)
                }
                
                if let matchingPerson = CreateParty.matchingPerson {
                    self.selectedPersonLabel.text = "      \(matchingPerson)"
                    self.selectedPersonLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedPersonLabel.textColor = .black
                    self.selectedPersonLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                if let category = CreateParty.category {
                    self.selectedCategoryLabel.text = "      \(category)"
                    self.selectedCategoryLabel.font = .customFont(.neoMedium, size: 13)
                    self.selectedCategoryLabel.textColor = .black
                    self.selectedCategoryLabel.backgroundColor = UIColor(hex: 0xF8F8F8)
                }
                
                
                // Blur View 제거
                self.visualEffectView?.removeFromSuperview()
                
                // subVC 제거
                let viewControllers = self.children
                viewControllers.forEach {
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
                
                self.settedOptions = true
                if self.titleTextField.text?.count ?? 0 >= 3 && self.contentsTextView.text.count >= 5 {
                    self.navigationItem.rightBarButtonItem = self.activatedRightBarButtonItem
                    self.view.layoutSubviews()
                }
            }
        }
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
    
    /* 이전 화면으로 돌아가기 */
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
    
    /* show 주문 예정 시간 VC */
    @objc func showOrderForecaseTimeVC() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.layer.opacity = 0.6
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        self.visualEffectView = visualEffectView
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = OrderForecastTimeViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
    
    @objc func changeValueTitleTextField() {
        // settedOptions가 true인데 titleTextField가 지워진 경우
        if settedOptions
            && editedContentsTextView
            && contentsTextView.text.count >= 5
            && titleTextField.text?.count ?? 0 >= 3 {
            self.navigationItem.rightBarButtonItem = activatedRightBarButtonItem
            self.view.layoutSubviews()
        } else if (editedContentsTextView && settedOptions && titleTextField.text?.count ?? 0 < 3)
                    || (editedContentsTextView && settedOptions && contentsTextView.text.count < 5) {
            self.navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
            self.view.layoutSubviews()
        }
    }

}

extension CreatePartyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text else { return true }
        let newLength = str.count + string.count - range.length
        
        return newLength <= 10
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
            editedContentsTextView = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        editedContentsTextView = true
        if settedOptions
            && editedContentsTextView
            && contentsTextView.text.count >= 5
            && titleTextField.text?.count ?? 0 >= 3 {
            navigationItem.rightBarButtonItem = activatedRightBarButtonItem
            view.layoutSubviews()
        } else if (editedContentsTextView && settedOptions && contentsTextView.text.count < 5)
                    || (editedContentsTextView && settedOptions && titleTextField.text?.count ?? 0 < 3) {
            navigationItem.rightBarButtonItem = deactivatedRightBarButtonItem
            view.layoutSubviews()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        
        return newLength <= 100
    }
}

//
//  PartyNameVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit

class PartyNameViewController: UIViewController {

    // MARK: - SubViews
    
    /* titleLabel: 파티 이름 입력하기 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 이름 입력하기"
        label.font = .customFont(.neoMedium, size: 18)
        label.textColor = .black
        return label
    }()
    
    /* backbutton */
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    /* 파티 채팅방 이름 입력하는 텍스트 필드 */
    let partyNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "10글자 이내로 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        textField.makeBottomLine(248)
        textField.font = .customFont(.neoMedium, size: 15)
        textField.textColor = .init(hex: 0x5B5B5B)
        textField.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        return textField
    }()
    
    /* 추후 수정이 불가합니다 */
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "추후 수정이 불가합니다"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xA8A8A8)
        return label
    }()
    
    /* 완료 버튼 */
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setDeactivatedNextButton()
        button.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 2/2 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "2/2"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Properties
    
    var dormitoryInfo: DormitoryNameResult?
    
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
            make.height.equalTo(294)
        }
    }
    
    private func addSubViews() {
        [
            titleLabel, backButton,
            partyNameTextField,
            guideLabel,
            confirmButton,
            pageLabel
        ].forEach { view.addSubview($0) }
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
        
        partyNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(37)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(248)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
            make.width.equalTo(262)
            make.height.equalTo(51)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalTo(confirmButton.snp.top).offset(-23)
            make.centerX.equalToSuperview()
        }
    }
    
    /* 완료 버튼 누르면 실행되는 함수 -> 파티 생성 API 호출, 홈 화면으로 */
    @objc
    private func tapConfirmButton() {
        if let chatRoomName = partyNameTextField.text {
            CreateParty.chatRoomName = chatRoomName
        }
        
        // api 호출
        if let title = CreateParty.title,
           let content = CreateParty.content,
           let orderTime = CreateParty.orderTime,
           let maxMatching = CreateParty.maxMatching,
           let foodCategory = CreateParty.foodCategory,
           let latitude = CreateParty.latitude,
           let longitude = CreateParty.longitude,
           let url = CreateParty.url,
           let bank = CreateParty.bank,
           let accountNumber = CreateParty.accountNumber,
           let chatRoomName = CreateParty.chatRoomName {
            let input = CreatePartyInput(
                title: title,
                content: content,
                orderTime: orderTime,
                maxMatching: maxMatching,
                foodCategory: foodCategory,
                latitude: latitude,
                longitude: longitude,
                storeUrl: url,
                hashTag: CreateParty.hashTag ?? false,
                bank: bank,
                accountNumber: accountNumber,
                chatRoomName: chatRoomName)
            print("DEBUG: 파티 생성 요청 인풋", input)

            CreatePartyViewModel.registerParty(dormitoryId: dormitoryInfo?.id ?? 1, input) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showToast(viewController: self, message: "파티 생성을 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor)
                }
            }
        }
    }
    
    /* 백버튼 눌렀을 때 실행 -> 이전 화면으로 돌아간다 */
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @objc
    private func changeValueTitleTextField() {
        if partyNameTextField.text?.count ?? 0 >= 1 {
            confirmButton.setActivatedNextButton()
        }
    }
}


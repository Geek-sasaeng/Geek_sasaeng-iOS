//
//  BankAccountVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/07.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift
import SnapKit
import Then

class BankAccountViewController: UIViewController {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var dormitoryInfo: DormitoryNameResult?
    
    // 프로토콜의 함수를 실행하기 위해 delegate를 설정
    var delegate: UpdateDeliveryDelegate?
    let db = Firestore.firestore()
    let settings = FirestoreSettings()

    // MARK: - SubViews
    
    /* titleLabel: 계좌번호 입력하기 */
    let titleLabel = UILabel().then {
        $0.text = "계좌번호 입력하기"
        $0.font = .customFont(.neoMedium, size: 18)
        $0.textColor = .black
    }
    
    /* backbutton */
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.tintColor = UIColor(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    /* 은행 이름 입력하는 텍스트 필드 */
    lazy var bankTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "은행을 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        $0.delegate = self
    }
    
    /* 계좌 번호 입력하는 텍스트 필드 */
    lazy var accountNumberTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "(- 제외) 계좌번호를 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
        $0.delegate = self
    }
    
    /* 완료 버튼 */
    lazy var confirmButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setDeactivatedNextButton()
        $0.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setFirestore()
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setFirestore() {
        settings.isPersistenceEnabled = false
        db.settings = settings
        db.clearPersistence()
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.29)
            make.height.equalTo(screenHeight / 2.48)
        }
    }
    
    private func addSubViews() {
        [
            titleLabel, backButton,
            bankTextField,
            accountNumberTextField,
            confirmButton
        ].forEach { view.addSubview($0) }
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
        
        bankTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(screenHeight / 23.02)
            make.left.equalToSuperview().inset(screenWidth / 13.55)
            make.width.equalTo(screenWidth / 1.58)
        }
        accountNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(bankTextField.snp.bottom).offset(screenHeight / 28.4)
            make.left.equalToSuperview().inset(screenWidth / 13.55)
            make.width.equalTo(screenWidth / 1.58)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(screenHeight / 24.34)
            make.width.equalTo(screenWidth / 1.5)
            make.height.equalTo(screenHeight / 16.7)
        }
    }
    
    // MARK: - @objc Functions
    
    /* 완료 버튼 누르면 실행되는 함수 -> 파티 생성 API 호출, 홈 화면으로 */
    @objc
    private func tapConfirmButton() {
        if let bank = bankTextField.text,
           let accountNumber = accountNumberTextField.text {
            CreateParty.bank = bank
            CreateParty.accountNumber = accountNumber
        }
        
        guard let title = CreateParty.title,
              let content = CreateParty.content,
              let orderTime = CreateParty.orderTime,
              let maxMatching = CreateParty.maxMatching,
              let foodCategory = CreateParty.foodCategory,
              let latitude = CreateParty.latitude,
              let longitude = CreateParty.longitude,
              let url = CreateParty.url,
              let bank = CreateParty.bank,
              let accountNumber = CreateParty.accountNumber else { return }
        
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
            chatRoomName: title)
        print("DEBUG: 파티 생성 요청 인풋", input)
        
        /* 배달 파티 생성 API 호출 */
        CreatePartyViewModel.registerParty(dormitoryId: dormitoryInfo?.id ?? 1, input) { [self] isSuccess, model in
            // 배달파티 생성 성공
            if isSuccess {
                guard let model = model,
                      let result = model.result,
                      let accountNumber = result.accountNumber,
                      let bank = result.bank,
                      let category = result.foodCategory,
                      let maxMatching = result.maxMatching,
                      let title = result.chatRoomName else { return }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.locale = Locale(identifier: "ko_KR")
                
                // 파티 생성 성공 시, 파티 채팅방도 생성한다!
                // 채팅방 생성 API 요청
                ChatAPI.requestCreateChatRoom(
                    CreateChatRoomInput(accountNumber:accountNumber,
                                        bank: bank,
                                        category: category,
                                        maxMatching: maxMatching,
                                        title: title,
                                        deliveryPartyId: model.result?.id)
                ) { isSuccess, result in
                    guard let result = result else { return }
                    if isSuccess {
                        print("DEBUG: 채팅방 생성 성공 \(result)")
                    } else {
                        print("DEBUG: 채팅방 생성 실패 \(result)")
                    }
                }
                
                /* 생성된 파티의 상세 조회 화면으로 이동 */
                guard let partyId = result.id,
                      let dormitoryInfo = dormitoryInfo else { return }
                let partyVC = PartyViewController(partyId: partyId, dormitoryInfo: dormitoryInfo, isFromCreated: true)
                
                // delegate로 DeliveryVC를 넘겨줌
                partyVC.delegate = delegate
                
                var vcArray = self.navigationController?.viewControllers
                vcArray!.removeLast()
                vcArray!.append(partyVC)
                self.navigationController?.setViewControllers(vcArray!, animated: false)
                self.navigationController?.popViewController(animated: true)
            } else {
                // 배달파티 생성 실패
                self.showToast(viewController: self, message: "파티 생성을 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 250)
            }
        }
    }
    
    /* 백버튼 눌렀을 때 실행 -> 이전 화면으로 돌아간다 */
    @objc
    private func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
        NotificationCenter.default.post(name: NSNotification.Name("TapBackButtonFromBankAccountVC"), object: "true")
    }
    
    @objc
    private func changeValueTitleTextField() {
        guard let bankText = bankTextField.text,
              let accountNumberText = accountNumberTextField.text else { return }
        
        if bankText.count >= 1
            && accountNumberText.count >= 1
            && accountNumberText.isValidAccountNum() {
            confirmButton.setActivatedNextButton()
        } else {
            confirmButton.setDeactivatedButton()
        }
    }
}

extension BankAccountViewController: UITextFieldDelegate {
    
    /* 은행 이름, 계좌번호 글자수 제한 걸어놓은 함수 */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let bankName = bankTextField.text,
              let accountNum = accountNumberTextField.text
        else { return false }
        
        // 최대 글자수 이상을 입력한 이후에는 다른 글자를 추가할 수 없게끔 설정
        // 은행 이름 최대 10글자 제한
        let bankMax = 10
        if bankName.count > bankMax && range.length == 0 {
            return false
        }
        
        // 계좌번호는 최대 15글자 제한
        let accountMax = 15
        if accountNum.count > accountMax && range.length == 0 {
            return false
        }
        return true
    }
}

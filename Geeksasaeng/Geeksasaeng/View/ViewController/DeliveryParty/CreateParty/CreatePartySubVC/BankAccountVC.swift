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
    }
    
    /* 계좌 번호 입력하는 텍스트 필드 */
    lazy var accountNumberTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "계좌번호를 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xD8D8D8),
                         NSAttributedString.Key.font: UIFont.customFont(.neoRegular, size: 15)]
        )
        $0.makeBottomLine()
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0x5B5B5B)
        $0.addTarget(self, action: #selector(changeValueTitleTextField), for: .editingChanged)
    }
    
    /* 추후 수정이 가능합니다 */
    let guideLabel = UILabel().then {
        $0.text = "추후 수정이 가능합니다"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xA8A8A8)
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
    
    /* pageLabel: 1/2 */
    let pageLabel = UILabel().then {
        $0.text = "1/2"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xD8D8D8)
    }
    
    // MARK: - Properties
    
    var dormitoryInfo: DormitoryNameResult?
    // 프로토콜의 함수를 실행하기 위해 delegate를 설정
    var delegate: UpdateDeliveryDelegate?
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
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
            make.width.equalTo(304)
            make.height.equalTo(343)
        }
    }
    
    private func addSubViews() {
        [
            titleLabel, backButton,
            bankTextField,
            accountNumberTextField,
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
        
        bankTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(37)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(248)
        }
        accountNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(bankTextField.snp.bottom).offset(30)
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
                      let uuid = result.uuid,
                      let title = result.chatRoomName,
                      let bank = result.bank,
                      let accountNumber = result.accountNumber,
                      let maxMatching = result.maxMatching else { return }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.locale = Locale(identifier: "ko_KR")
                
                // 파티 생성 성공 시, 파티 채팅방도 생성한다!
                db.collection("Rooms").document(uuid).setData(
                    ["roomInfo" :
                        [
                            "title": title,
                            "participants": [["participant": LoginModel.nickname as Any, "enterTime": formatter.string(from: Date()), "isRemittance": true]],  // 방장은 무조건 송금 완료로 둔다.
                            "maxMatching": maxMatching,
                            "category": "배달파티",
                            "bank": bank,
                            "accountNumber": accountNumber,
                            "isFinish": false,
                            "updatedAt": formatter.string(from: Date())
                        ]
                    ]) { err in
                        if let e = err {
                            print(e.localizedDescription)
                            // TODO: 파티 생성은 잘 됐는데, 파티 채팅방 생성이 안 될 경우에는 어떻게 해야하나...?
                            print("Seori Test: 채팅방 생성 실패")
                            // 배달 채팅방 생성 실패
                            self.showToast(viewController: self, message: "채팅방 생성이 실패하였습니다", font: .customFont(.neoBold, size: 13), color: .mainColor)
                        } else {
                            // 배달 채팅방 생성 성공
                            print("DEBUG: 배달 채팅방 생성 완료")
                            print(uuid)
                            
                            // 방장 참가 시스템 메세지 업로드
                            self.db.collection("Rooms").document(uuid).collection("Messages").document(UUID().uuidString).setData([
                                "content": "\(LoginModel.nickname ?? "홍길동")님이 입장하셨습니다",
                                "nickname": LoginModel.nickname ?? "홍길동",
                                "userImgUrl": LoginModel.userImgUrl ?? "https://",
                                "time": formatter.string(from: Date()),
                                "isSystemMessage": true,
                                "readUsers": [LoginModel.nickname ?? "홍길동"]
                            ]) { error in
                                if let e = error {
                                    print(e.localizedDescription)
                                } else {
                                    print("Success save data")
                                }
                            }
                        }
                    }
                
                /* 생성된 파티의 상세 조회 화면으로 이동 */
                guard let partyId = result.id,
                      let dormitoryInfo = dormitoryInfo else { return }
                let createdData = DeliveryListDetailModelResult(
                    chief: result.chief,
                    chiefId: result.chiefId,
                    chiefProfileImgUrl: result.chiefProfileImgUrl,
                    content: result.content,
                    currentMatching: result.currentMatching,
                    foodCategory: result.foodCategory,
                    hashTag: result.hashTag,
                    id: result.id,
                    latitude: result.latitude,
                    longitude: result.longitude,
                    matchingStatus: result.matchingStatus,
                    maxMatching: result.maxMatching,
                    orderTime: result.orderTime,
                    title: result.title,
                    updatedAt: result.updatedAt,
                    storeUrl: result.storeUrl,
                    authorStatus: result.authorStatus,
                    dormitory: result.dormitoryId,
                    uuid: result.uuid,
                    belongStatus: result.belongStatus)
                let partyVC = PartyViewController(partyId: partyId, dormitoryInfo: dormitoryInfo, createdData: createdData)
                
                // delegate로 DeliveryVC를 넘겨줌
                partyVC.delegate = delegate
                
                var vcArray = self.navigationController?.viewControllers
                vcArray!.removeLast()
                vcArray!.append(partyVC)
                self.navigationController?.setViewControllers(vcArray!, animated: false)
                self.navigationController?.popViewController(animated: true)
            } else {
                // 배달파티 생성 실패
                self.showToast(viewController: self, message: "파티 생성을 실패하였습니다", font: .customFont(.neoBold, size: 13), color: .mainColor)
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
                
        if bankText.count >= 1 && accountNumberText.count >= 1 {
            confirmButton.setActivatedNextButton()
        }
    }
}

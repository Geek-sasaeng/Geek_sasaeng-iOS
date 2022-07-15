//
//  AgreementVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/06.
//

import UIKit
import SnapKit

class AgreementViewController: UIViewController {
    
    // MARK: - SubViews
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    var remainBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xF2F2F2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    var progressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoTop"))
        return imageView
    }()
    
    var remainIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoBottom"))
        return imageView
    }()
    
    var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendRegisterRequest), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    /* 이전 화면에서 받아온 데이터들 */
    var pwCheckData: String? = nil
    var email: String? = nil
    var idData: String? = nil
    var nickNameData: String? = nil
    var pwData: String? = nil
    var phoneNum: String? = nil
    var university: String? = nil
    
    var isFromNaverRegister = false
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Setting Function
    
    func addSubViews() {
        view.addSubview(progressBar)
        view.addSubview(remainBar)
        view.addSubview(progressIcon)
        view.addSubview(remainIcon)
        view.addSubview(completeButton)
    }
    
    func setLayouts() {
        /* progress Bar */
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(UIScreen.main.bounds.width - 67)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(25)
        }
        
        /* remain Bar */
        remainBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(progressBar.snp.right)
            make.right.equalToSuperview().inset(25)
        }
        
        progressIcon.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.top.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).inset(15)
        }
        
        remainIcon.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(36)
            make.top.equalTo(progressBar.snp.top).offset(-8)
            make.right.equalTo(remainBar.snp.right).offset(3)
        }
        
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    // MARK: - Functions

    /* 회원가입 Request 보내는 함수 */
    @objc private func sendRegisterRequest() {
        if isFromNaverRegister { // naver 회원가입인 경우
            phoneNum = phoneNum?.replacingOccurrences(of: "-", with: "")
            if let checkPassword = self.pwCheckData,
               let email = self.email,
               let loginId = self.idData,
               let nickname = self.nickNameData,
               let password = self.pwData,
               let phoneNumber = self.phoneNum,
               let universityName = self.university {
                print(checkPassword)
                print(email)
                print(loginId)
                print(nickname)
                print(password)
                print(phoneNumber)
                print(universityName)
                let input = RegisterInput(checkPassword: checkPassword,
                                          email: email,
                                          informationAgreeStatus: "Y",
                                          loginId: loginId,
                                          nickname: nickname,
                                          password: password,
                                          phoneNumber: phoneNumber,
                                          universityName: universityName)
                
                RegisterAPI.registerUserFromNaver(self, input)
            }
        } else { // naver 회원가입이 아닌 경우
            // Request 생성.
            // 최종적으로 데이터 전달 (확인비번, 이메일, 동의여부, 아이디, 닉네임, pw, 폰번호, 학교이름) 총 8개
            /// 순서가 이런 이유는 나도 모름... 회원가입 API Req 바디 모양대로 넣었어
            if let idData = self.idData,
               let pwData = self.pwData,
               let pwCheckData = self.pwCheckData,
               let nickNameData = self.nickNameData,
               let univ = self.university,
               let email = self.email,
               let phoneNum = self.phoneNum
    //           let agreeStatus = self.isArgree   -> TODO: 나중에 이용약관 추가됐을 때 동의했느냐, 안 했느냐 판단해서 추가
            {
                let input = RegisterInput(checkPassword: pwCheckData,
                                          email: email,
                                          informationAgreeStatus: "Y",
                                          loginId: idData,
                                          nickname: nickNameData,
                                          password: pwData,
                                          phoneNumber: phoneNum,
                                          universityName: univ)
                
                RegisterAPI.registerUser(self, input)
            }
        }
    }
    
    public func showHomeView() {
        let deliveryVC = DeliveryViewController()
        deliveryVC.modalTransitionStyle = .crossDissolve
        deliveryVC.modalPresentationStyle = .fullScreen
        present(deliveryVC, animated: true)
    }
    
    public func showDomitoryView() {
        let dormitoryVC = DormitoryViewController()
        dormitoryVC.modalTransitionStyle = .crossDissolve
        dormitoryVC.modalPresentationStyle = .fullScreen
        present(dormitoryVC, animated: true)
    }
}

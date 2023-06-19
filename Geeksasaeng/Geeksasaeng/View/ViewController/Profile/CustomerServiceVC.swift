//
//  CustomerServiceVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/20.
//

import UIKit
import SnapKit
import Then
import KakaoSDKTalk
import SafariServices

class CustomerServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    var safariVC: SFSafariViewController?
    
    // MARK: - SubViews
    
    let termsOfUseAgreementLabel = UILabel().then {
        $0.text = "서비스 이용약관 동의"
        $0.font = .customFont(.neoMedium, size: 15)
    }
    
    let personalInfoAgreementLabel = UILabel().then {
        $0.text = "개인정보 수집 및 이용동의"
        $0.font = .customFont(.neoMedium, size: 15)
    }
    
    lazy var termsOfUseAgreementButton = UIButton().then {
        $0.setImage(UIImage(named: "AgreementArrow"), for: .normal)
        $0.addTarget(self, action: #selector(tapTermsOfUseAgreementButton), for: .touchUpInside)
    }
    
    lazy var personalInfoAgreementButton = UIButton().then {
        $0.setImage(UIImage(named: "AgreementArrow"), for: .normal)
        $0.addTarget(self, action: #selector(tapPersonalInfoAgreementButton), for: .touchUpInside)
    }
    
    lazy var enquireKakaoView = UIView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .mainColor
        
        let titleLabel = UILabel().then {
            $0.text = "더 궁금한 점이 있나요?"
            $0.font = .customFont(.neoBold, size: 16)
            $0.textColor = .white
        }
        
        let enquireLabel = UILabel().then {
            $0.text = "카카오톡 문의하기"
            $0.font = .customFont(.neoMedium, size: 13)
            $0.textColor = .white
        }
        
        lazy var goToKakaoButton = UIButton().then {
            $0.setImage(UIImage(named: "KakaoArrowIcon"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapGoToKakaoButton), for: .touchUpInside)
        }
        
        let backgroundImage = UIImageView().then {
            $0.image = UIImage(named: "KakaoBackground")
        }
        
        [ titleLabel, enquireLabel, goToKakaoButton, backgroundImage ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.left.equalToSuperview().inset(18)
        }
        enquireLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(39)
        }
        goToKakaoButton.snp.makeConstraints { make in
            make.centerY.equalTo(enquireLabel.snp.centerY)
            make.right.equalToSuperview().inset(15)
        }
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).offset(-5)
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavigationBar()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCustomNavigationBar()
    }
    
    // MARK: - Functions
    
    private func setNavigationBar() {
        self.navigationItem.title = "고객 센터"
        self.navigationItem.titleView?.tintColor = .init(hex: 0x2F2F2F)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(tapBackButton(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func addSubViews() {
        [
            termsOfUseAgreementLabel, personalInfoAgreementLabel,
            termsOfUseAgreementButton, personalInfoAgreementButton,
            enquireKakaoView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        termsOfUseAgreementLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalToSuperview().inset(24)
        }
        termsOfUseAgreementButton.snp.makeConstraints { make in
            make.centerY.equalTo(termsOfUseAgreementLabel.snp.centerY)
            make.right.equalToSuperview().inset(31)
        }
        
        personalInfoAgreementLabel.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseAgreementLabel.snp.bottom).offset(40)
            make.left.equalTo(termsOfUseAgreementLabel.snp.left)
        }
        personalInfoAgreementButton.snp.makeConstraints { make in
            make.centerY.equalTo(personalInfoAgreementLabel.snp.centerY)
            make.right.equalTo(termsOfUseAgreementButton.snp.right)
        }
        
        enquireKakaoView.snp.makeConstraints { make in
            make.width.equalTo(314)
            make.height.equalTo(92)
            make.top.equalTo(personalInfoAgreementLabel.snp.bottom).offset(38)
            make.left.right.equalToSuperview().inset(23)
        }
    }
    
    // MARK: - objc Functions
    
    @objc
    private func tapBackButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc
    private func tapGoToKakaoButton() {
        self.safariVC = SFSafariViewController(url: KakaoSDKTalk.TalkApi.shared.makeUrlForChannelChat(channelPublicId: "_Sxolhxj")!)
        guard self.safariVC != nil else { return }
        
        self.safariVC?.modalTransitionStyle = .crossDissolve
        self.safariVC?.modalPresentationStyle = .overCurrentContext
        self.present(self.safariVC!, animated: true)
    }
    
    @objc
    private func tapTermsOfUseAgreementButton() {
        let termsOfUseAgreementOfProfileVC = TermsOfUseAgreementOfProfileViewController()
        self.navigationController?.pushViewController(termsOfUseAgreementOfProfileVC, animated: true)
    }
    
    @objc
    private func tapPersonalInfoAgreementButton() {
        let personalInfoAgreementOfProfileVC = PersonalInfoAgreementOfProfileViewController()
        self.navigationController?.pushViewController(personalInfoAgreementOfProfileVC, animated: true)
    }
}

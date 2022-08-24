//
//  TermsOfUseAgreementVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/01.
//

import UIKit
import SnapKit

protocol TermsOfUseAgreementDelegate {
    func termsOfUseAgreement(isTrue: Bool)
}

class TermsOfUseAgreementViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var agreementView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        
        let infoLabel: UILabel = {
            let label = UILabel()
            label.font = .customFont(.neoMedium, size: 16)
            label.textColor = .white
            label.text = "개인정보 수집 및 이용동의"
            return label
        }()
        
        let agreementLabel: UILabel = {
            let label = UILabel()
            label.font = .customFont(.neoBold, size: 16)
            label.textColor = .white
            label.text = "동의"
            return label
        }()
        
        let agreementArrow: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "DetailAgreementArrow")
            return imageView
        }()
        
        [infoLabel, agreementLabel, agreementArrow].forEach {
            view.addSubview($0)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(29)
        }
        agreementArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(29)
        }
        agreementLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(agreementArrow.snp.left).offset(-11)
        }
        
        view.isUserInteractionEnabled = true
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAgreementView))
        view.addGestureRecognizer(viewTapGesture)
        
        return view
    }()
    
    var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PersonalInfoAgreement")
        return imageView
    }()
    
    
    // MARK: - Properties
    var TermsOfUseAgreementDelegate: TermsOfUseAgreementDelegate?
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAttributes()
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    private func setAttributes() {
        navigationItem.title = "약관 동의"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func addSubViews() {
        contentsView.addSubview(contentImageView)
        scrollView.addSubview(contentsView)
        
        containerView.addSubview(scrollView)
        containerView.addSubview(agreementView)
        
        view.addSubview(containerView)
    }
    
    private func setLayouts() {
        containerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        contentsView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(contentImageView.snp.bottom).offset(30)
        }
        
        agreementView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 29)
        }
    }
    
    
    // MARK: - Functions
    
    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapAgreementView() {
        print("Gesture works")
        TermsOfUseAgreementDelegate?.termsOfUseAgreement(isTrue: true)
        navigationController?.popViewController(animated: true)
    }
}

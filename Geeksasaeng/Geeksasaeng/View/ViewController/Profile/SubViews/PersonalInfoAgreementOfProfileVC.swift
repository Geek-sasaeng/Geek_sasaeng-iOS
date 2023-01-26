//
//  PersonalInfoAgreementOfProfileVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/20.
//

import UIKit
import SnapKit
import Then

class PersonalInfoAgreementOfProfileViewController: UIViewController {
    // MARK: - SubViews
    let scrollView = UIScrollView()
    
    let contentsView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .none
        $0.isUserInteractionEnabled = true
    }
    
    var contentImageView = UIImageView().then {
        $0.image = UIImage(named: "PersonalInfoAgreement")
    }

    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributes()
        addSubViews()
        setLayouts()
        addRightSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func setAttributes() {
        navigationItem.title = "서비스 이용약관 동의"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(self.back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func addSubViews() {
        contentsView.addSubview(contentImageView)
        scrollView.addSubview(contentsView)
        containerView.addSubview(scrollView)
        
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
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 12.7)
        }
    }
}

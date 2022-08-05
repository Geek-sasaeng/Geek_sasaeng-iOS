//
//  SplashVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/04.
//

import UIKit

/* 스플래쉬 정적 화면 */
/* MVP에 안 쓰는 걸로 -> 이유: 애니메이션 영상이랑 위치 안 맞음 + 애니메이션 마지막 화면이랑 같아서 빼기로 함 */
class SplashViewController: UIViewController {

    // MARK: - Subviews
    
    let appLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppLogo"))
        return imageView
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "쉽고 편리한 연결 메이트"
        label.font = .customFont(.gmarketSansMedium, size: 18)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "긱사생"
        label.font = .customFont(.gmarketSansMedium, size: 32)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        setLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 화면이 보이고 나서 1.5초 뒤에 로그인 화면으로 전환
        sleep(UInt32(1.5))
        showLoginView()
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            appLogoImageView,
            subTitleLabel,
            titleLabel
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        appLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.centerY).offset(-80)
            make.width.height.equalTo(209)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLogoImageView.snp.bottom).offset(0)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(19)
        }
    }
    
    private func showLoginView() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true)
    }
}

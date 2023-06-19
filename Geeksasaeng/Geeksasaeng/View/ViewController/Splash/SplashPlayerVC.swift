//
//  SplashPlayerVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/05.
//

import UIKit
import Lottie

/* 스플래쉬 애니메이션 */
class SplashPlayerViewController: UIViewController {
    
    // MARK: - SubViews
    
    // Lottie AnimationView 생성
    let animationView = LottieAnimationView(name: "splash").then {
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 레이아웃 설정
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 애니메이션 재생 (애니메이션 재생모드 미 설정시 1회)
        animationView.play { (finished) in
            // 끝나면 로그인뷰로 이동
            self.showLoginView()
        }
    }
    
    // MARK: - Functions
    
    private func showLoginView() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true)
    }
}

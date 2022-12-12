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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lottie AnimationView 생성
        let animationView = LottieAnimationView(name: "splash")

        // 메인 뷰에 삽입
        view.addSubview(animationView)
        animationView.frame = animationView.superview!.bounds
        animationView.contentMode = .scaleAspectFit

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

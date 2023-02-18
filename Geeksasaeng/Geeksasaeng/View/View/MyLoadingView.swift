//
//  MyLoadingView.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/02/10.
//

import UIKit
import Lottie
import SnapKit

// 네트워크 작업 대기 시에 띄우는 로딩 애니메이션 뷰 클래스
final class MyLoadingView: UIView {
    
    // MARK: - Properties
    
    // 싱글톤 패턴
    static let shared = MyLoadingView()
    
    // MARK: - SubViews
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading")
        view.loopMode = .loop
        return view
    }()
    
    // MARK: - Initialization
    
    private init() {
        super.init(frame: .zero)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.loadingView)
        loadingView.frame = loadingView.superview!.bounds
        
        self.contentView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
        }
        self.loadingView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    // 로딩 애니메이션 띄우기
    func show() {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive {
                    guard let window = ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window else { fatalError() }
                    window?.addSubview(self)
                    window?.bringSubviewToFront(self)
                    window?.endEditing(true)
                    break
                }
            }
        } else {
            guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
            guard let window = appDelegate.window else { fatalError() }
            window?.addSubview(self)
            window?.bringSubviewToFront(self)
            window?.endEditing(true)
        }
        
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        
        self.loadingView.play()
        UIView.animate(
            withDuration: 0.7,
            animations: { self.contentView.alpha = 1 }
        )
    }
    
    // 로딩 애니메이션 내리기
    func hide(completion: @escaping () -> () = {}) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
}

//
//  SplashPlayerVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/05.
//

import UIKit
import AVKit
import AVFoundation

/* 스플래쉬 애니메이션 */
class SplashPlayerViewController: AVPlayerViewController {
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 설정
        view.backgroundColor = .init(hex: 0x29b7e2)
        // 유저가 동영상 컨트롤 할 수 있는 거 다 없앰
        self.showsPlaybackControls = false
        self.showsTimecodes = false
        // 비디오 사이즈가 화면에 꽉 차게 설정
        self.videoGravity = .resizeAspectFill
        
        // 스플래쉬 애니메이션 재생
        playVideo()
    }
    
    // MARK: - Functions
    
    /* 스플래쉬 애니메이션 재생 */
    private func playVideo() {
        print("func : play video")
        
        // 비디오 path 설정.
        guard let path = Bundle.main.path(forResource: "Splash", ofType: "mp4") else {
            debugPrint(".mp4 not found")
            return
        }

        // player 생성.
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player = player
        
        // 비디오가 끝났는지 확인하는 옵저버 생성.
        NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        player.play()
    }
    
    /* 애니메이션 다 끝났으면 playerController를 dismiss 시키고 LoginVC로 이동 */
    @objc func finishVideo() {
        print("func : finishVideo")
        dismiss(animated: false) {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true)
        }
    }
}

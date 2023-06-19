//
//  ImageCellVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/25.
//

import UIKit
import SnapKit
import Then

// 채팅 이미지 상세보기 화면
class ImageCellViewController: UIViewController {
    
    // MARK: - Properties
    
    var blurView: UIVisualEffectView?
    var nickname: String?
    var date: String?
    var imageUrl: URL?
    
    var recognizerScale: CGFloat = 1.0
    var maxScale: CGFloat = 1.5
    var minScale: CGFloat = 1.0
    
    // MARK: - SubViews
    
    let imageMessageExpansionNicknameLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 14)
        $0.textColor = .white
    }
    
    let imageMessageExpansionDateLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 12)
        $0.textColor = .white
    }
    
    let imageMessageExpansionTimeLabel = UILabel().then {
        $0.font = .customFont(.neoMedium, size: 12)
        $0.textColor = .white
    }
    
    let imageMessageExpansionImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView = setMoreDarkBlurView()
        setAttributes()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapVisualEffectView))
        blurView?.isUserInteractionEnabled = true
        blurView?.addGestureRecognizer(gesture)
        
        imageMessageExpansionNicknameLabel.text = nickname
        
        guard let str = date else { return }
        imageMessageExpansionDateLabel.text = str.substring(start: 0, end: 10)
        imageMessageExpansionTimeLabel.text = str.substring(start: 11, end: 19)
        
        imageMessageExpansionImageView.kf.setImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                // 수신한 이미지의 가로 세로 크기
                let width = value.image.size.width
                let height = value.image.size.height
                
                // 이미지를 축소하기 위해 비율 계산
                let reductionRatio = (UIScreen.main.bounds.width - 30) / width
                
                // 제약조건 업데이트
                self.imageMessageExpansionImageView.snp.remakeConstraints { make in
                    // 가로와 세로를 같은 비율로 축소한다
                    make.width.equalTo(width * reductionRatio)
                    make.height.equalTo(height * reductionRatio)
                }
            case .failure(let error):
                print("kingfisher image load error: ", error)
            }
        }
    }
    
    private func addSubViews() {
        [ imageMessageExpansionNicknameLabel, imageMessageExpansionDateLabel, imageMessageExpansionTimeLabel,
          imageMessageExpansionImageView ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        imageMessageExpansionNicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(78)
            make.centerX.equalToSuperview()
        }
        
        imageMessageExpansionDateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageMessageExpansionNicknameLabel.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        imageMessageExpansionTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageMessageExpansionDateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        // TODO: - height가 매우 긴 이미지의 경우 labels을 가리는 문제가 있음
        imageMessageExpansionImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions
    
    @objc private func tapVisualEffectView() {
        dismiss(animated: true)
    }
    
    @objc
    private func doPinch(_ pinch: UIPinchGestureRecognizer) {
//        imageMessageExpansionImageView.transform = imageMessageExpansionImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
//        pinch.scale = 1
        
        if pinch.state == .began || pinch.state == .changed {
            if (recognizerScale < maxScale && pinch.scale > 1.0) { // 확대
                imageMessageExpansionImageView.transform = (imageMessageExpansionImageView.transform).scaledBy(x: pinch.scale, y: pinch.scale)
                recognizerScale *= pinch.scale
                pinch.scale = 1.0
            } else if (recognizerScale > minScale && pinch.scale < 1.0) { // 축소
                imageMessageExpansionImageView.transform = (imageMessageExpansionImageView.transform).scaledBy(x: pinch.scale, y: pinch.scale)
                recognizerScale *= pinch.scale
                pinch.scale = 1.0
            }
        }
    }
}

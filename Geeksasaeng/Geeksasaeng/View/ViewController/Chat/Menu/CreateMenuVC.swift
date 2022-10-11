//
//  CreateMenuVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/09/26.
//

import UIKit

import SnapKit
import Then

/* 나의 메뉴 입력하기 화면 */
class CreateMenuViewController: UIViewController {

    // MARK: - Subviews
    
    let completeLabel = UILabel().then {
        $0.text = "완료"
        $0.font = .customFont(.neoBold, size: 16)
        $0.textColor = .init(hex: 0xBABABA)
    }
    
    lazy var storeLinkView = UIView().then { view in
        view.backgroundColor = .init(hex: 0xF8F8F8)
        let storeViewLabel = UILabel().then {
            $0.text = "식당 보기"
            $0.font = .customFont(.neoMedium, size: 15)
            $0.textColor = .init(hex: 0x636363)
        }
        let storeLinkLabel = UILabel().then {
            $0.text = "https://www.youtube.com/"
            $0.font = .customFont(.neoMedium, size: 12)
            $0.textColor = .mainColor
        }
        lazy var arrowButton = UIButton().then {
            $0.setImage(UIImage(named: "ServiceArrow"), for: .normal)
            $0.addTarget(self, action: #selector(self.tapLinkArrow), for: .touchUpInside)
        }
        
        [ storeViewLabel, storeLinkLabel, arrowButton].forEach {
            view.addSubview($0)
        }
        storeViewLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
        }
        storeLinkLabel.snp.makeConstraints { make in
            make.left.equalTo(storeViewLabel.snp.right).offset(15)
            make.centerY.equalTo(storeViewLabel)
        }
        arrowButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(23)
            make.centerY.equalTo(storeLinkLabel)
        }
    }
    
    let guideLabel = UILabel().then {
        $0.text = "추후 추가/수정이 가능합니다"
        $0.font = .customFont(.neoMedium, size: 15)
        $0.textColor = .init(hex: 0xA8A8A8)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "나의 메뉴 입력하기"
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.setRightBarButton(UIBarButtonItem(customView: completeLabel), animated: true)
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            storeLinkView,
            guideLabel
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        storeLinkView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalTo(49)
        }
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(49)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions
    
    /* 이전 화면으로 돌아가기 */
    @objc
    private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapCompleteButton() {
        print("완료 버튼 클릭")
    }
    
    @objc
    private func tapLinkArrow() {
        print("화살표 버튼 클릭")
    }
}

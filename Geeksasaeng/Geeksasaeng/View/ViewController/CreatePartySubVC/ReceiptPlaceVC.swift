//
//  ReceiptPlaceVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit

class ReceiptPlaceViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 수령 장소 */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수령 장소"
        label.font = .customFont(.neoMedium, size: 18)
        return label
    }()
    
    /* backbutton */
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        return button
    }()
    
    /* nextButton: 다음 버튼 */
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setActivatedNextButton()
        button.addTarget(self, action: #selector(removeAllSubVC), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 4/4 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "4/4"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        setSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    private func setSubViews() {
        [titleLabel, backButton, confirmButton, pageLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalToSuperview().inset(31)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func removeAllSubVC() {
        NotificationCenter.default.post(name: NSNotification.Name("TapConfirmButton"), object: "true")
    }
}

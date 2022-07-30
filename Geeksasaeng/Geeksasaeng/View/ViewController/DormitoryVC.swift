//
//  DormitoryVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/10.
//

import UIKit
import SnapKit

// TODO: - 디자인 수정된 거에 맞춰서 다시 해야 됨
/* 회원가입 후, 첫 로그인 성공 시에 나오게 되는 기숙사 선택 화면 */
class DormitoryViewController: UIViewController {
    
    // MARK: - Properties
    
    var dormitoryNameArray: [DormitoryNameResult] = []
    
    // MARK: - Subviews
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        // TODO: 로그인 시 홍길동 말고 해당 유저의 닉네임으로 설정해야 함
        label.text = "홍길동님, 환영합니다"
        label.numberOfLines = 2
        label.font = .customFont(.neoBold, size: 32)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 어느 기숙사에 거주하고 계신가요?"
        label.numberOfLines = 2
        label.font = .customFont(.neoBold, size: 24)
        label.textColor = .init(hex: 0x2F2F2F)
        return label
    }()
    
    var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "*추후 프로필에서 기숙사를 변경하실 수 있습니다"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = .init(hex: 0xA8A8A8)
        return label
    }()
    
    var backgroundLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackgroundLogo")
        return imageView
    }()
    
    var dormitoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        // TODO: 학교 선택에 따른 기숙사 갯수 불러오기
//        pickerView.backgroundColor = .mainColor
        return pickerView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getDormitoryData()
        addSubViews()
        setLayouts()
        setPickerView()
    }
    
    // MARK: - Functions
    
    private func addSubViews() {
        [
            welcomeLabel,
            questionLabel,
            guideLabel,
            backgroundLogoImageView,
            dormitoryPickerView,
            startButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalToSuperview().inset(23)
            make.width.equalTo(148)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(68)
            make.left.equalToSuperview().inset(28)
            make.width.equalTo(195)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
        }
        
        backgroundLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(19)
            make.right.equalToSuperview()
        }
        
        dormitoryPickerView.snp.makeConstraints { make in
            make.centerY.equalTo(guideLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
        }
        
        startButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(51)
            make.height.equalTo(51)
        }
    }
    
    /* pickerView delegate 설정 */
    private func setPickerView() {
        dormitoryPickerView.delegate = self
        dormitoryPickerView.dataSource = self
    }
    
    /* 기숙사 이름 리스트 가져오기 */
    private func getDormitoryData() {
        // TODO: - 학교 이름 리스트 API 연동 후 수정 예정. 일단 1로 넣어둠
        DormitoryListViewModel.requestGetDormitoryList(self, universityId: 1) { result in
            self.dormitoryNameArray.append(contentsOf: result)
            // append 후에는 reload 필수. 안 하면 안 들어가있음.
            self.dormitoryPickerView.reloadAllComponents()
        }
    }
    
    /* 홈 화면으로 전환 */
    @objc private func tapStartButton() {
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension DormitoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // picker view의 component로 몇 개의 열을 쓸 것인지 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // picker view의 component로 몇 개의 행을 쓸 것인지 설정 -> 기숙사 이름 갯수만큼
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dormitoryNameArray.count
    }
    
    // Component의 높이 설정
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        47
    }
    
    // picker view의 각 행에 어떤 모양의 view를 둘 것인지 설정
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        
        let dormitoryNameLabel: UILabel = {
            let label = UILabel()
            label.font = .customFont(.neoMedium, size: 20)
            label.text = dormitoryNameArray[row].name
            return label
        }()
        
        // 선택된 행의 label 컬러를 다르게 주기 위해 설정
        if pickerView.selectedRow(inComponent: component) == row {
            dormitoryNameLabel.textColor = .mainColor
        } else {
            dormitoryNameLabel.textColor = .init(hex: 0x8C8C8C)
        }
        
        view.addSubview(dormitoryNameLabel)
        dormitoryNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }
    
    // picker view의 특정 행이 선택되었을 때마다 호출되는 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // component를 reload함으로써, viewForRow 함수를 재호출
        // 선택된 row의 텍스트 컬러만을 바꾸기 위해!
        pickerView.reloadAllComponents()
        
        print("DEBUG: ", dormitoryNameArray[row])
    }
}

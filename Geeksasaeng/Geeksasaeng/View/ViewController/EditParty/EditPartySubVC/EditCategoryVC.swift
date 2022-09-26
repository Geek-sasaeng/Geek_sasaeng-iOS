//
//  CategoryVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import Then

class EditCategoryViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 카테고리 선택 */
    let titleLabel = UILabel().then {
        $0.text = "카테고리 선택"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    /* category labels */
    let korean = UIButton()
    let western = UIButton()
    let chinese = UIButton()
    let japanese = UIButton()
    let snack = UIButton()
    let chicken = UIButton()
    let rawfish = UIButton()
    let fastfood = UIButton()
    let dessert = UIButton()
    let etc = UIButton()
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setDeactivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Properties
    var selectedCategory: UIButton?
    var data: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        setCategoryButtons()
        addSubViews()
        setLayouts()
        setDefaultValueOfButton()
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
    
    private func setCategoryButtons() {
        [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .customFont(.neoMedium, size: 14)
            $0.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
            $0.addTarget(self, action: #selector(tapCategoryButton(_:)), for: .touchUpInside)
        }
        
        korean.setTitle("한식", for: .normal)
        western.setTitle("양식", for: .normal)
        chinese.setTitle("중식", for: .normal)
        japanese.setTitle("일식", for: .normal)
        snack.setTitle("분식", for: .normal)
        chicken.setTitle("치킨/피자", for: .normal)
        rawfish.setTitle("회/돈까스", for: .normal)
        fastfood.setTitle("패스트 푸드", for: .normal)
        dessert.setTitle("디저트/음료", for: .normal)
        etc.setTitle("기타", for: .normal)
    }
    
    private func addSubViews() {
        [
            titleLabel, nextButton,
            korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(262)
            make.height.equalTo(51)
            make.bottom.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
        
        [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(126)
                make.height.equalTo(38)
            }
        }
        
        [korean, chinese, snack, rawfish, dessert].forEach {
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(21)
            }
        }
        
        [western, japanese, chicken, fastfood, etc].forEach {
            $0.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(21)
            }
        }
        
        [korean, western].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(23)
            }
        }
        
        [chinese, japanese].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(korean.snp.bottom).offset(7)
            }
        }
        
        [snack, chicken].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(chinese.snp.bottom).offset(7)
            }
        }
        
        [rawfish, fastfood].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(snack.snp.bottom).offset(7)
            }
        }
        
        [dessert, etc].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(rawfish.snp.bottom).offset(7)
            }
        }
    }
    
    private func setDefaultValueOfButton() {
        if let category = CreateParty.category {
            [korean, western, chinese, japanese, snack, chicken, rawfish, fastfood, dessert, etc].forEach {
                if category == $0.titleLabel?.text {
                    $0.setTitleColor(.white, for: .normal)
                    $0.backgroundColor = .mainColor
                    selectedCategory = $0
                    nextButton.setActivatedNextButton()
                }
            }
        }
    }
    
    @objc
    private func tapNextButton() {
        CreateParty.category = data
        
        // API Input에 저장
        switch data {
        case "한식":
            CreateParty.foodCategory = 1
        case "양식":
            CreateParty.foodCategory = 2
        case "중식":
            CreateParty.foodCategory = 3
        case "일식":
            CreateParty.foodCategory = 4
        case "분식":
            CreateParty.foodCategory = 5
        case "치킨/피자":
            CreateParty.foodCategory = 6
        case "회/돈까스":
            CreateParty.foodCategory = 7
        case "패스트 푸드":
            CreateParty.foodCategory = 8
        case "디저트/음료":
            CreateParty.foodCategory = 9
        case "기타":
            CreateParty.foodCategory = 10
        default:
            print("잘못된 카테고리입니다.")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TapEditCategoryButton"), object: "true")
    }

    @objc
    private func tapCategoryButton(_ sender: UIButton) {
        if selectedCategory != nil {
            selectedCategory?.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
            selectedCategory?.backgroundColor = UIColor(hex: 0xEFEFEF)
            selectedCategory = sender
        } else {
            selectedCategory = sender
        }
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = .mainColor
        
        nextButton.setActivatedNextButton()
        
        data = sender.titleLabel?.text
    }
}

//
//  ReportDetailEtcVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/22.
//

import UIKit
import SnapKit

class ReportDetailEtcViewController: UIViewController {
    
    // MARK: - Properties
    
    // 체크박스가 체크되었는지 확인하기 위해
    var isCheck: Bool = false
    
    // MARK: - SubViews
    
    var reportCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "기타 사유 선택"
        label.font = .customFont(.neoMedium, size: 16)
        label.textColor = .black
        return label
    }()
    
    let textViewPlaceHolder = "입력해주세요"
    lazy var reportTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.text = textViewPlaceHolder
        textView.textColor = .init(hex: 0xD8D8D8)
        textView.font = .customFont(.neoRegular, size: 15)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        return textView
    }()
    
    // 하단에 있는 신고하기 뷰
    lazy var reportBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        
        let reportLabel: UILabel = {
            let label = UILabel()
            label.text = "신고하기"
            label.textColor = .white
            label.font = .customFont(.neoBold, size: 20)
            return label
        }()
        view.addSubview(reportLabel)
        reportLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setAttributes()
        addSubViews()
        setLayouts()
        
        reportTextView.delegate = self
        // view에 탭 제스쳐 추가 -> 키보드 숨기려고
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    /* 뷰 생길 때 옵져버를 등록 */
    override func viewWillAppear(_ animated: Bool) {
        // selector: 옵져버 감지 시 실행할 함수
        // name: 옵져버가 감지할 것 -> 키보드가 나타나는지/숨겨지는지
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /* 뷰 사라질 때, 반드시 옵져버를 리무브 할 것! */
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        // 하단 탭바 숨기기
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
        /* Navigation Bar Attrs */
        self.navigationItem.title = "신고하기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func addSubViews() {
        [
            reportCategoryLabel,
            reportTextView,
            reportBarView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        reportCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.equalToSuperview().inset(29)
        }
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(reportCategoryLabel.snp.bottom).offset(23)
            make.left.right.equalToSuperview().inset(29)
            make.height.equalTo(100)
        }
        reportBarView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(55 + 20)    // 20은 safeAreaLayoutGuide 아래 빈 공간 가리기 위해 추가
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Objc Functions

    /* 키보드 숨기기 */
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
     /* 이전 화면으로 돌아가기 */
    @objc
    private func back(sender: UIBarButtonItem) {
        // 하단 탭바 다시 보이도록
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 이 사용자 차단하기 체크 박스 누르면 체크 모양 뜨도록 */
    @objc
    private func tapCheckBoxButton(_ sender: UIButton) {
        isCheck = !isCheck
        (isCheck) ? sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal) : sender.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    /* 키보드 올라올 때 실행되는 함수 */
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            // reportBarView의 y축을 키보드 높이만큼 올려준다
            UIView.animate(
                withDuration: 0.3, animations: {
                    self.reportBarView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 20)
                }
            )
        }
    }
    
    /* 키보드 내려갈 때 실행되는 함수 */
    @objc func keyboardDown() {
        // reportBarView 위치 제자리로
        self.reportBarView.transform = .identity
    }

}

// MARK: - UITextViewDelegate

extension ReportDetailEtcViewController: UITextViewDelegate {
    
    /* 텍스트뷰에 입력을 시작 할 때 실행 */
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 첫 입력이면 placeholder 지워주고 시작
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .init(hex: 0x5B5B5B)
        }
    }
    
    /* 텍스트뷰에 입력을 끝낼 때 실행 */
    func textViewDidEndEditing(_ textView: UITextView) {
        // 작성 끝났는데 내용이 없으면 placeholder 다시 만들어줌
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .init(hex: 0xD8D8D8)
        }
    }
    
    /* 텍스트뷰에 내용이 바뀔 때마다 실행, 최대 몇 글자까지 가능한지 적어두면 됨 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        // 공백 제외 최대 100글자
        guard characterCount <= 100 else { return false }

        return true
    }
}

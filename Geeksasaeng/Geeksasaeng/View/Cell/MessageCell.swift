//
//  MessageCell.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/06.
//

import UIKit
import SnapKit

class MessageCell: UICollectionViewCell {
    // MARK: - SubViews
    var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 16
        imageView.tintColor = .black
        return imageView
    }()
    
    var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.cornerRadius = 16
        imageView.tintColor = .black
        return imageView
    }()
    
    var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        view.layer.cornerRadius = 5
        return view
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.neoMedium, size: 15)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func addSubViews() {
        messageView.addSubview(messageLabel)
        
        [leftImageView, rightImageView, messageView].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        // messageView 안의 label
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        
        messageView.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.right.equalTo(rightImageView.snp.left).offset(-10)
            make.height.equalTo(39)
        }
    }
}

extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
        let optionss = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: optionss, attributes: [.font: font], context: nil)
        return estimatedFrame
    }
}

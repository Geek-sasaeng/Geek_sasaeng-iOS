//
//  UITapGestureRecognizer + Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2023/01/20.
//

import UIKit

/* UITapGesTureRecognizer를 생성할 때, selector 함수에 parameter를 전달하기 위한 custom class */
class UITapGestureRecognizerWithParam: UITapGestureRecognizer {
    var index: Int?
}

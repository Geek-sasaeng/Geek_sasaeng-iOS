//
//  UIImage+Extension.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/19.
//

import UIKit

extension UIImage {
    
    /* image size 재설정하는 함수 */
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

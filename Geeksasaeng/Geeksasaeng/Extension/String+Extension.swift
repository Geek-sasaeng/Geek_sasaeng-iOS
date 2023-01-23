//
//  String+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit
import Foundation

extension String {
    func isValidId() -> Bool {
        // 대문자 or 소문자, 숫자, 6-20자
        let idExpression = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{6,20}"
        let idValidation = NSPredicate.init(format: "SELF MATCHES %@", idExpression)
        
        return idValidation.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // 대문자, 소문자, 특수문자, 숫자, 8자 이상
        let pwExpression = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-])[A-Za-z0-9!@#$%^&*()_+=-]{8,}"
        let pwValidation = NSPredicate.init(format: "SELF MATCHES %@", pwExpression)
        
        return pwValidation.evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        // 대문자 or 소문자, 한글, 3-8자
        let nicknameExpression = "^(?=.*[A-Za-z가-힣])[A-Za-z가-힣]{3,8}"
        let nicknameValidation = NSPredicate.init(format: "SELF MATCHES %@", nicknameExpression)
        
        return nicknameValidation.evaluate(with: self)
    }
    
    // 계좌 번호 Validation 확인 -> 숫자로만 이루어져 있는지
    func isValidAccountNum() -> Bool {
        let accountExpression = "^[0-9]*$"
        return (self.range(of: accountExpression, options: .regularExpression ) != nil)
    }
    
    /* limit만큼 text를 잘라서 return 해주는 함수 */
    func createSlicedText(_ limit: Int) -> String {
        if self.count > limit {
            return self.truncated(after: limit)
        } else {
            return self
        }
    }
    
    // yyyy-MM-dd HH:mm:ss 형식의 str을 MM/dd HH:mm 형식으로 포맷팅
    func formatToMMddHHmm() -> String {
        let str = self.replacingOccurrences(of: " ", with: "")
        let startIdx = str.index(str.startIndex, offsetBy: 5)
        let middleIdx = str.index(startIdx, offsetBy: 5)
        let endIdx = str.index(middleIdx, offsetBy: 5)
        
        let dateStr = str[startIdx..<middleIdx].replacingOccurrences(of: "-", with: "/") // MM/dd
        let timeStr = str[middleIdx..<endIdx] // HH:mm
        
        return dateStr + "  " + timeStr
    }
    
    /* count 뒤로는 자르고 ...을 붙여서 byTruncatingTail 처럼 보이게 만들어 주는 함수 */
    private func truncated(after count: Int) -> String {
        let truncateAfter = index(startIndex, offsetBy: count)
        guard endIndex > truncateAfter else { return self }
        return String(self[startIndex..<truncateAfter]) + "…"
    }
}

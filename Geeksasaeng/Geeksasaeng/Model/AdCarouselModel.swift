//
//  CarouselModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/06.
//

import Foundation

class AdCarouselModel {
    
    // AdCarousel cell에 들어갈 데이터 포맷 선언.
    struct AdCarouselData {
        let cellImagePath: String
    }
    
    // cell에 들어갈 데이터를 만들어서 배열에 넣는다.
    static let adCellDataArray: [AdCarouselData] = [
        AdCarouselData(cellImagePath: "BannerAd"),
        AdCarouselData(cellImagePath: "NaverLogo"),
        AdCarouselData(cellImagePath: "PeopleImage"),
        AdCarouselData(cellImagePath: "ProfileImage"),
        AdCarouselData(cellImagePath: "Community")
    ]
}

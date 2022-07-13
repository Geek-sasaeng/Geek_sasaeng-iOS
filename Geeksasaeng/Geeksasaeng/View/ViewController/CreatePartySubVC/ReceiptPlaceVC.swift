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
    
    let mapSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    /* confirmButton: 완료 버튼 */
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
    
    // MARK: - Properties
    var mapView: MTMapView?
    
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
        
        setMapView()
        setViewLayout()
        setSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    private func setMapView() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.456518177069526, longitude: 126.70531256589555)), zoomLevel: 5, animated: true)
        }
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView?.remove(item as! MTMapPOIItem)
        }
    }
    
    private func setSubViews() {
        [titleLabel, backButton, mapSubView, confirmButton, pageLabel].forEach {
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
        
        mapSubView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(106)
            make.centerX.equalToSuperview()
            make.width.equalTo(262)
            make.height.equalTo(144)
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
    
    /*
    // 마커 추가
    private func makeMarker() {
        /*
        저는 서버 api를 통해 가져온 데이터를 resultList에 담았어요
        이름, 좌표, 주소 등을 담은 구조체를 담은 배열이에요
        */
    
        // cnt로 마커의 tag를 구분
        var cnt = 0
        for item in resultList {
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.x, longitude: item.y
            ))
            poiItem1 = MTMapPOIItem()
            // 핀 색상 설정
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint1
            // 핀 이름 설정
            poiItem1?.itemName = item.placeName
            // 태그 설정
            poiItem1?.tag = cnt
            // 맵뷰에 추가!
            mapView!.add(poiItem1)
            cnt += 1
        }
    }
     */
    
    @objc func removeAllSubVC() {
        NotificationCenter.default.post(name: NSNotification.Name("TapConfirmButton"), object: "true")
    }
}

extension ReceiptPlaceViewController: MTMapViewDelegate {
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let index = poiItem.tag
    }
    
}

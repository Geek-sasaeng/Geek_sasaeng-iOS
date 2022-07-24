//
//  ReceiptPlaceVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import CoreLocation

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
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: 0x5B5B5B)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .customFont(.neoRegular, size: 15)
        textField.placeholder = "입력하세요"
        textField.makeBottomLine(210)
        textField.textColor = .black
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor(hex: 0x2F2F2F)
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        return button
    }()
    
    let customView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        let button = UIButton()
        button.setTitle("이 위치로 지정", for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    let mapSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    /* confirmButton: 완료 버튼 */
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        button.titleLabel?.font = .customFont(.neoBold, size: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: 0xEFEFEF)
        button.clipsToBounds = true
        button.setActivatedNextButton()
        button.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    /* pageLabel: 5/5 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "5/5"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Properties
    var mapView: MTMapView?
    let geocoder = CLGeocoder()
    var latitude: Double? // 현재 위도
    var longitude: Double? // 현재 경도
    var markerLocation: MTMapPoint? // 마커 좌표
    var marker: MTMapPOIItem = {
        let marker = MTMapPOIItem()
        marker.showAnimationType = .dropFromHeaven
        marker.markerType = .redPin
        marker.itemName = "요기?"
        marker.showDisclosureButtonOnCalloutBalloon = false
        marker.draggable = true
        return marker
    }()
    var markerAddress: String? // 마커 좌표의 주소
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLocation()
        setMapView()
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView?.remove(item as? MTMapPOIItem)
        }
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setLocation() {
        if let latitude = CreateParty.latitude,
           let longitude = CreateParty.longitude {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        // 기숙사 좌표를 한글로 저장 (검색 안 하고 바로 완료 누를 경우, API에서 불러온 기본 기숙사 주소로)
        if let latitude = latitude,
           let longitude = longitude {
            let locationNow = CLLocation(latitude: latitude, longitude: longitude)
            let locale = Locale(identifier: "ko_kr")
            geocoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { placemarks, error in
                if let address = placemarks {
                    if let administrativeArea = address.last?.administrativeArea,
                       let locality = address.last?.locality,
                       let name = address.last?.name {
                        self.markerAddress = "\(administrativeArea) \(locality) \(name)"
                    }
                }
            }
        }
    }
    
    private func setMapView() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude ?? 37.456518177069526,
                                                                    longitude: longitude ?? 126.70531256589555)), zoomLevel: 5, animated: true)
            
            // 마커의 좌표 설정
            self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude ?? 37.456518177069526, longitude: longitude ?? 126.70531256589555))
            
            mapSubView.addSubview(mapView)
        }
        mapView?.addPOIItems([marker])
    }
    
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(405)
        }
    }
    
    private func addSubViews() {
        [titleLabel, backButton, searchTextField, searchButton, mapSubView, confirmButton, pageLabel].forEach {
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
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(29)
            make.width.equalTo(210)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.top)
            make.left.equalTo(searchTextField.snp.right).offset(18)
            make.width.height.equalTo(30)
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
    
    @objc func tapConfirmButton() {
        CreateParty.address = markerAddress ?? "주소를 찾지 못했습니다"
        
        NotificationCenter.default.post(name: NSNotification.Name("TapConfirmButton"), object: "true")
    }
    
    @objc func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @objc func tapSearchButton() {
        geocoder.geocodeAddressString(searchTextField.text ?? "") { placemark, error in
            // 검색된 위치로 맵의 중심을 이동
            self.mapView!.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: placemark?.first?.location?.coordinate.latitude ?? 0, longitude: placemark?.first?.location?.coordinate.longitude ?? 0)), zoomLevel: 5, animated: true)
            
            // API Request를 위해 전역에 좌표 저장
            self.latitude = placemark?.first?.location?.coordinate.latitude ?? 0
            self.longitude = placemark?.first?.location?.coordinate.longitude ?? 0
            
            // 검색된 위치로 마커 이동
            self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: placemark?.first?.location?.coordinate.latitude ?? 0, longitude: placemark?.first?.location?.coordinate.longitude ?? 0))
            
            // 주소 추출
            if let administrativeArea = placemark?.first?.administrativeArea,
               let locality = placemark?.first?.locality,
               let name = placemark?.first?.name {
                // 일단 검색 결과 주소를 넣고 마커 이동하면 갱신된 주소를 대입
                self.markerAddress = "\(administrativeArea) \(locality) \(name)"
            }
        }
    }
}

extension ReceiptPlaceViewController: MTMapViewDelegate {
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let _ = poiItem.tag
    }
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location.mapPointGeo()
        print("MTMapView updateCurrentLocation (\(currentLocation.latitude), \(currentLocation.longitude)) accuracy (\(accuracy))")
        
    }
    
    func mapView(_ mapView: MTMapView!, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
    
    func mapView(_ mapView: MTMapView!, draggablePOIItem poiItem: MTMapPOIItem!, movedToNewMapPoint newMapPoint: MTMapPoint!) {
        CreateParty.latitude = newMapPoint.mapPointGeo().latitude
        CreateParty.longitude = newMapPoint.mapPointGeo().longitude
        
        /* 현재 위치를 한글 데이터로 받아오기 */
        let locationNow = CLLocation(latitude: newMapPoint.mapPointGeo().latitude, longitude: newMapPoint.mapPointGeo().longitude) // 마커 위치
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko_kr")
        // 위치 받기 (국적, 도시, 동&구, 상세 주소)
        geocoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { (placemarks, error) in
            if let address = placemarks {
                if let administrativeArea = address.last?.administrativeArea,
                   let locality = address.last?.locality,
                   let name = address.last?.name {
                    /* 마커의 주소를 저장 */
                    self.markerAddress = "\(administrativeArea) \(locality) \(name)"
                }
            }
        }
    }
}
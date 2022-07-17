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
    let backButton: UIButton = {
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
        return textField
    }()
    
    let searchButton: UIButton = {
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
    
    /* pageLabel: 4/4 */
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "4/4"
        label.font = .customFont(.neoMedium, size: 13)
        label.textColor = UIColor(hex: 0xD8D8D8)
        return label
    }()
    
    // MARK: - Properties
    var mapView: MTMapView?
    var locationManager: CLLocationManager!
    var la: Double = 0 // 현재 위도
    var lo: Double = 0 // 현재 경도
    var markerLocation: MTMapPoint? // 마커 좌표
    var marker = MTMapPOIItem()
    var markerAddress: String? // 마커 좌표의 주소
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setMapView()
        setLocationManager()
        setViewLayout()
        setSubViews()
        setLayouts()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
            
            mapSubView.addSubview(mapView)
        }
    }
    
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
    
    /* 마커 추가 메서드 */
    func createPin(itemName: String, mapPoint: MTMapPoint, markerType: MTMapPOIItemMarkerType) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = itemName
        poiItem.mapPoint = mapPoint
        poiItem.markerType = markerType
        mapView?.addPOIItems([poiItem])
        
        return poiItem
    }
    
    @objc func removeAllSubVC() {
        CreateParty.address = markerAddress ?? "주소를 찾지 못했습니다"
        
        // API Input에 저장
        if let markerAddress = markerAddress {
            CreateParty.location = markerAddress
        } else {
            CreateParty.location = "주소를 찾지 못했습니다"
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TapConfirmButton"), object: "true")
    }
    
    @objc func tapBackButton() {
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @objc func tapSearchButton() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchTextField.text ?? "") { placemark, error in
            // 검색된 위치로 맵의 중심을 이동
            self.mapView!.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: placemark?.first?.location?.coordinate.latitude ?? 0, longitude: placemark?.first?.location?.coordinate.longitude ?? 0)), zoomLevel: 5, animated: true)
            
            // 검색된 위치에 마커 생성
            self.marker.showAnimationType = .dropFromHeaven
            self.marker.markerType = .redPin
            self.marker.itemName = "요기?"
            self.marker.showDisclosureButtonOnCalloutBalloon = false
            self.marker.draggable = true
            self.marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: placemark?.first?.location?.coordinate.latitude ?? 0, longitude: placemark?.first?.location?.coordinate.longitude ?? 0))
            
            // 주소 추출
            if let administrativeArea = placemark?.first?.administrativeArea,
               let locality = placemark?.first?.locality,
               let name = placemark?.first?.name {
                // 일단 검색 결과 주소를 넣고 마커 이동하면 갱신된 주소를 대입
                self.markerAddress = "\(administrativeArea) \(locality) \(name)"
            }
            
            // 지도에 마커 추가
            self.mapView?.addPOIItems([self.marker])
        }
    }
}

extension ReceiptPlaceViewController: MTMapViewDelegate {
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let index = poiItem.tag
    }
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location.mapPointGeo()
        print("MTMapView updateCurrentLocation (\(currentLocation.latitude), \(currentLocation.longitude)) accuracy (\(accuracy))")
        
    }
    
    func mapView(_ mapView: MTMapView!, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
    
    func mapView(_ mapView: MTMapView!, draggablePOIItem poiItem: MTMapPOIItem!, movedToNewMapPoint newMapPoint: MTMapPoint!) {
        print("==============")
        print("\(newMapPoint.mapPointGeo().latitude)")
        print("\(newMapPoint.mapPointGeo().longitude)")
        
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

extension ReceiptPlaceViewController: CLLocationManagerDelegate {
    // 위치 권한 요청
    func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // 권한 요청 답변 결과에 따라
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("GPS 권한 설정됨")
        case .restricted:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        la = location.coordinate.latitude
        lo = location.coordinate.longitude
        print("DEBUG(la):: \(location.coordinate.latitude)")
        print("DEBUG(lo):: \(location.coordinate.longitude)")
        
        
//        /* 현재 위치를 한글 데이터로 받아오기 */
//        let locationNow = CLLocation(latitude: la, longitude: lo) // 현재 위치
//        let geocoder = CLGeocoder()
//        let locale = Locale(identifier: "ko_kr")
//        // 위치 받기 (국적, 도시, 동&구, 상세 주소)
//        geocoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { (placemarks, error) in
//            if let address = placemarks {
//                if let administrativeArea = address.last?.administrativeArea,
//                   let locality = address.last?.locality,
//                   let name = address.last?.name {
//                    /* 현재 위치를 마커로 표시 */
//                    if self.isCurrentMark == false { // 마커 초기 위치 = 현재 위치
//                        let currentPoiItem = MTMapPOIItem()
//                        currentPoiItem.itemName = "\(administrativeArea) \(locality) \(name)"
//                        currentPoiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: self.la, longitude: self.lo))
//                        currentPoiItem.markerType = .redPin
//                        currentPoiItem.draggable = true
//
//                        self.markerLocation = currentPoiItem.mapPoint
//
//                        self.mapView?.addPOIItems([currentPoiItem])
//
//                        self.isCurrentMark = true
//                    }
//                }
//            }
//        }
    }
}

/*
 현재 위치 마커까지 구현 완료
 검색해서 위도 경도로 변환하고 지도에 표시해야 할 듯 ,,,,,?
 */

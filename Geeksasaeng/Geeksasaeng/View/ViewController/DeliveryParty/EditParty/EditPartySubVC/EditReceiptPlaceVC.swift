//
//  ReceiptPlaceVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import CoreLocation
import Then
import NMapsMap

class EditReceiptPlaceViewController: UIViewController {
    // MARK: - SubViews
    /* titleLabel: 수령 장소 */
    let titleLabel = UILabel().then {
        $0.text = "수령 장소"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    lazy var searchTextField = UITextField().then {
        $0.font = .customFont(.neoRegular, size: 15)
        $0.placeholder = "입력하세요"
        $0.makeBottomLine()
        $0.textColor = .black
        $0.returnKeyType = .done
        $0.delegate = self
    }
    
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = UIColor(hex: 0x2F2F2F)
        $0.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
    }
    
    let customView = UIView().then {
        $0.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        let button = UIButton().then {
            $0.setTitle("이 위치로 지정", for: .normal)
        }
        $0.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /* confirmButton: 완료 버튼 */
    lazy var confirmButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setActivatedNextButton()
        $0.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
    }
    
    let naverMapView = NMFNaverMapView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.showZoomControls = true
        $0.showLocationButton = false
    }
    
    // MARK: - Properties
    var mapView: MTMapView?
    let geocoder = CLGeocoder()
    var latitude: Double? // 현재 위도
    var longitude: Double? // 현재 경도
    var marker = NMFMarker() // 마커
    var address: String? // 좌표의 주소
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setMapView()
        setViewLayout()
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setMapView() {
        if let latitude = CreateParty.latitude,
           let longitude = CreateParty.longitude {
            self.latitude = latitude
            self.longitude = longitude
            
            // 기숙사 좌표를 한글로 저장 (검색 안 하고 바로 완료 누를 경우, API에서 불러온 기본 기숙사 주소로)
            let locationNow = CLLocation(latitude: latitude, longitude: longitude)
            let locale = Locale(identifier: "ko_kr")
            geocoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { placemarks, error in
                if let address = placemarks {
                    if let administrativeArea = address.last?.administrativeArea,
                       let locality = address.last?.locality,
                       let name = address.last?.name {
                        self.address = "\(administrativeArea) \(locality) \(name)"
                        self.marker.captionText = "\(administrativeArea) \(locality) \(name)"
                    }
                }
            }
            
            /* naverMapView, marker 설정 */
            if let latitude = CreateParty.latitude,
               let longitude = CreateParty.longitude {
                self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)))
                
                marker.position = NMGLatLng(lat: latitude, lng: longitude)
                marker.captionAligns = [NMFAlignType.top]
                marker.touchHandler = { (overlay) -> Bool in
                    print("마커터치")
                    return true
                    
                }
                marker.mapView = self.naverMapView.mapView
            }
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
    
    private func addSubViews() {
        [titleLabel, searchTextField, searchButton, naverMapView, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
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
        
        naverMapView.snp.makeConstraints { make in
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
    }
    
    @objc
    private func tapConfirmButton() {
        CreateParty.address = address ?? "주소를 찾지 못했습니다"
        
        NotificationCenter.default.post(name: NSNotification.Name("TapEditLocationButton"), object: "true")
    }
    
    @objc
    private func tapSearchButton() {
        guard let searchedKeyword = searchTextField.text else { return }
        geocoder.geocodeAddressString(searchedKeyword) { placemarks, error in
            guard let placemarks = placemarks else { return }
            if error != nil {
                print("DEBUG 에러 발생: \(error!.localizedDescription)")
            } else if placemarks.count > 0 {
                print("DEBUG: 카카오맵 placemarks", placemarks)
                let placemark = placemarks.first
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                // 검색된 위치로 맵의 중심을 이동
                self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate?.latitude ?? 0.0, lng: coordinate?.longitude ?? 0.0)))
                
                // API Request를 위해 전역에 좌표 저장
                self.latitude = coordinate?.latitude ?? 0
                self.longitude = coordinate?.longitude ?? 0
                
                // 마커 이동 안 했을 때를 대비하여 전역에 좌표 저장
                CreateParty.latitude = self.latitude
                CreateParty.longitude = self.longitude
                
                // 주소 추출
                if let administrativeArea = placemark?.administrativeArea,
                   let locality = placemark?.locality,
                   let name = placemark?.name {
                    // 일단 검색 결과 주소를 넣고 마커 이동하면 갱신된 주소를 대입
                    self.address = "\(administrativeArea) \(locality) \(name)"
                    print("Seori Test \(administrativeArea) \(locality) \(name)")
                }
                
                // 검색된 위치로 마커 이동, captionText 변경
                self.marker.position = NMGLatLng(lat: coordinate?.latitude ?? 0.0, lng: coordinate?.longitude ?? 0.0)
                self.marker.captionText = self.address ?? "요기?"
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension EditReceiptPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            // 키보드 내리고 검색
            textField.resignFirstResponder()
            self.tapSearchButton()
        }
        return true
    }
}

//
//  LocationService.swift
//  JcyMapLibrary-iOS
//
//  Created by 杨捷 on 2023/7/12.
//

import Foundation
import CoreLocation

public class JCYLocationService: NSObject, CLLocationManagerDelegate {
    // 定位权限
    lazy var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()

    // 定位数据监听
    var onUpdatingLocation: ((CLLocation) -> Void)?
    
    // 开打持续定位
    public func startUpdatingLocation(allowsBackgroundLocationUpdates: Bool, onUpdatingLocation: ((CLLocation) -> Void)?) {
        self.onUpdatingLocation = onUpdatingLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 8.0
        locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
    }
    
    // 代理方法，位置更新时回调
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last ?? CLLocation.init()
        onUpdatingLocation?(location)
    }
    
    // 代理方法，当定位授权更新时回调
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .restricted {
            // 受限制，尝试提示然后进入设置页面进行处理
        } else if status == .denied {
            // 被拒绝，尝试提示然后进入设置页面进行处理
        } else if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    // 当获取定位出错时调用
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        onUpdatingLocation = nil
        self.locationManager.stopUpdatingLocation()
    }
}

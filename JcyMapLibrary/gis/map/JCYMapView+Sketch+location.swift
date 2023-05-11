//
//  JCYMapView+draw.swift
//  JcyMapLibrary-iOS
//
//  Created by 杨捷 on 2023/4/25.
//

import Foundation
import ArcGIS

/**
 绘图操作
 */
extension JCYMapView {
    
    /**
     * 绘面
     */
    public func createModeFreehandPolygon(onSketchGeometry: ((String) -> Void)?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .freehandPolygon)
    }

    /**
     * 点面
     */
    public func createModePolygon(onSketchGeometry: ((String) -> Void)?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .polygon)
    }
    
    /**
     绘图完成
     */
    public func drawingFinish() {
        guard let sketchEditor = mSketchEditor else { return }
        if (sketchEditor.geometry == nil || sketchEditor.geometry?.isEmpty == true) {
            print("请绘制图斑")
            return
        }
        if (sketchEditor.isSketchValid == false) {
            print("至少选择三个点")
            return
        }
        guard let json = try? sketchEditor.geometry?.toJSON() as? NSDictionary else { return }
        if let onSketchGeometry = onSketchGeometry { onSketchGeometry(json.toJson()) }
        clearSketch()
    }
    
    /**
     * 删除绘制
     */
    public func clearSketch() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.stop()
        sketchEditor.clearGeometry()
        onSketchGeometry = nil
    }
}

/**
 定位相关
 */
extension JCYMapView: CLLocationManagerDelegate {
    // 开打持续定位
    public func startUpdatingLocation(onUpdatingLocation: ((CLLocation) -> Void)?) {
        self.onUpdatingLocation = onUpdatingLocation
        locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 8.0
            locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    // 代理方法，位置更新时回调
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last ?? CLLocation.init()
        onUpdatingLocation?(location)
    }
    
    // 代理方法，当定位授权更新时回调
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let locationManager = locationManager else { return }
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
        self.locationManager?.stopUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
}

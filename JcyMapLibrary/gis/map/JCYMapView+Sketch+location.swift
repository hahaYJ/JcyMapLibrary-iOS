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
    public func createModeFreehandPolygon(onSketchGeometry: onSketchGeometryCallBack?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleSketchEditorGeometryDidChange(notification:)), name: .AGSSketchEditorGeometryDidChange, object: nil)
        let configuration = AGSSketchEditConfiguration()
        configuration.allowPartSelection = false
        configuration.allowVertexEditing = false
        configuration.allowRotate = false
        sketchEditor.start(with: nil, creationMode: .freehandPolygon, editConfiguration: configuration)
    }
    
    @objc func handleSketchEditorGeometryDidChange(notification: Notification) {
        guard let sketchEditor = mSketchEditor else { return }
        if (sketchEditor.creationMode != .freehandPolygon) { return }
        guard let jsonDic = try? sketchEditor.geometry?.toJSON() as? NSDictionary else { return }
        guard let rings = jsonDic["rings"] as? NSArray else { return }
        if (rings.count == 0) { return }
        if (rings.count > 1) {
            sketchEditor.stop()
            sketchEditor.clearGeometry()

            let newJsonDic = NSMutableDictionary(dictionary: jsonDic)
            newJsonDic["rings"] = [rings.lastObject]
            guard let drawGeometry = (try? AGSGeometry.fromJSON(newJsonDic) as? AGSGeometry) else { return  }

            let configuration = AGSSketchEditConfiguration()
            configuration.allowPartSelection = false
            configuration.allowVertexEditing = false
            configuration.allowRotate = false
            sketchEditor.start(with: drawGeometry, creationMode: .freehandPolygon, editConfiguration: configuration)
        }
    }

    /**
     * 点面
     */
    public func createModePolygon(onSketchGeometry: onSketchGeometryCallBack?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleSketchEditorGeometryDidChange(notification:)), name: .AGSSketchEditorGeometryDidChange, object: nil)
        sketchEditor.start(with: nil, creationMode: .polygon)
    }
    
    /**
     绘图完成
     */
    public func drawingFinish() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .AGSSketchEditorGeometryDidChange, object: nil)
        guard let sketchEditor = mSketchEditor else { return }
        
        if sketchEditor.geometry == nil || sketchEditor.geometry?.isEmpty == true {
            onSketchGeometry?(-1, 0, 0, "", "请绘制图斑")
            return
        }
        if sketchEditor.isSketchValid == false {
            if sketchEditor.creationMode == .polygon || sketchEditor.creationMode == .freehandPolygon {
                onSketchGeometry?(-1, 0, 0, "", "三个及以上的点才能构成面")
            } else if sketchEditor.creationMode == .polygon || sketchEditor.creationMode == .freehandPolyline {
                onSketchGeometry?(-1, 0, 0, "", "两个及以上数量的点才能构成线")
            } else if sketchEditor.creationMode == .point {
                onSketchGeometry?(-1, 0, 0, "", "点需要X、Y坐标")
            } else {
                onSketchGeometry?(-1, 0, 0, "", "请先选择绘制工具并在图中绘制")
            }
            return
        }

        guard let json = try? sketchEditor.geometry?.toJSON() as? NSDictionary else { return }
        guard let geometry = try? AGSGeometry.fromJSON(json) as? AGSGeometry else { return }
        guard let spatialReference = AGSSpatialReference(wkid: 4524) else { return }
        var projectGeometry = AGSGeometryEngine.projectGeometry(geometry, to: spatialReference)
        if projectGeometry is AGSPolygon {
            onSketchGeometry?(0, 0, abs(AGSGeometryEngine.area(of: geometry)).roundTo(places: 2), json.toJson(), "绘图完成")
        } else if projectGeometry is AGSPolyline {
            onSketchGeometry?(0, abs(AGSGeometryEngine.length(of: geometry)).roundTo(places: 2), 0, json.toJson(), "绘图完成")
        } else if projectGeometry is AGSPoint {
            onSketchGeometry?(0, 0, 0, json.toJson(), "绘图完成")
        } else {
            onSketchGeometry?(-1, 0, 0, "", "绘图失败")
        }
        clearSketch()
        onSketchGeometry = nil
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///                                                     线
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /// 画线
    /// - Parameter onSketchGeometry: 绘制回调
    public func createModeFreehandLine(onSketchGeometry: onSketchGeometryCallBack?) {
        guard let sketchEditor = mSketchEditor else { return }
        
        self.onSketchGeometry = onSketchGeometry

        sketchEditor.start(with: nil, creationMode: .freehandPolyline)
    }
    
    /// 打点画线
    /// - Parameter onSketchGeometry: 绘制回调
    public func createModePolyline(onSketchGeometry: onSketchGeometryCallBack?) {
        guard let sketchEditor = mSketchEditor else { return }
        
        self.onSketchGeometry = onSketchGeometry
        
        sketchEditor.start(with: nil, creationMode: .polyline)
    }
    
    /// 打点
    /// - Parameter onSketchGeometry: 打点回调
    public func createModePoint(onSketchGeometry: onSketchGeometryCallBack?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(handleSketchEditorGeometryDidChange(notification:)),
                         name: .AGSSketchEditorGeometryDidChange,
                         object: nil)
        sketchEditor.start(with: nil, creationMode: .point)
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
    
    public func clearSketchGeometry() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.clearGeometry()
    }
}

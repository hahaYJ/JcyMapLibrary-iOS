//
//  WrapperMapView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/5.
//

import Foundation
import ArcGIS

/**
 gis包装类
 */
public class JCYWrapperMapView : JCYMapView {
    
    
    private let TIANTITU_TOKEN = "323a1605e14a07ab30daf74e78c3e1ae"
    private let ARCGIS_API_KEY = "AAPKc12108e2a01b43e9b649b408720b42b8w4N50bBdYUr1xocWZVfifdb9o2PNrz_Hs_uXC2UwrE1h0ZWZKiPk9Fv-8iO8aLQX"
    private var mapView: AGSMapView?
    
    // 测量图形
    private var mGraphicsOverlay: AGSGraphicsOverlay?
    // 测量图形文字层
    private var mGraphicsTxtOverlay: AGSGraphicsOverlay?
    // 范围层
    private var mGraphicsScopeOverlay: AGSGraphicsOverlay?
    // 手绘层
    private var mAreaGraphics: AGSGraphicsOverlay?
    // gsp轨迹层
    private var mGpsRouteGraphics: AGSGraphicsOverlay?
    // 方向角层
    private var mOverlayPictureAngle: AGSGraphicsOverlay?
    // 定位图层
    private var mLocationDisplay: AGSLocationDisplay?
    // 实时GPS定位点
    private var mCurrentLocationPoint: AGSPoint?
    /**
     创建gis
     */
    public static func createMapView(_ onLoaded: ((_ mapView: JCYMapView) -> Void)?) -> AGSMapView {
        let mapView = AGSMapView()
        _ = JCYWrapperMapView(mapView, onLoaded: onLoaded)
        return mapView
    }
    
    
    init(_ mapView: AGSMapView, onLoaded mapContext: ((_ mapView: JCYMapView) -> Void)?) {
        // 关闭底部文字
        mapView.isAttributionTextVisible = false
        // 初始化底图
        initMapBasemap(mapView)
        // 初始化图层、事件相关
        mapView.map?.load { _ in
            self.initMapOverlay()
            self.setMapLocationDisplay()
            mapContext?(self)
        }
    }
    
    /**
     添加天地图低图
     */
    private func initMapBasemap(_ mapView: AGSMapView) {
        AGSArcGISRuntimeEnvironment.apiKey = ARCGIS_API_KEY
        let map = AGSMap(basemapStyle: .arcGISTopographic)
        // 关联mapview
        mapView.map = map
        // 设置天地图国家2000坐标低图
        if let tdtImage2000 = TianDiTuLayerBuilder()
            .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_IMAGE_2000)
            .setCachePath(cachePath: "tdtimg")
            .setToken(token: TIANTITU_TOKEN)
            .build() {
            map.basemap.baseLayers.add(tdtImage2000)
        }
        
        if let tdtImageChinese2000 = TianDiTuLayerBuilder()
            .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_IMAGE_ANNOTATION_CHINESE_2000)
            .setCachePath(cachePath: "tdttxt")
            .setToken(token: TIANTITU_TOKEN)
            .build() {
            map.basemap.baseLayers.add(tdtImageChinese2000)
        }
        
        map.maxScale = 19.0
        self.mapView = mapView
    }
    
    private func initMapOverlay() {
        guard let mapView = mapView else { return }
        mapView.graphicsOverlays.add(mGraphicsOverlay = AGSGraphicsOverlay())
        mapView.graphicsOverlays.add(mGraphicsTxtOverlay = AGSGraphicsOverlay())
        mapView.graphicsOverlays.add(mGraphicsScopeOverlay = AGSGraphicsOverlay())
        mapView.graphicsOverlays.add(mAreaGraphics = AGSGraphicsOverlay())
        mapView.graphicsOverlays.add(mGpsRouteGraphics = AGSGraphicsOverlay())
        mapView.graphicsOverlays.add(mOverlayPictureAngle = AGSGraphicsOverlay())
    }
    
    private func setMapLocationDisplay() {
        guard let mapView = mapView else { return }
        let locationDisplay = mapView.locationDisplay
        locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.recenter
        locationDisplay.showAccuracy = true
        locationDisplay.showLocation = true
        locationDisplay.start()
        locationDisplay.locationChangedHandler = { location in
            guard let mapView = self.mapView else { return }
            guard let position = location.position else { return }
            // 第一次 跳转到当前位置
            if (self.mCurrentLocationPoint == nil) {
                mapView.setViewpointCenter(position, scale: 4000)
            }
            self.mCurrentLocationPoint = location.position
        }
    }
    
    public func addProjectPolygon() {
        print("xxxxx")
    }
    
    public func clearGraphicsSelection() {
        mGraphicsOverlay?.clearSelection()
        mGraphicsTxtOverlay?.clearSelection()
        mGraphicsScopeOverlay?.clearSelection()
        mOverlayPictureAngle?.clearSelection()
        mAreaGraphics?.clearSelection()
    }
}

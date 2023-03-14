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
public class JCMapView: AGSMapView {
    
    private let TIANTITU_TOKEN = "323a1605e14a07ab30daf74e78c3e1ae"
    private let ARCGIS_API_KEY = "AAPKc12108e2a01b43e9b649b408720b42b8w4N50bBdYUr1xocWZVfifdb9o2PNrz_Hs_uXC2UwrE1h0ZWZKiPk9Fv-8iO8aLQX"
    
    // 定位权限
    let locationManager = CLLocationManager()
    
    // 测量图形
    private var mGraphicsOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 测量图形文字层
    private var mGraphicsTxtOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 范围层
    private var mGraphicsScopeOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 手绘层
    private var mAreaGraphics: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // gsp轨迹层
    private var mGpsRouteGraphics: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 方向角层
    private var mOverlayPictureAngle: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 定位图层
    private var mLocationDisplay: AGSLocationDisplay?
    // 实时GPS定位点
    private var mCurrentLocationPoint: AGSPoint?
    // 所有多边形范围统计
    private var mAllPolygonExtent: AGSEnvelope?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initMapView(_ onLoad: @escaping () -> Void) {
        // 关闭底部文字
        self.isAttributionTextVisible = false
        // 初始化底图
        initMapBasemap(self)
        // 初始化图层、事件相关
        self.map?.load { [weak self] _ in
            guard let self = self else { return }
            self.initMapOverlay()
            self.setMapLocationDisplay()
            onLoad()
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
    }
    
    private func initMapOverlay() {
        graphicsOverlays.add(mGraphicsOverlay = AGSGraphicsOverlay())
        graphicsOverlays.add(mGraphicsTxtOverlay = AGSGraphicsOverlay())
        graphicsOverlays.add(mGraphicsScopeOverlay = AGSGraphicsOverlay())
        graphicsOverlays.add(mAreaGraphics = AGSGraphicsOverlay())
        graphicsOverlays.add(mGpsRouteGraphics = AGSGraphicsOverlay())
        graphicsOverlays.add(mOverlayPictureAngle = AGSGraphicsOverlay())
    }
    
    private func setMapLocationDisplay() {
        locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.recenter
        locationDisplay.showAccuracy = true
        locationDisplay.showLocation = true
        locationDisplay.start()
        locationDisplay.locationChangedHandler = { [weak self] location in
            guard let mapView = self else { return }
            guard let position = location.position else { return }
            // 第一次 跳转到当前位置
            if (mapView.mCurrentLocationPoint == nil) {
                mapView.setViewpointCenter(position, scale: 4000)
            }
            mapView.mCurrentLocationPoint = location.position
        }
    }
    
    /**
     统计所有图斑范围
     */
    private func statisticsAllPolygonExtent(geometry: AGSGeometry) {
        if (mAllPolygonExtent == nil) {
            mAllPolygonExtent = geometry.extent
        } else {
            mAllPolygonExtent = AGSGeometryEngine.union(ofGeometry1: mAllPolygonExtent!, geometry2: geometry.extent)?.extent
        }
    }
    
}


extension JCMapView : JCYMapViewDelegate {
    
    /**
     添加多边形
     */
    public func addProjectPolygon(polygon: AGSPolygon?, id: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: (() -> Void)?) {
        guard let polygon = polygon else { return }
        statisticsAllPolygonExtent(geometry: polygon)
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: UIColor(red: 225, green: 25, blue: 25, alpha: 225), width: 2)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        mGraphicsOverlay.graphics.add(graphic)
        //        attributes["id"] = id
        //                       clickGeometryMap[id ?: ""] = onClickGeometry
        
        // 添加文字
        mGraphicsOverlay.graphics.add(AGSGraphic(geometry: polygon, symbol: getTextSymbol(text: id ?? "", textSize: 10)))
        
        if (isMoveToGeometry) {
            moveToGeometry(extent: polygon, pindding: pindding, moveUp: false)
        }
    }
    
    public func moveToGeometry(extent: AGSGeometry, pindding: Double, moveUp: Bool) {
        setViewpointGeometry(extent, padding: pindding) { _ in
        }
    }
    
    /**
     文字图形
     */
    private func getTextSymbol(text: String, textSize: Float) -> AGSTextSymbol {
        let textSymbol = AGSTextSymbol(text: text, color: UIColor(red: 255, green: 136, blue: 0, alpha: 255), size: CGFloat(textSize), horizontalAlignment: AGSHorizontalAlignment.center, verticalAlignment: AGSVerticalAlignment.middle)
        textSymbol.haloWidth = 0.5
        textSymbol.haloColor = UIColor.white
        return textSymbol
    }
    
    /**
     清空选中
     */
    public func clearGraphicsSelection() {
        mGraphicsOverlay.clearSelection()
        mGraphicsTxtOverlay.clearSelection()
        mGraphicsScopeOverlay.clearSelection()
        mOverlayPictureAngle.clearSelection()
        mAreaGraphics.clearSelection()
    }
}

/**
 json数据转多边形
 */
extension String {
    public func toParsePolygon() -> AGSPolygon? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let dit = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> else { return nil }
        guard let geometry = dit["geometry"] as? Dictionary<String, Any> else { return nil }
        guard let coordinates = geometry["coordinates"] as? Array<Any> else { return nil }
        
        let spatialReference = AGSSpatialReference(wkid: 4524)
        var multiPolygon = [AGSGeometry]()
        
        coordinates.forEach { coordinate in
            guard let rings = coordinate as? Array<Any> else { return }
//            let partCollection = AGSMutablePartCollection(spatialReference: spatialReference)
            let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)

            rings.forEach { ring in
                guard let points = ring as? Array<Any> else { return }

                points.forEach { point in
                    guard let pt = point as? Array<Any> else { return }
                    if (pt.count >= 2) {
                        pointCollection.addPointWith(x: pt[0] as? Double ?? 0, y: pt[1] as? Double ?? 0)
                    }
                }
//                partCollection.add(AGSMutablePart(points: pointCollection.array()))
            }
            multiPolygon.append(AGSPolygon(points: pointCollection.array()))
        }
        
        guard let retPolygon = AGSGeometryEngine.unionGeometries(multiPolygon) as? AGSPolygon else { return nil }
        return retPolygon
    }
}

//
//  WrapperMapView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/5.
//

import Foundation
import ArcGIS

/**
 gis包装类，初始化、天地图相关
 */
public class JCYMapView: AGSMapView {
    
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
    // 所有绘图范围统计
    private var mDrawGeometryExtent: AGSEnvelope?
    // 方向角缓存的图形
    private var angleGeometryMap: [String : AGSGraphic] = [:]
    
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
        initMapBasemap()
        // 初始化图层、事件相关
        self.map?.load { [weak self] _ in
            guard let self = self else { return }
            self.initMapOverlay()
            self.setMapLocationDisplay()
            self.touchDelegate = self
            onLoad()
        }
    }
    
    /**
     添加天地图低图
     */
    private func initMapBasemap() {
        AGSArcGISRuntimeEnvironment.apiKey = ARCGIS_API_KEY
        let map = AGSMap()
        map.maxScale = 19.0
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
        // 关联mapview
        self.map = map
    }
    
    private func initMapOverlay() {
        graphicsOverlays.add(mGraphicsOverlay)
        graphicsOverlays.add(mGraphicsTxtOverlay)
        graphicsOverlays.add(mGraphicsScopeOverlay)
        graphicsOverlays.add(mAreaGraphics)
        graphicsOverlays.add(mGpsRouteGraphics)
        graphicsOverlays.add(mOverlayPictureAngle)
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
    
    /**
     * 统计所有绘图范围
     */
    private func statisticsAllDrawGeometryExtent(geometry: AGSGeometry) {
        if (mDrawGeometryExtent == nil) {
            mDrawGeometryExtent = geometry.extent
        } else {
            mDrawGeometryExtent = AGSGeometryEngine.union(ofGeometry1: mDrawGeometryExtent!, geometry2: geometry.extent)?.extent
        }
    }
    
    /**
     移动到图斑
     */
    public func moveToGeometry(extent: AGSGeometry, pindding: Double, moveUp: Bool) {
        setViewpointGeometry(extent, padding: pindding) { _ in
        }
    }
    
}




/**
 点击代理
 */
extension JCYMapView : AGSGeoViewTouchDelegate {
    public func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        clearGraphicsSelection()
        identifyGraphicsOverlays(atScreenPoint: screenPoint, tolerance: 10.0, returnPopupsOnly: false, maximumResultsPerOverlay: 1) { identifyGraphicsOverlayResults, error in
            guard error == nil else { return }
            guard let identifyGraphicsOverlayResults = identifyGraphicsOverlayResults else { return }
            guard identifyGraphicsOverlayResults.count > 0 else { return }
            
            // 获取层
            let identifyGraphicsOverlayResult = identifyGraphicsOverlayResults[0]
            guard identifyGraphicsOverlayResult.graphics.count > 0 else { return }
            
            // 获取图斑
            let selectGraphic = identifyGraphicsOverlayResult.graphics[0]
            selectGraphic.isSelected = true
            guard let onClickGeometry = selectGraphic.attributes["onClickGeometry"] as? ((AGSGraphic) -> Void) else { return }
            onClickGeometry(selectGraphic)
        }
    }
}




/**
 图形操作
 */
extension JCYMapView : JCYMapViewDelegate {
    
    /**
     * 添加绘制图形
     */
    public func addAreaGeometry(geometryJson: String?, id: String?, showTag: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let geometryJson = geometryJson else { return }
        guard let geometryDictionary = geometryJson.toDictionary() else { return }
        guard let drawGeometry = (try? AGSGeometry.fromJSON(geometryDictionary) as? AGSGeometry) else { return  }
        statisticsAllDrawGeometryExtent(geometry: drawGeometry)

        // 多边形边框、内部填充
        let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.white, width: 2)
        let fillSymbol = AGSSimpleFillSymbol(style: .solid, color: UIColor(red: 121 / 255, green: 67 / 255, blue: 39 / 255, alpha: 0.7), outline: lineSymbol)

        // 添加图形
        let graphic = AGSGraphic(geometry: drawGeometry, symbol: fillSymbol)
        graphic.attributes["id"] = id
        graphic.attributes["onClickGeometry"] = onClickGeometry
        mGraphicsOverlay.graphics.add(graphic)

        // 添加文字
        let txtGraphic = AGSGraphic(geometry: drawGeometry, symbol: getTextSymbol(text: showTag ?? "", textSize: 10))
        txtGraphic.attributes["id"] = id
        txtGraphic.attributes["onClickGeometry"] = onClickGeometry
        mGraphicsOverlay.graphics.add(txtGraphic)

        if (isMoveToGeometry) {
            moveToGeometry(extent: drawGeometry, pindding: pindding, moveUp: false)
        }
    }
    
    /**
     添加多边形
     */
    public func addProjectPolygon(polygon: AGSPolygon?, id: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let polygon = polygon else { return }
        statisticsAllPolygonExtent(geometry: polygon)
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: UIColor.red, width: 2)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        graphic.attributes["onClickGeometry"] = onClickGeometry
        mGraphicsOverlay.graphics.add(graphic)
        
        // 添加文字
        var realId = (id ?? "")
        if (realId.count > 5) {
            realId = "...\(String(realId[realId.index(realId.startIndex, offsetBy: realId.count - 4)..<realId.endIndex]))"
        }
        let txtGraphic = AGSGraphic(geometry: polygon, symbol: getTextSymbol(text: realId, textSize: 10))
        txtGraphic.attributes["id"] = id
        txtGraphic.attributes["onClickGeometry"] = onClickGeometry
        mGraphicsOverlay.graphics.add(txtGraphic)
        
        if (isMoveToGeometry) {
            moveToGeometry(extent: polygon, pindding: pindding, moveUp: false)
        }
    }
    
    /**
     添加方向角
     */
    public func addPictureAngle(arrowImage: UIImage?, azimuth: Float, longitude: Double, latitude: Double, id: String?, isSelected: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let arrowImage = arrowImage else { return }
        let future = AGSPictureMarkerSymbol(image: arrowImage)
        future.height = 30
        future.width = 17.4
        future.angle = azimuth
        future.load { [weak self] _ in
            guard let self = self else { return }
            let graphicPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            let graphic = AGSGraphic(geometry: graphicPoint, symbol: future)
            graphic.isSelected = isSelected
            graphic.attributes["id"] = id
            graphic.attributes["onClickGeometry"] = onClickGeometry
            self.angleGeometryMap[id ?? ""] = graphic
            self.mOverlayPictureAngle.graphics.add(graphic)
        }
    }
    
    /**
     文字图形
     */
    private func getTextSymbol(text: String, textSize: Float) -> AGSTextSymbol {
        let textSymbol = AGSTextSymbol(text: text, color: UIColor(red: 136 / 255, green: 119 / 255, blue: 220 / 255, alpha: 1), size: CGFloat(textSize), horizontalAlignment: AGSHorizontalAlignment.center, verticalAlignment: AGSVerticalAlignment.middle)
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
    
    public func selecteAngle(id: String?, isSelected: Bool) {
        guard let id = id else { return }
        angleGeometryMap[id]?.isSelected = isSelected
    }
    
    public func clearAllGraphics() {
        mGraphicsOverlay.graphics.removeAllObjects()
        mGraphicsTxtOverlay.graphics.removeAllObjects()
        mGraphicsScopeOverlay.graphics.removeAllObjects()
        mOverlayPictureAngle.graphics.removeAllObjects()
        mAreaGraphics.graphics.removeAllObjects()
    }
}

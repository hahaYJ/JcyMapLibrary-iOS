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
    
    private let ARCGIS_API_KEY = "AAPKc12108e2a01b43e9b649b408720b42b8w4N50bBdYUr1xocWZVfifdb9o2PNrz_Hs_uXC2UwrE1h0ZWZKiPk9Fv-8iO8aLQX"

    // 多边形图形
    public var mPolygonOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 绘制图形
    public var mAreaOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 测量图形文字层
//    private var mGraphicsTxtOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 范围层
    public var mGraphicsScopeOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 专题数据层
    public var mThematicDataOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 边界
    public var mBorderOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 图片图斑层
    public var mPictureOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 方向角层
    public var mOverlayPictureAngle: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // gsp轨迹层
    public var mGpsRouteGraphics: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 定位层
    var mLocationOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    // 定位范围圈层
    public var mCircleOverlay: AGSGraphicsOverlay = AGSGraphicsOverlay()
    
    // 加图层 耕地保护目标
    public var mFarmlandOverlay = AGSGraphicsOverlay()
    
    // 加图层 建设用地
    public var mConstructionLandOverlay = AGSGraphicsOverlay()
    
    // 定位图层
    private var mLocationDisplay: AGSLocationDisplay?
    // 实时GPS定位点
    private var mCurrentLocationPoint: AGSPoint?
    // 所有多边形范围统计
    public var mAllPolygonExtent: AGSEnvelope?
    // 所有绘图范围统计
    public var mDrawGeometryExtent: AGSEnvelope?
    // GPS轨迹点集合，用户路线测量
    private var mGpsRoutePts: AGSMutablePointCollection?
    // 轨迹线
    private var gpsRouteLine: AGSSimpleLineSymbol?
    // 手绘工具
    var mSketchEditor: AGSSketchEditor?
    // 绘制的图斑数据
    var onSketchGeometry: ((_ code: Int, _ area: Double, _ geometryJson: String, _ msg: String) -> Void)?
    
    // 方向角缓存的图形
    public var angleMap: [String : AGSGraphic] = [:]
    // 多边形缓存的图形
    public var polygonMap: [String : AGSGraphic] = [:]
    // 绘制图形缓存的图形
    public var areaMap: [String : AGSGraphic] = [:]
    // 范围缓存的图形
    public var scopeMap: [String : AGSGraphic] = [:]
    // 图片图斑的图形
    public var pictureMap: [String : AGSGraphic] = [:]
    // 图片图斑的图形
    public lazy var rasterLayerMap: [String : AGSRasterLayer] = {
        return [:]
    }()
    
    // 自动设置地图定位
//    public var autoSetMapLocation = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
        onSketchGeometry = nil
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
            self.initMapSketchEditor()
            self.touchDelegate = self
            onLoad()
//            if (autoSetMapLocation) {
//                self.setMapLocationDisplay()
//            }
        }
    }
    
    /**
     添加天地图低图
     */
    private func initMapBasemap() {
        AGSArcGISRuntimeEnvironment.apiKey = ARCGIS_API_KEY
        let map = AGSMap()
        map.maxScale = 19.0
        // 关联mapview
        self.map = map
        // 设置天地图国家2000坐标低图
        TiandituBaseLayerStyle(basemapStyle: .TIANDITU_IMAGE).toggleBaseMapLayer(mapView: self)
    }
    
    private func initMapOverlay() {
        graphicsOverlays.add(mCircleOverlay)
        graphicsOverlays.add(mBorderOverlay)
        graphicsOverlays.add(mThematicDataOverlay)
        graphicsOverlays.add(mGraphicsScopeOverlay)
        graphicsOverlays.add(mAreaOverlay)
        graphicsOverlays.add(mPolygonOverlay)
        graphicsOverlays.add(mPictureOverlay)
//        graphicsOverlays.add(mGraphicsTxtOverlay)
        graphicsOverlays.add(mGpsRouteGraphics)
        graphicsOverlays.add(mOverlayPictureAngle)
        graphicsOverlays.add(mLocationOverlay)
        
        // 加图层
        graphicsOverlays.add(mFarmlandOverlay)
        // 加图层
        graphicsOverlays.add(mConstructionLandOverlay)
    }
    
    /**
     * 初始化地图绘制编辑器
     */
    private func initMapSketchEditor() {
        mSketchEditor = AGSSketchEditor()
        self.sketchEditor = mSketchEditor
    }
    
//    public func setMapLocationDisplay() {
//        locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.recenter
//        locationDisplay.showAccuracy = true
//        locationDisplay.showLocation = true
//        locationDisplay.locationChangedHandler = { [weak self] location in
//            guard let mapView = self else { return }
//            guard let position = location.position else { return }
//            // 第一次 跳转到当前位置
//            if (mapView.mCurrentLocationPoint == nil) {
//                mapView.setViewpointCenter(position, scale: 4000)
//            }
//            mapView.mCurrentLocationPoint = location.position
//        }
//        locationDisplay.start()
//    }
    
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
    public func moveToGeometry(extent: AGSGeometry?, pindding: Double, moveUp: Bool) {
        guard let extent = extent else {
            zoomToLocation()
            return
        }
        setViewpointGeometry(extent, padding: pindding) { [weak self] _ in
            guard let self = self else { return }
            if (moveUp) {
                moveUpMap()
            }
        }
    }
    
    public func moveUpMap() {
        setViewpointCenter(self.screen(toLocation: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 20 * 17)))
    }
    
    /**
     * 放大
     */
    public func mapZoomin() {
        setViewpointScale(mapScale * 0.5)
    }
    
    /**
     * 缩小
     */
    public func mapZoomout() {
        setViewpointScale(mapScale * 2)
    }
    
    /**
     * 跳转到当前位置
    */
    public func zoomToLocation() {
        locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.recenter
        locationDisplay.start()
    }
    
    /**
     * 底图样式
    */
    public func baseMapLayerStyle(basemapStyle: BasemapStyleEnum) {
        TiandituBaseLayerStyle(basemapStyle: basemapStyle).toggleBaseMapLayer(mapView: self)
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
    
    // 画圆
    public func addCircle(point: AGSPoint, radius: Double) {
        mCircleOverlay.graphics.removeAllObjects()
        let points = getPoints(center: point, radius: radius)
        let polygon = AGSPolygon(points: points)
        let color = UIColor(red: 0, green: 144 / 255, blue: 1, alpha: 0.157)
        let lineSymbol = AGSSimpleLineSymbol(style: .null, color: color, width: 0)
        let simpleFillSymbol = AGSSimpleFillSymbol(style: .solid, color: color, outline: lineSymbol)
        let graphic = AGSGraphic(geometry: polygon, symbol: simpleFillSymbol)
        mCircleOverlay.graphics.add(graphic)
    }
    
    private func getPoints(center: AGSPoint, radius: Double) -> [AGSPoint] {
        var points: [AGSPoint] = []
        points.reserveCapacity(50)
        var sinV: Double
        var cosV: Double
        var x: Double
        var y: Double
        
        for i in 0..<50 {
            sinV = sin(Double.pi * 2 * Double(i) / 50)
            cosV = cos(Double.pi * 2 * Double(i) / 50)
            x = center.x + radius * sinV
            y = center.y + radius * cosV
            points.append(AGSPoint(x: x, y: y, spatialReference: AGSSpatialReference(wkid: 4326)))
        }
        return points
    }
    
    /**
     * 添加绘制图形
     */
    public func addAreaGeometry(geometryJson: String?, id: String?, showTag: String?, pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
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
        mAreaOverlay.graphics.add(graphic)
        if let id = id { areaMap[id] = graphic }
        
        // 添加文字
        let txtGraphic = AGSGraphic(geometry: drawGeometry, symbol: getTextSymbol(text: showTag ?? "", textSize: 10))
        txtGraphic.attributes["id"] = id
        txtGraphic.attributes["onClickGeometry"] = onClickGeometry
        mAreaOverlay.graphics.add(txtGraphic)
        if let id = id { areaMap["\(id)_txt"] = txtGraphic }
        
        if (isMoveToGeometry) {
            moveToGeometry(extent: drawGeometry, pindding: pindding, moveUp: isMoveUp)
        }
    }
    
    /**
     添加多边形
     */
    public func addProjectPolygon(polygon: AGSPolygon?, id: String?, showTag: String?, pindding: Double, color: UIColor?, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let polygon = polygon else { return }
        statisticsAllPolygonExtent(geometry: polygon)
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.red, width: 2)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        graphic.attributes["onClickGeometry"] = onClickGeometry
        mPolygonOverlay.graphics.add(graphic)
        if let id = id { polygonMap[id] = graphic }
        
        // 添加文字
        var realId = (showTag ?? "")
        if (realId.count > 5) {
            realId = "...\(String(realId[realId.index(realId.startIndex, offsetBy: realId.count - 4)..<realId.endIndex]))"
        }
        let txtGraphic = AGSGraphic(geometry: polygon, symbol: getTextSymbol(text: realId, textSize: 10))
        txtGraphic.attributes["id"] = id
        txtGraphic.attributes["onClickGeometry"] = onClickGeometry
        mPolygonOverlay.graphics.add(txtGraphic)
        
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
            if let id = id { angleMap[id] = graphic }
            self.mOverlayPictureAngle.graphics.add(graphic)
        }
    }
    
    /**
     显示范围多边形
     */
    public func addScopePolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let polygon = polygon else { return }
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.yellow, width: 0.5)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        graphic.attributes["onClickGeometry"] = onClickGeometry
        mGraphicsScopeOverlay.graphics.add(graphic)
        if let id = id { scopeMap[id] = graphic }
        
        if (isMoveToGeometry) {
            moveToGeometry(extent: polygon, pindding: pindding, moveUp: false)
        }
    }
    
    /**
     显示范围多边形
     */
    public func addThematicDataPolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double) {
        guard let polygon = polygon else { return }
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.red, width: 0.5)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        mThematicDataOverlay.graphics.add(graphic)
    }
    
    /**
     显示边界
     */
    public func addBorderPolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double) {
        guard let polygon = polygon else { return }
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.red, width: 0.5)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        mBorderOverlay.graphics.add(graphic)
    }
    
    /**
     添加图片图斑
     */
    public func addPictureMarker(image: UIImage?, longitude: Double, latitude: Double, id: String?, isSelected: Bool, pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool, onClickGeometry: ((AGSGraphic) -> Void)?) {
        guard let arrowImage = image else { return }
        let future = AGSPictureMarkerSymbol(image: arrowImage)
        future.height = 35
        future.width = 35
        future.load { [weak self] _ in
            guard let self = self else { return }
            let graphicPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            let graphic = AGSGraphic(geometry: graphicPoint, symbol: future)
            graphic.isSelected = isSelected
            graphic.attributes["id"] = id
            graphic.attributes["onClickGeometry"] = onClickGeometry
            if let id = id { pictureMap[id] = graphic }
            self.mPictureOverlay.graphics.add(graphic)
            
            if (isMoveToGeometry) {
                setViewpointCenter(graphicPoint, scale: 7500) { finished in
                    if (finished && isMoveUp) {
                        self.moveUpMap()
                    }
                }
            }
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
        mAreaOverlay.clearSelection()
        mPolygonOverlay.clearSelection()
        //        mGraphicsTxtOverlay.clearSelection()
        mGraphicsScopeOverlay.clearSelection()
        mOverlayPictureAngle.clearSelection()
        mPictureOverlay.clearSelection()
        mThematicDataOverlay.clearSelection()
        mFarmlandOverlay.clearSelection()
    }
    
    public func selecteAngle(id: String?, isSelected: Bool) {
        guard let id = id else { return }
        angleMap[id]?.isSelected = isSelected
    }
    
    /**
     添加轨迹线
     */
    public func addGpsRouteLine(points: [AGSPoint], pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool) {
        let gpsRoutePts = AGSMutablePointCollection(spatialReference: AGSSpatialReference(wkid: 4326))
        let gpsRouteLine = AGSSimpleLineSymbol(style: .solid, color: UIColor(red: 68 / 255, green: 140 / 255, blue: 128 / 255, alpha: 1), width: 3)
        points.forEach { point in
            gpsRoutePts.add(point)
        }
        let lineGraphic = AGSGraphic(geometry: AGSPolyline(points: gpsRoutePts.array()), symbol: gpsRouteLine)
        mGpsRouteGraphics.graphics.add(lineGraphic)
        if (isMoveToGeometry) {
            guard let geometry = lineGraphic.geometry else { return }
            moveToGeometry(extent: geometry.extent, pindding: pindding, moveUp: isMoveUp)
        }
    }
    
    /**
     添加轨迹点，多点成线
     */
    public func addGpsRoutePts(point: AGSPoint) {
        if (mGpsRoutePts == nil) {
            mGpsRoutePts = AGSMutablePointCollection(spatialReference: AGSSpatialReference(wkid: 4326))
        }
        if (gpsRouteLine == nil) {
            gpsRouteLine = AGSSimpleLineSymbol(style: .solid, color: UIColor(red: 68 / 255, green: 140 / 255, blue: 128 / 255, alpha: 1), width: 3)
        }
        guard let mGpsRoutePts = mGpsRoutePts else { return }
        guard let gpsRouteLine = gpsRouteLine else { return }
        if (mGpsRoutePts.isEmpty) {
            zoomToLocation()
        }
        mGpsRoutePts.add(point)
        let lineGraphic = AGSGraphic(geometry: AGSPolyline(points: mGpsRoutePts.array()), symbol: gpsRouteLine)
        mGpsRouteGraphics.graphics.add(lineGraphic)
    }
    
    // 加图层
    public func addFarmlandOverlay(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double) {
        guard let polygon = polygon else { return }
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.gray, width: 0.5)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        mFarmlandOverlay.graphics.add(graphic)
    }
    
    // 加图层
    public func addConstructionLandOverlay(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double) {
        guard let polygon = polygon else { return }
        
        // 多边形边框、内部填充
        let polygonLineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color ?? UIColor.gray, width: 0.5)
        let polygonFillSymbol = AGSSimpleFillSymbol(style: AGSSimpleFillSymbolStyle.null, color: UIColor.clear, outline: polygonLineSymbol)
        
        // 添加图形
        let graphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
        graphic.attributes["id"] = id
        mConstructionLandOverlay.graphics.add(graphic)
    }
    
    /**
     通过ID删除图斑
     */
    public func deleteAreaGeometryFromID(id: String?) {
        guard let id = id else { return }
        let tempGeometry = areaMap[id]
        guard let tempGeometry = tempGeometry else { return }
        mAreaOverlay.graphics.remove(tempGeometry)
        areaMap.removeValue(forKey: id)
        
        let tempTxtGeometry = areaMap["\(id)_txt"]
        guard let tempTxtGeometry = tempTxtGeometry else { return }
        mAreaOverlay.graphics.remove(tempTxtGeometry)
        areaMap.removeValue(forKey: "\(id)_txt")
    }
    
    /**
     移除轨迹
     */
    public func clearGpsRoutePts() {
        guard let gpsRoutePts = mGpsRoutePts else { return }
        gpsRoutePts.removeAllPoints()
        mGpsRoutePts = AGSMutablePointCollection(spatialReference: AGSSpatialReference(wkid: 4326))
        mGpsRouteGraphics.graphics.removeAllObjects()
    }
    
    public func clearAllGraphics() {
        mDrawGeometryExtent = nil
        mAllPolygonExtent = nil
        mAreaOverlay.graphics.removeAllObjects()
        mPolygonOverlay.graphics.removeAllObjects()
        //        mGraphicsTxtOverlay.graphics.removeAllObjects()
        mOverlayPictureAngle.graphics.removeAllObjects()
        mPictureOverlay.graphics.removeAllObjects()
        mFarmlandOverlay.graphics.removeAllObjects()
        mConstructionLandOverlay.graphics.removeAllObjects()
        
        pictureMap.removeAll()
        areaMap.removeAll()
        polygonMap.removeAll()
        angleMap.removeAll()
    }
    
    public func clearAllAreaGraphics() {
        mDrawGeometryExtent = nil
        mAreaOverlay.graphics.removeAllObjects()
        mOverlayPictureAngle.graphics.removeAllObjects()
        areaMap.removeAll()
        angleMap.removeAll()
    }
    
    public func clearAllPolygonGraphics() {
        mAllPolygonExtent = nil
        mPolygonOverlay.graphics.removeAllObjects()
        mOverlayPictureAngle.graphics.removeAllObjects()
        polygonMap.removeAll()
        angleMap.removeAll()
    }
    
    /**
     清空范围多边形
     */
    public func clearAllScopePolygon() {
        mGraphicsScopeOverlay.graphics.removeAllObjects()
        scopeMap.removeAll()
    }
    
    /**
     清空范围专题数据
     */
    public func clearThematicDataPolygon() {
        mThematicDataOverlay.graphics.removeAllObjects()
    }
    
    /**
     清空边界
     */
    public func clearBorderPolygon() {
        mBorderOverlay.graphics.removeAllObjects()
    }
    
    /**
     清空图片图斑
     */
    public func clearAllPictureMarker() {
        mPictureOverlay.graphics.removeAllObjects()
        pictureMap.removeAll()
    }
    
    /**
     清空方向角
     */
    public func clearAllPictureAngle() {
        mOverlayPictureAngle.graphics.removeAllObjects()
        angleMap.removeAll()
    }
    
    // 加图层
    public func clearFarmlandOverlay() {
        mFarmlandOverlay.graphics.removeAllObjects()
    }
    
    // 加图层
    public func clearConstructionLandOverlay() {
        mConstructionLandOverlay.graphics.removeAllObjects()
    }
    
    /**
     * 显示定位方向角
     */
    public func showLocationAndOrientationOnMap(imageLocation: UIImage?, longitude: Double, latitude: Double, azimuth: Float, height: Float, width: Float) {
        guard let imageLocation = imageLocation else { return }
        if longitude <= 0 || latitude <= 0 { return }
        if abs(longitude) <= 1e-6 || abs(latitude) <= 1e-6 { return }
        let point = AGSPoint(x: longitude, y: latitude, spatialReference: AGSSpatialReference.wgs84())
        if (mLocationOverlay.graphics.count == 0) {
            let future = AGSPictureMarkerSymbol(image: imageLocation)
            future.height = CGFloat(height)
            future.width = CGFloat(width)
            future.angle = azimuth
            future.load { [weak self] _ in
                self?.mLocationOverlay.graphics.add(AGSGraphic(geometry: point, symbol: future))
                self?.setViewpointCenter(point, scale: 4000)
            }
        } else {
            if (mLocationOverlay.graphics.count > 1) {
                guard let temp = mLocationOverlay.graphics.firstObject else { return }
                mLocationOverlay.graphics.removeAllObjects()
                mLocationOverlay.graphics.add(temp)
            }
            guard let graphic = mLocationOverlay.graphics.firstObject as? AGSGraphic else { return }
            graphic.geometry = point
            guard let symbol = graphic.symbol as? AGSPictureMarkerSymbol else { return }
            symbol.angle = azimuth
            graphic.symbol = symbol
        }
    }
    
    public func addTimePhasesRaster(fileURL: URL, id: String?) {
        let raster = AGSRaster(fileURL: fileURL)
        let sxLayer = AGSRasterLayer(raster: raster)
        if let id = id { rasterLayerMap[id] = sxLayer }
        sxLayer.load { [weak self] _ in
            guard let fullExtent = sxLayer.fullExtent else { return }
            self?.setViewpointGeometry(fullExtent, padding: 50.0)
        }
        self.map?.operationalLayers.add(sxLayer)
    }
}

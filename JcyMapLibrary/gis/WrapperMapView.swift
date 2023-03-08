//
//  WrapperMapView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/5.
//

import Foundation
import ArcGIS

/**
 创建git
 */
func createMapView(_ context: (_ mapView: JCYMapView) -> Void) -> AGSMapView {
    let mapView = AGSMapView()
    context(JCYWrapperMapView(mapView: mapView))
    return mapView
}

/**
 gis包装类
 */
public class JCYWrapperMapView : JCYMapView {
    
    private let TIANTITU_TOKEN = "323a1605e14a07ab30daf74e78c3e1ae"
    private let ARCGIS_API_KEY = "AAPKc12108e2a01b43e9b649b408720b42b8w4N50bBdYUr1xocWZVfifdb9o2PNrz_Hs_uXC2UwrE1h0ZWZKiPk9Fv-8iO8aLQX"
    private var mapView: AGSMapView?
    
    
    init(mapView: AGSMapView) {
        // 初始化低图
        initMapBasemap(mapView)
    
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
            .setCachePath(cachePath: "")
            .setToken(token: TIANTITU_TOKEN)
            .build() {
            map.basemap.baseLayers.add(tdtImage2000)
        }

        if let tdtImageChinese2000 = TianDiTuLayerBuilder()
            .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_IMAGE_ANNOTATION_CHINESE_2000)
            .setCachePath(cachePath: "")
            .setToken(token: TIANTITU_TOKEN)
            .build() {
            map.basemap.baseLayers.add(tdtImageChinese2000)
        }
        
        map.maxScale = 19.0
        self.mapView = mapView
    }
    
    public func addProjectPolygon() {
        
    }
    
}

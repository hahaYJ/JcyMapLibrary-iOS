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
    
    
    private let _apiKey = "AAPKc12108e2a01b43e9b649b408720b42b8w4N50bBdYUr1xocWZVfifdb9o2PNrz_Hs_uXC2UwrE1h0ZWZKiPk9Fv-8iO8aLQX"
    private var mapView: AGSMapView?
    
    
    init(mapView: AGSMapView) {
        // 初始化低图
        initMapBasemap(mapView)
    
    }
    
    /**
     添加天地图低图
     */
    private func initMapBasemap(_ mapView: AGSMapView) {
        AGSArcGISRuntimeEnvironment.apiKey = _apiKey
        let map = AGSMap(basemapStyle: .arcGISTopographic)
        // 关联mapview
        mapView.map = map
        // 设置天地图国家2000坐标低图
//        map.basemap.baseLayers.add(<#T##anObject: Any##Any#>)
        
        self.mapView = mapView
    }
    
    public func addProjectPolygon() {
        
    }
    
}

//
//  TiandituBaseLayerStyle.swift
//  JcyMapLibrary- iOS
//
//  Created by 杨捷 on 2023/4/30.
//

import Foundation
import ArcGIS

/// 修改地图风格、影像、矢量
struct TiandituBaseLayerStyle {
    var basemapStyle: BasemapStyleEnum
    
    func getBasemapBaselayers() -> Array<AGSLayer> {
        var resLayers = [AGSLayer]()
        switch (basemapStyle) {
        case .TIANDITU_VECTOR:
            let vec_c = TianDiTuLayerBuilder()
                .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_VECTOR_2000)
                .setCachePath(cachePath: "tdtimg_v")
                .build()
            let cva_c = TianDiTuLayerBuilder()
                .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_VECTOR_ANNOTATION_CHINESE_2000)
                .setCachePath(cachePath: "tdttxt_v")
                .build()
            if let vec_c = vec_c { resLayers.append(vec_c) }
            if let cva_c = cva_c { resLayers.append(cva_c) }
            break
        case .TIANDITU_IMAGE:
            let vec_c = TianDiTuLayerBuilder()
                .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_IMAGE_2000)
                .setCachePath(cachePath: "tdtimg")
                .build()
            let cva_c = TianDiTuLayerBuilder()
                .setLayerType(layerType: TianDiTuLayerTypes.TIANDITU_IMAGE_ANNOTATION_CHINESE_2000)
                .setCachePath(cachePath: "tdttxt")
                .build()
            if let vec_c = vec_c { resLayers.append(vec_c) }
            if let cva_c = cva_c { resLayers.append(cva_c) }
            break
        }
        return resLayers
    }
    
    /**
      * 设置天地图地图样式
      */
    func toggleBaseMapLayer(mapView: AGSMapView?) {
        guard let mapView = mapView else { return }
        guard let map = mapView.map else { return }
        let basemapBaselayers = getBasemapBaselayers()
        
        let baseLayersOri = map.basemap.baseLayers
        baseLayersOri.removeAllObjects()
        
        basemapBaselayers.forEach { layer in
            map.basemap.baseLayers.add(layer)
        }
        map.basemap.load(completion: nil)
    }
}

public enum BasemapStyleEnum: Int {
    /** 影像 **/
    case TIANDITU_IMAGE

    /** 矢量 **/
    case TIANDITU_VECTOR
}

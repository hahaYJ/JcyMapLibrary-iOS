//
//  TianDiTuLayerInfo.swift
//  JcyMapLibrary- iOS
//
//  Created by 杨捷 on 2023/3/6.
//

import Foundation
import ArcGIS

/**
 瓦片数据
 */
class TianDiTuLayerInfo {
    var url: String = ""
    var layerName: String = ""
    
    var minZoomLevel: Int = 0
    var maxZoomLevel: Int = 20
    
    var xMin: Double = 0.0
    var yMin: Double = 0.0
    var xMax: Double = 0.0
    var yMax: Double = 0.0
    
    var tileWidth: Int = 256
    var tileHeight: Int = 256
    
    var scales: [Double]?
    var resolutions: [Double]?
    
    var dpi: Int = 96
    
    var srid: Int = 0
    
    var origin: AGSPoint?
    
    var tileMatrixSet: String = ""
    
    var lods: [AGSLevelOfDetail]?
    
    /**
     瓦片信息
     */
    func getTileInfo() -> AGSTileInfo? {
        let spatialReference = AGSSpatialReference(wkid: srid)
        if (spatialReference == nil) {
            return nil
        }
        return AGSTileInfo(dpi: dpi,
                           format: AGSTileImageFormat.PNG,
                           levelsOfDetail: lods ?? [],
                           origin: origin ?? AGSPointMake(0, 0, nil),
                           spatialReference: spatialReference!,
                           tileHeight: tileHeight,
                           tileWidth: tileWidth)
    }
    
    /**
     范围信息
     */
    func getFullExtent() -> AGSEnvelope? {
        let spatialReference = AGSSpatialReference(wkid: srid)
        if (spatialReference == nil) {
            return nil
        }
        return AGSEnvelope(xMin: xMin, yMin: yMin, xMax: xMax, yMax: yMax, spatialReference: spatialReference)
    }
    
}

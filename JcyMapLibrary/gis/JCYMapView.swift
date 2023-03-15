//
//  JCYMapView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/5.
//

import Foundation
import ArcGIS

public protocol JCYMapViewDelegate {
    
    /**
     添加图斑
     */
    func addProjectPolygon(polygon: AGSPolygon?, id: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: (() -> Void)?)

    /**
     添加方向角
     */
    func addPictureAngle(azimuth: Float, longitude: Double, latitude: Double, id: String?, isSelected: Bool, onClickGeometry: (() -> Void)?)
    
    /**
     清空图形选中状态
     */
    func clearGraphicsSelection()
}

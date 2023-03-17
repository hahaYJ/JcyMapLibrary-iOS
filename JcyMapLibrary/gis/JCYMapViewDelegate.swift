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
    func addProjectPolygon(polygon: AGSPolygon?, id: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)

    /**
     添加方向角
     */
    func addPictureAngle(arrowImage: UIImage?, azimuth: Float, longitude: Double, latitude: Double, id: String?, isSelected: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     清空图形选中状态
     */
    func clearGraphicsSelection()
    
    /**
     选中方向角
     */
    func selecteAngle(id: String?, isSelected: Bool)
}

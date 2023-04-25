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
     * 添加绘制图形
     */
    func addAreaGeometry(geometryJson: String?, id: String?, showTag: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加图斑
     */
    func addProjectPolygon(polygon: AGSPolygon?, id: String?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加方向角
     */
    func addPictureAngle(arrowImage: UIImage?, azimuth: Float, longitude: Double, latitude: Double, id: String?, isSelected: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加轨迹线
     */
    func addGpsRouteLine(points: [AGSPoint], pindding: Double, isMoveToGeometry: Bool)
    
    /**
     添加轨迹
     */
    func addGpsRoutePts(point: AGSPoint)
    
    /**
     移除轨迹
     */
    func clearGpsRoutePts()
    
    /**
     清空图形选中状态
     */
    func clearGraphicsSelection()
    
    /**
     清空所有图形
     */
    func clearAllGraphics()
    
    /**
     选中方向角
     */
    func selecteAngle(id: String?, isSelected: Bool)
}

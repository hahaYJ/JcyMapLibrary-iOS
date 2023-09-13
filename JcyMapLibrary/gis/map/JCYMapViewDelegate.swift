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
    func addAreaGeometry(geometryJson: String?, id: String?, showTag: String?, pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加图斑
     */
    func addProjectPolygon(polygon: AGSPolygon?, id: String?, showTag: String?, pindding: Double, color: UIColor?, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加方向角
     */
    func addPictureAngle(arrowImage: UIImage?, azimuth: Float, longitude: Double, latitude: Double, id: String?, isSelected: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     添加轨迹线
     */
    func addGpsRouteLine(points: [AGSPoint], pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool)
    
    /**
     显示范围多边形
     */
    func addScopePolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double, isMoveToGeometry: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
    /**
     显示范围多边形
     */
    func addThematicDataPolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double)
    
    /**
     显示边界
     */
    func addBorderPolygon(polygon: AGSPolygon?, id: String?, color: UIColor?, pindding: Double)
    
    /**
     添加图片图斑
     */
    func addPictureMarker(image: UIImage?, longitude: Double, latitude: Double, id: String?, isSelected: Bool, pindding: Double, isMoveToGeometry: Bool, isMoveUp: Bool, onClickGeometry: ((AGSGraphic) -> Void)?)
    
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
     清空绘图图形
     */
    func clearAllAreaGraphics()
    
    /**
     清空多边形
     */
    func clearAllPolygonGraphics()
    
    /**
     清空范围多边形
     */
    func clearAllScopePolygon()
    
    /**
     清空图片图斑
     */
    func clearAllPictureMarker()
    
    /**
     清空图片方向角
     */
    func clearAllPictureAngle()
    
    /**
     选中方向角
     */
    func selecteAngle(id: String?, isSelected: Bool)
    
    /**
     通过ID删除画图图斑
     */
    func deleteAreaGeometryFromID(id: String?)
    
    /**
     * 显示定位方向角
     */
    func showLocationAndOrientationOnMap(imageLocation: UIImage?, longitude: Double, latitude: Double, azimuth: Float, height: Float, width: Float)
    
    func addTimePhasesRaster(fileURL: URL, id: String?)
    
    /**
     显示范围
     */
    func addCircle(point: AGSPoint, radius: Double)
}

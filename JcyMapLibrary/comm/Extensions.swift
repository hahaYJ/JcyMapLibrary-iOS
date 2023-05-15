//
//  Extensions.swift
//  JcyMapLibrary- iOS
//
//  Created by 杨捷 on 2023/4/17.
//

import Foundation
import ArcGIS

/**
 json数据转多边形
 */
extension String {
    /**
     转为多边形对象
     */
    public func toParsePolygon() -> AGSPolygon? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let dit = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> else { return nil }
        guard let geometry = dit["geometry"] as? Dictionary<String, Any> else { return nil }
        guard let coordinates = geometry["coordinates"] as? Array<Any> else { return nil }
        
        let spatialReference = AGSSpatialReference(wkid: 4524)
        var multiPolygon = [AGSGeometry]()
        
        coordinates.forEach { coordinate in
            guard let rings = coordinate as? Array<Any> else { return }
            //            let partCollection = AGSMutablePartCollection(spatialReference: spatialReference)
            let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)
            
            rings.forEach { ring in
                guard let points = ring as? Array<Any> else { return }
                
                points.forEach { point in
                    guard let pt = point as? Array<Any> else { return }
                    if (pt.count >= 2) {
                        pointCollection.addPointWith(x: pt[0] as? Double ?? 0, y: pt[1] as? Double ?? 0)
                    }
                }
                //                partCollection.add(AGSMutablePart(points: pointCollection.array()))
            }
            multiPolygon.append(AGSPolygon(points: pointCollection.array()))
        }
        
        guard let retPolygon = AGSGeometryEngine.unionGeometries(multiPolygon) as? AGSPolygon else { return nil }
        return retPolygon
    }
    
    /**
     转字典对象
     */
    public func toDictionary() -> NSDictionary? {
        guard let constant = self.data(using: .utf8) else { return nil }
        guard let d = try? JSONSerialization.jsonObject(with: constant, options: .mutableContainers) else { return nil }
        guard let dic = d as? NSDictionary else { return nil }
        return dic
    }
}

extension NSDictionary {
    public func toJson() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else { return "{}" }
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

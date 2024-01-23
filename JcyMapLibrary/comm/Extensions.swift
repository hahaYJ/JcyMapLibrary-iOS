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
    
    func toParsePolygon(setWkid: @escaping (Int) -> Void = {_ in }) -> AGSPolygon? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String: Any] else {
            return nil
        }
        
        let coordinates: [[[[Double]]]]
        
        if jsonObject.description.range(of: "geometry", options: .caseInsensitive) != nil {
            guard let geometry = (jsonObject["geometry"] as? [String: Any?])?["coordinates"] as? [[[[Double]]]] else {
                return nil
            }
            // 田长的图斑
            coordinates = geometry
        } else if jsonObject.description.range(of: "coordinates", options: .caseInsensitive) != nil {
            guard let tempCoordinates = jsonObject["coordinates"] as? [[[[Double]]]] else { return nil }
            // 综合监测的图斑
            coordinates = tempCoordinates
        } else {
            // 未测试到
            guard let temp = jsonObject["rings"] as? [[[[Double]]]] else { return nil }
            coordinates = temp
        }
        var degree = "\(Int(coordinates.first?.first?.first?.first ?? 3600))"
        degree.replaceSubrange(degree.index(degree.startIndex, offsetBy: 2)..<degree.endIndex, with: "")
        
//        let bigDecimal = BigDecimal(string: str[str.startIndex..<str.firstIndex(of: ",")!])
//        let coord = String(bigDecimal.description[bigDecimal.description.startIndex..<bigDecimal.description.index(bigDecimal.description.startIndex, offsetBy: 2)])
        let spatialReference: AGSSpatialReference?
        let wkid: Int
        
        switch degree {
        case "35":
            spatialReference = AGSSpatialReference(wkid: 4523)
            wkid = 4523
        case "36":
            spatialReference = AGSSpatialReference(wkid: 4524)
            wkid = 4524
        case "37":
            spatialReference = AGSSpatialReference(wkid: 4525)
            wkid = 4525
        case "38":
            spatialReference = AGSSpatialReference(wkid: 4526)
            wkid = 4526
        default:
            spatialReference = AGSSpatialReference(wkid: 4326)
            wkid = 4326
        }
        
        setWkid(wkid)
        
        var union: AGSGeometry?
        var multiPolygon: [AGSGeometry] = []
        
        if coordinates.description.contains("[[[[[") {
            for l in 0..<coordinates.count {
                let patterns = coordinates[l]
//                let partCollection = AGSMutablePartCollection(spatialReference: spatialReference)
                let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)
                for i in 0..<patterns.count {
                    let rings = patterns[i]
                    for j in 0..<rings.count {
                        let points = rings[j]
                        pointCollection.addPointWith(x: points[0], y: points[1])
//                        pointCollection.add(AGSSegment(x: points[0], y: points[1], spatialReference: spatialReference))
                    }
//                    partCollection.add(pointCollection)
                }
                multiPolygon.append(AGSPolygon(points: pointCollection.array()))
//                append(AGSPolygon(partCollection: partCollection, spatialReference: spatialReference))
            }
            union = AGSGeometryEngine.unionGeometries(multiPolygon)
        } else if coordinates.description.contains("[[[[") {
            for i in 0..<coordinates.count {
                let rings = coordinates[i]
//                let partCollection = AGSPartCollection(spatialReference: spatialReference)
                let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)
                for j in 0..<rings.count {
                    let points = rings[j]
                    for k in 0..<points.count {
                        let pt = points[k]
                        pointCollection.add(AGSPoint(x: pt[0], y: pt[1], spatialReference: spatialReference))
                    }
//                    partCollection.add(pointCollection)
                }
                multiPolygon.append(AGSPolygon(points: pointCollection.array()))
//                multiPolygon.append(AGSPolygon(partCollection: partCollection, spatialReference: spatialReference))
            }
            union = AGSGeometryEngine.unionGeometries(multiPolygon)
//            union = AGSGeometryEngine.union(ofGeometries: multiPolygon)
        } else {
            // 田长的图斑
//            let partCollection = AGSPartCollection(spatialReference: spatialReference)
            let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)
            for j in 0..<coordinates.count {
                let points = coordinates[j]
                for j in 0..<points.count {
                    let temp = points[j]
                    for k in 0..<temp.count {
                        let pt = temp[k]
                        pointCollection.add(AGSPoint(x: pt[0], y: pt[1], spatialReference: spatialReference))
                    }
                }
//                partCollection.add(pointCollection)
            }
            multiPolygon.append(AGSPolygon(points: pointCollection.array()))
            union = AGSGeometryEngine.unionGeometries(multiPolygon)
//            multiPolygon.append(AGSPolygon(partCollection: partCollection, spatialReference: spatialReference))
//            union = AGSGeometryEngine.union(ofGeometries: multiPolygon)
        }
        return union as? AGSPolygon
    }
    
    /**
     转为多边形对象
     */
//    public func toParsePolygon() -> AGSPolygon? {
//        guard let data = self.data(using: .utf8) else { return nil }
//        guard let dit = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> else { return nil }
//        guard let geometry = dit["geometry"] as? Dictionary<String, Any> else { return nil }
//        guard let coordinates = geometry["coordinates"] as? Array<Any> else { return nil }
//        
//        let spatialReference = AGSSpatialReference(wkid: 4524)
//        var multiPolygon = [AGSGeometry]()
//        
//        coordinates.forEach { coordinate in
//            guard let rings = coordinate as? Array<Any> else { return }
//            //            let partCollection = AGSMutablePartCollection(spatialReference: spatialReference)
//            let pointCollection = AGSMutablePointCollection(spatialReference: spatialReference)
//            
//            rings.forEach { ring in
//                guard let points = ring as? Array<Any> else { return }
//                
//                points.forEach { point in
//                    guard let pt = point as? Array<Any> else { return }
//                    if (pt.count >= 2) {
//                        pointCollection.addPointWith(x: pt[0] as? Double ?? 0, y: pt[1] as? Double ?? 0)
//                    }
//                }
//                //                partCollection.add(AGSMutablePart(points: pointCollection.array()))
//            }
//            multiPolygon.append(AGSPolygon(points: pointCollection.array()))
//        }
//        
//        guard let retPolygon = AGSGeometryEngine.unionGeometries(multiPolygon) as? AGSPolygon else { return nil }
//        return retPolygon
//    }
    
    /**
     转字典对象
     */
    public func toDictionary() -> NSDictionary? {
        guard let constant = self.data(using: .utf8) else { return nil }
        guard let d = try? JSONSerialization.jsonObject(with: constant, options: .mutableContainers) else { return nil }
        guard let dic = d as? NSDictionary else { return nil }
        return dic
    }
    
    func hexStringToColor() -> UIColor? {
        let hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 检查字符串长度是否正确
        guard hexString.count == 9 else {
            return nil
        }
        
        // 移除首个字符（#）并将剩余的字符串转换为十六进制表示的整数
        if let hexValue = UInt32(hexString.dropFirst(), radix: 16) {
            // 从整数中提取各个颜色分量
            let red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            let green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            let blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            let alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            
            // 创建颜色对象
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            return color
        } else {
            return nil
        }
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

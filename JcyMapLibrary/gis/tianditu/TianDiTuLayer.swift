//
//  TianDiTuLayer.swift
//  JcyMapLibrary- iOS
//
//  Created by 杨捷 on 2023/3/6.
//

import Foundation
import ArcGIS

public class TianDiTuLayer : AGSImageTiledLayer {
    
    var layerType: TianDiTuLayerTypes = TianDiTuLayerTypes.TIANDITU_VECTOR_MERCATOR
    var cachePath: String?
    var layerInfo: TianDiTuLayerInfo?
    var token: String?
    
    override init(tileInfo: AGSTileInfo, fullExtent: AGSEnvelope) {
        super.init(tileInfo: tileInfo, fullExtent: fullExtent)
        tileRequestHandler = { [weak self] tileKey in
            guard let layerInfo = self?.layerInfo else { return }
            
            let level = tileKey.level
            let col = tileKey.column
            let row = tileKey.row
            
            // 层级超过范围
            if (level > layerInfo.maxZoomLevel || level < layerInfo.minZoomLevel) {
                self?.respond(with: tileKey, data: Data(count: 0), error: nil)
                return
            }
            
            // 天地图地址
            let layerUrl = layerInfo.url
            + "?service=wmts&request=gettile&version=1.0.0&tk=" + (self?.token ?? "") + "&layer="
            + layerInfo.layerName + "&format=tiles&tilematrixset="
            + layerInfo.tileMatrixSet + "&tilecol=" + String(col)
            + "&tilerow=" + String(row) + "&tilematrix=" + String(level)
            
            print(layerUrl)
            
            //            guard let aURL = URL(string: url) else { return }
            //            guard let imageData = try? Data(contentsOf: aURL) else { return }
            //            self?.respond(with: tileKey, data: imageData, error: nil)
            
            // 构建URL
            let url:URL = URL(string: layerUrl)!
            // 发送HTTP请求的的session对象
            let session = URLSession.shared
            // 构建请求request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", forHTTPHeaderField: "User-agent")
            // 发一个get请求
            let task = session.dataTask(with: request as URLRequest) {(
                data, response, error) in
                self?.respond(with: tileKey, data: data, error: nil)
            }
            task.resume()
        }
    }
}

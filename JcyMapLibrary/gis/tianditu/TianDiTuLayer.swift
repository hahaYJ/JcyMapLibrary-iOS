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
    var layerInfo: TianDiTuLayerInfo?
    var token: String?
    var pathKey: String = ""
    
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
            
            // 获取缓存路径
            let path = self?.cacheTilePath(level: level, col: col, row: row)
            // 加载本地瓦片数据
            if let cacheData = self?.readTile(path: path) {
                self?.respond(with: tileKey, data: cacheData, error: nil)
                return
            }
            
            // 天地图地址
            let layerUrl = "\(layerInfo.url)?service=wmts&request=gettile&version=1.0.0&tk=\(self?.token ?? "")&layer=\(layerInfo.layerName)&format=tiles&tilematrixset=\(layerInfo.tileMatrixSet)&tilecol=\(col)&tilerow=\(row)&tilematrix=\(level)"
            
            // 网络获取瓦片数据并保存本地
            self?.layerOnline(layerUrl: layerUrl) { [weak self] (data, response, error) in
                if (error == nil) {
                    if let tilePath = path {self?.writeTile(path: tilePath, data: data)}
                }
                self?.respond(with: tileKey, data: data, error: error)
            }
        }
    }
    
    /**
     请求网络瓦片地图
     */
    private func layerOnline(layerUrl: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        // 构建URL
        guard let url = URL(string: layerUrl) else { return }
        // 发送HTTP请求的的session对象
        let session = URLSession.shared
        // 构建请求request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36", forHTTPHeaderField: "User-agent")
        request.setValue("Upgrade-Insecure-Requests", forHTTPHeaderField: "Upgrade-Insecure-Requests")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("zh-CN,zh;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("max-age=0", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("t0.tianditu.com", forHTTPHeaderField: "Host")
        // 发一个get请求
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    /**
     通过瓦片参数获取缓存路径
     */
    private func cacheTilePath(level: Int, col: Int, row: Int) -> String {
        let fileManager = FileManager.default
        // 获取缓存文件路径
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return "" }
        let directory = "\(cachePath)/\(pathKey)/\(level)"
        try? fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true)
        let path = "\(directory)/\(col)x\(row).tdt"
        return path
    }
    
    /**
     缓存瓦片数据
     */
    private func writeTile(path: String, data: Data?) {
        guard let fileData = data else { return }
        let fileManager = FileManager.default
        
        if (!fileManager.fileExists(atPath: path)) {
            fileManager.createFile(atPath: path, contents:nil, attributes:nil)
            if let handle = FileHandle(forWritingAtPath:path) {
                handle.write(fileData)
                try? handle.close()
            }
        }
    }
    
    /**
     读取瓦片数据
     */
    private func readTile(path: String?) -> Data? {
        guard let path = path else { return nil }
        if (FileManager.default.fileExists(atPath: path)) {
            return try? Data(contentsOf: URL(fileURLWithPath: path))
        }
        return nil
    }
    
}

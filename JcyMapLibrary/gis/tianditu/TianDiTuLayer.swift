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
            
            
            let mainURL = ""
            let requestUrl1 = mainURL.appending("&tilecol=%ld&tilerow=%ld&tilematrix=%ld")
            let requestUrl = String(format: requestUrl1, tileKey.column,tileKey.row, (tileKey.level + 1))
            
            guard let aURL = URL(string: requestUrl) else { return }
            
            guard let imageData = try? Data(contentsOf: aURL) else { return }
            self?.respond(with: tileKey, data: imageData, error: nil)
        }
    }
}

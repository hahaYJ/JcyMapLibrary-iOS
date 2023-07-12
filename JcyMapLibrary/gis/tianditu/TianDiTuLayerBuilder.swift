//
//  TianDiTuLayerBuilder.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/6.
//

import Foundation

/**
 天地图构造器
 */
class TianDiTuLayerBuilder {
    
    private let TIANTITU_TOKEN = "323a1605e14a07ab30daf74e78c3e1ae"
    private var layerType: TianDiTuLayerTypes = TianDiTuLayerTypes.TIANDITU_VECTOR_MERCATOR
    private var cachePath: String = ""

    public func setLayerType(layerType: TianDiTuLayerTypes) -> TianDiTuLayerBuilder {
        self.layerType = layerType
        return self
    }

    public func setCachePath(cachePath: String) -> TianDiTuLayerBuilder {
        self.cachePath = cachePath
        return self
    }

    public func build() -> TianDiTuLayer? {
        let layerInfo = LayerInfoFactory.getLayerInfo(layerType: layerType)
        guard let tileInfo = layerInfo.getTileInfo() else { return nil}
        guard let fullExtent = layerInfo.getFullExtent() else { return nil }
        let tianDiTuLayer = TianDiTuLayer(tileInfo: tileInfo, fullExtent: fullExtent)
        tianDiTuLayer.pathKey = cachePath
        tianDiTuLayer.layerType = layerType
        tianDiTuLayer.layerInfo = LayerInfoFactory.getLayerInfo(layerType: layerType)
        tianDiTuLayer.token = TIANTITU_TOKEN
        return tianDiTuLayer
    }
}

/**
 地图类型
 */
public enum TianDiTuLayerTypes: Int {
    /**
     * 天地图矢量墨卡托投影地图服务
     */
    case TIANDITU_VECTOR_MERCATOR = 0
    /**
     * 天地图矢量墨卡托中文标注
     */
    case TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR = 1
    /**
     * 天地图矢量墨卡托英文标注
     */
    case TIANDITU_VECTOR_ANNOTATION_ENGLISH_MERCATOR = 2
    /**
     * 天地图影像墨卡托投影地图服务
     */
    case TIANDITU_IMAGE_MERCATOR = 3
    /**
     * 天地图影像墨卡托投影中文标注
     */
    case TIANDITU_IMAGE_ANNOTATION_CHINESE_MERCATOR = 4
    /**
     * 天地图影像墨卡托投影英文标注
     */
    case TIANDITU_IMAGE_ANNOTATION_ENGLISH_MERCATOR = 5
    /**
     * 天地图地形墨卡托投影地图服务
     */
    case TIANDITU_TERRAIN_MERCATOR = 6
    /**
     * 天地图地形墨卡托投影中文标注
     */
    case TIANDITU_TERRAIN_ANNOTATION_CHINESE_MERCATOR = 7
    /**
     * 天地图矢量国家2000坐标系地图服务
     */
    case TIANDITU_VECTOR_2000 = 8
    /**
     * 天地图矢量国家2000坐标系中文标注
     */
    case TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 = 9
    /**
     * 天地图矢量国家2000坐标系英文标注
     */
    case TIANDITU_VECTOR_ANNOTATION_ENGLISH_2000 = 10
    /**
     * 天地图影像国家2000坐标系地图服务
     */
    case TIANDITU_IMAGE_2000 = 11
    /**
     * 天地图影像国家2000坐标系中文标注
     */
    case TIANDITU_IMAGE_ANNOTATION_CHINESE_2000 = 12
    /**
     * 天地图影像国家2000坐标系英文标注
     */
    case TIANDITU_IMAGE_ANNOTATION_ENGLISH_2000 = 13
    /**
     * 天地图地形国家2000坐标系地图服务
     */
    case TIANDITU_TERRAIN_2000 = 14
    /**
     * 天地图地形国家2000坐标系中文标注
     */
    case TIANDITU_TERRAIN_ANNOTATION_CHINESE_2000 = 15
}

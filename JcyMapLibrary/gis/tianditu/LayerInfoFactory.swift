//
//  LayerInfoFactory.swift
//  JcyMapLibrary- iOS
//
//  Created by 杨捷 on 2023/3/6.
//

import Foundation
import ArcGIS

public class LayerInfoFactory {
    
    private static let URL_VECTOR_2000: String = "http://t0.tianditu.com/vec_c/wmts"
    private static let URL_VECTOR_ANNOTATION_CHINESE_2000 : String = "http://t0.tianditu.com/cva_c/wmts"
    private static let  URL_VECTOR_ANNOTATION_ENGLISH_2000 : String = "http://t0.tianditu.com/eva_c/wmts"
    private static let  URL_IMAGE_2000 : String = "http://t0.tianditu.com/img_c/wmts"
    private static let  URL_IMAGE_ANNOTATION_CHINESE_2000 : String = "http://t0.tianditu.com/cia_c/wmts"
    private static let URL_IMAGE_ANNOTATION_ENGLISH_2000 : String = "http://t0.tianditu.com/cia_c/wmts"
    private static let URL_TERRAIN_2000 : String = "http://t0.tianditu.com/ter_c/wmts"
    private static let URL_TERRAIN_ANNOTATION_CHINESE_2000 : String = "http://t0.tianditu.com/cta_c/wmts"

    private static let  URL_VECTOR_MERCATOR : String = "http://t0.tianditu.com/vec_w/wmts"
    private static let  URL_VECTOR_ANNOTATION_CHINESE_MERCATOR : String = "http://t0.tianditu.com/cva_w/wmts"
    private static let  URL_VECTOR_ANNOTATION_ENGLISH_MERCATOR : String = "http://t0.tianditu.com/eva_w/wmts"
    private static let  URL_IMAGE_MERCATOR : String = "http://t0.tianditu.com/img_w/wmts"
    private static let  URL_IMAGE_ANNOTATION_CHINESE_MERCATOR : String = "http://t0.tianditu.com/cia_w/wmts"
    private static let  URL_IMAGE_ANNOTATION_ENGLISH_MERCATOR : String = "http://t0.tianditu.com/cia_w/wmts"
    private static let  URL_TERRAIN_MERCATOR  : String = "http://t0.tianditu.com/ter_w/wmts"
    private static let  URL_TERRAIN_ANNOTATION_CHINESE_MERCATOR : String = "http://t0.tianditu.com/cta_w/wmts"

    private static let  LAYER_NAME_VECTOR : String = "vec"
    private static let  LAYER_NAME_VECTOR_ANNOTATION_CHINESE : String = "cva"
    private static let  LAYER_NAME_VECTOR_ANNOTATION_ENGLISH : String = "eva"
    private static let  LAYER_NAME_IMAGE : String = "img"
    private static let  LAYER_NAME_IMAGE_ANNOTATION_CHINESE : String = "cia"
    private static let  LAYER_NAME_IMAGE_ANNOTATION_ENGLISH : String = "eia"
    private static let  LAYER_NAME_TERRAIN : String = "ter"
    private static let  LAYER_NAME_TERRAIN_ANNOTATION_CHINESE : String = "cta"

    private static let  TILE_MATRIX_SET_MERCATOR : String = "w"
    private static let  TILE_MATRIX_SET_2000 : String = "c"

    private static let ORIGIN_2000: AGSPoint = AGSPointMake(-180, 90, AGSSpatialReference(wkid: LayerInfoFactory.SRID_2000))
    private static let ORIGIN_MERCATOR: AGSPoint = AGSPointMake(-20037508.3427892, 20037508.3427892, AGSSpatialReference(wkid: LayerInfoFactory.SRID_2000))

    private static let SRID_2000: Int = 4326
    private static let SRID_MERCATOR: Int = 3857

    private static let X_MIN_2000: Double = -180
    private static let Y_MIN_2000: Double = -90
    private static let X_MAX_2000: Double = 180
    private static let Y_MAX_2000: Double = 90

    private static let X_MIN_MERCATOR: Double = -20037508.3427892
    private static let Y_MIN_MERCATOR: Double = -20037508.3427892
    private static let X_MAX_MERCATOR: Double = 20037508.3427892
    private static let Y_MAX_MERCATOR: Double = 20037508.3427892

    private static let SCALES: [Double] = [2.958293554545656E8,
            1.479146777272828E8, 7.39573388636414E7, 3.69786694318207E7,
            1.848933471591035E7, 9244667.357955175, 4622333.678977588,
            2311166.839488794, 1155583.419744397, 577791.7098721985,
            288895.85493609926, 144447.92746804963, 72223.96373402482,
            36111.98186701241, 18055.990933506204, 9027.995466753102,
            4513.997733376551, 2256.998866688275, 1127.2338602399827,
            563.6169301199914]

    private static let RESOLUTIONS_MERCATOR: [Double] = [78271.51696402048,
            39135.75848201024, 19567.87924100512, 9783.93962050256,
            4891.96981025128, 2445.98490512564, 1222.99245256282,
            611.49622628141, 305.748113140705, 152.8740565703525,
            76.43702828517625, 38.21851414258813, 19.109257071294063,
            9.554628535647032, 4.777314267823516, 2.388657133911758,
            1.194328566955879, 0.5971642834779395]

    private static let RESOLUTIONS_2000: [Double] = [0.7031249999891485,
            0.35156249999999994, 0.17578124999999997, 0.08789062500000014,
            0.04394531250000007, 0.021972656250000007, 0.01098632812500002,
            0.00549316406250001, 0.0027465820312500017, 0.0013732910156250009,
            0.000686645507812499, 0.0003433227539062495,
            0.00017166137695312503, 0.00008583068847656251,
            0.000042915344238281406, 0.000021457672119140645,
            0.000010728836059570307, 0.000005364418029785169,
            2.682209014892579e-006, 1.3411045074462895e-006]
    
    private static let lods102100: [AGSLevelOfDetail] = [
        AGSLevelOfDetail(level: 1, resolution: 78271.51696402048, scale: 2.958293554545656E8),
        AGSLevelOfDetail(level: 2, resolution: 39135.75848201024, scale: 1.479146777272828E8),
        AGSLevelOfDetail(level: 3, resolution: 19567.87924100512, scale: 7.39573388636414E7),
        AGSLevelOfDetail(level: 4, resolution: 9783.93962050256, scale: 3.69786694318207E7),
        AGSLevelOfDetail(level: 5, resolution: 4891.96981025128, scale: 1.848933471591035E7),
        AGSLevelOfDetail(level: 6, resolution: 72445.98490512564, scale: 9244667.35795517),
        AGSLevelOfDetail(level: 7, resolution: 1222.99245256282, scale: 4622333.678977588),
        AGSLevelOfDetail(level: 8, resolution: 611.49622628141, scale: 2311166.839488794),
        AGSLevelOfDetail(level: 9, resolution: 305.748113140705, scale: 1155583.419744397),
        AGSLevelOfDetail(level: 10, resolution: 152.8740565703525, scale: 577791.7098721985),
        AGSLevelOfDetail(level: 11, resolution: 76.43702828517625, scale: 288895.85493609926),
        AGSLevelOfDetail(level: 12, resolution: 38.21851414258813, scale: 144447.92746804963),
        AGSLevelOfDetail(level: 13, resolution: 19.109257071294063, scale: 72223.96373402482),
        AGSLevelOfDetail(level: 14, resolution: 9.554628535647032, scale: 36111.98186701241),
        AGSLevelOfDetail(level: 15, resolution: 4.777314267823516, scale: 18055.990933506204),
        AGSLevelOfDetail(level: 16, resolution: 2.388657133911758, scale: 9027.995466753102),
        AGSLevelOfDetail(level: 17, resolution: 1.194328566955879, scale: 4513.997733376551),
        AGSLevelOfDetail(level: 18, resolution: 0.5971642834779395, scale: 2256.998866688275),
    ]
    
    private static let lods2000: [AGSLevelOfDetail] = [
        AGSLevelOfDetail(level: 1, resolution: 0.7031249999891485, scale: 2.958293554545656E8),
        AGSLevelOfDetail(level: 2, resolution: 0.35156249999999994, scale: 1.479146777272828E8),
        AGSLevelOfDetail(level: 3, resolution: 0.17578124999999997, scale: 7.39573388636414E7),
        AGSLevelOfDetail(level: 4, resolution: 0.08789062500000014, scale: 3.69786694318207E7),
        AGSLevelOfDetail(level: 5, resolution: 0.04394531250000007, scale: 1.848933471591035E7),
        AGSLevelOfDetail(level: 6, resolution: 0.021972656250000007, scale: 9244667.357955175),
        AGSLevelOfDetail(level: 7, resolution: 0.01098632812500002, scale: 4622333.678977588),
        AGSLevelOfDetail(level: 8, resolution: 0.00549316406250001, scale: 2311166.839488794),
        AGSLevelOfDetail(level: 9, resolution: 0.0027465820312500017, scale: 1155583.419744397),
        AGSLevelOfDetail(level: 10, resolution: 0.0013732910156250009, scale: 577791.7098721985),
        AGSLevelOfDetail(level: 11, resolution: 0.000686645507812499, scale: 288895.85493609926),
        AGSLevelOfDetail(level: 12, resolution: 0.0003433227539062495, scale: 144447.92746804963),
        AGSLevelOfDetail(level: 13, resolution: 0.00017166137695312503, scale: 72223.96373402482),
        AGSLevelOfDetail(level: 14, resolution: 0.00008583068847656251, scale: 36111.98186701241),
        AGSLevelOfDetail(level: 15, resolution: 0.000042915344238281406, scale: 18055.990933506204),
        AGSLevelOfDetail(level: 16, resolution: 0.000021457672119140645, scale: 9027.995466753102),
        AGSLevelOfDetail(level: 17, resolution: 0.000010728836059570307, scale: 4513.997733376551),
        AGSLevelOfDetail(level: 18, resolution: 0.000005364418029785169, scale: 2256.998866688275),
    ]
    

    public static func getLayerInfo(layerType: TianDiTuLayerTypes) -> TianDiTuLayerInfo {
        let layerInfo = TianDiTuLayerInfo()
        switch (layerType) {
            case .TIANDITU_IMAGE_2000:
                layerInfo.url = LayerInfoFactory.URL_IMAGE_2000
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE
                break
            case .TIANDITU_IMAGE_ANNOTATION_CHINESE_2000:
                layerInfo.url = LayerInfoFactory.URL_IMAGE_ANNOTATION_CHINESE_2000
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE_ANNOTATION_CHINESE
                break
            case .TIANDITU_IMAGE_ANNOTATION_ENGLISH_2000:
            layerInfo.url = LayerInfoFactory.URL_IMAGE_ANNOTATION_ENGLISH_2000
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE_ANNOTATION_ENGLISH
                break
            case .TIANDITU_IMAGE_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = LayerInfoFactory.URL_IMAGE_ANNOTATION_CHINESE_MERCATOR
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE_ANNOTATION_CHINESE
                break
            case .TIANDITU_IMAGE_ANNOTATION_ENGLISH_MERCATOR:
            layerInfo.url = LayerInfoFactory.URL_IMAGE_ANNOTATION_ENGLISH_MERCATOR
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE_ANNOTATION_ENGLISH
                break
            case .TIANDITU_IMAGE_MERCATOR:
                layerInfo.url = LayerInfoFactory.URL_IMAGE_MERCATOR
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_IMAGE
                break
            case .TIANDITU_VECTOR_2000:
                layerInfo.url = LayerInfoFactory.URL_VECTOR_2000
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR
                break
            case .TIANDITU_VECTOR_ANNOTATION_CHINESE_2000:
            layerInfo.url = LayerInfoFactory.URL_VECTOR_ANNOTATION_CHINESE_2000
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR_ANNOTATION_CHINESE
                break
            case TianDiTuLayerTypes.TIANDITU_VECTOR_ANNOTATION_ENGLISH_2000:
            layerInfo.url = LayerInfoFactory.URL_VECTOR_ANNOTATION_ENGLISH_2000
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR_ANNOTATION_ENGLISH
                break
            case .TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = LayerInfoFactory.URL_VECTOR_ANNOTATION_CHINESE_MERCATOR
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR_ANNOTATION_CHINESE
                break
            case .TIANDITU_VECTOR_ANNOTATION_ENGLISH_MERCATOR:
            layerInfo.url = LayerInfoFactory.URL_VECTOR_ANNOTATION_ENGLISH_MERCATOR
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR_ANNOTATION_ENGLISH
                break
            case .TIANDITU_VECTOR_MERCATOR:
                layerInfo.url = LayerInfoFactory.URL_VECTOR_MERCATOR
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_VECTOR
                break
            case .TIANDITU_TERRAIN_2000:
                layerInfo.url = LayerInfoFactory.URL_TERRAIN_2000
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_TERRAIN
                break
            case .TIANDITU_TERRAIN_ANNOTATION_CHINESE_2000:
            layerInfo.url = LayerInfoFactory.URL_TERRAIN_ANNOTATION_CHINESE_2000
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_TERRAIN_ANNOTATION_CHINESE
                break
            case .TIANDITU_TERRAIN_MERCATOR:
                layerInfo.url = LayerInfoFactory.URL_TERRAIN_MERCATOR
                layerInfo.layerName = LayerInfoFactory.LAYER_NAME_TERRAIN
                break
            case .TIANDITU_TERRAIN_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = LayerInfoFactory.URL_TERRAIN_ANNOTATION_CHINESE_MERCATOR
            layerInfo.layerName = LayerInfoFactory.LAYER_NAME_TERRAIN_ANNOTATION_CHINESE
                break
        }
        handleLayerInfo(layerInfo: layerInfo, layerType: layerType)
        return layerInfo
    }

    private static func handleLayerInfo(layerInfo: TianDiTuLayerInfo, layerType: TianDiTuLayerTypes) {
        switch (layerType) {
            case .TIANDITU_IMAGE_2000,
            .TIANDITU_IMAGE_ANNOTATION_CHINESE_2000,
            .TIANDITU_IMAGE_ANNOTATION_ENGLISH_2000,
            .TIANDITU_VECTOR_2000,
            .TIANDITU_VECTOR_ANNOTATION_CHINESE_2000,
            .TIANDITU_VECTOR_ANNOTATION_ENGLISH_2000,
            .TIANDITU_TERRAIN_2000,
            .TIANDITU_TERRAIN_ANNOTATION_CHINESE_2000:
                layerInfo.origin = LayerInfoFactory.ORIGIN_2000
                layerInfo.srid = LayerInfoFactory.SRID_2000
                layerInfo.xMin = LayerInfoFactory.X_MIN_2000
                layerInfo.yMin = LayerInfoFactory.Y_MIN_2000
                layerInfo.xMax = LayerInfoFactory.X_MAX_2000
                layerInfo.yMax = LayerInfoFactory.Y_MAX_2000
                layerInfo.scales = LayerInfoFactory.SCALES
                layerInfo.resolutions = LayerInfoFactory.RESOLUTIONS_2000
                layerInfo.tileMatrixSet = LayerInfoFactory.TILE_MATRIX_SET_2000
                layerInfo.lods = lods2000
                break
            case .TIANDITU_IMAGE_ANNOTATION_CHINESE_MERCATOR,
            .TIANDITU_IMAGE_ANNOTATION_ENGLISH_MERCATOR,
            .TIANDITU_IMAGE_MERCATOR,
            .TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR,
            .TIANDITU_VECTOR_ANNOTATION_ENGLISH_MERCATOR,
            .TIANDITU_VECTOR_MERCATOR,
            .TIANDITU_TERRAIN_MERCATOR,
            .TIANDITU_TERRAIN_ANNOTATION_CHINESE_MERCATOR:
                layerInfo.origin = LayerInfoFactory.ORIGIN_MERCATOR
                layerInfo.srid = LayerInfoFactory.SRID_MERCATOR
                layerInfo.xMin = LayerInfoFactory.X_MIN_MERCATOR
                layerInfo.yMin = LayerInfoFactory.Y_MIN_MERCATOR
                layerInfo.xMax = LayerInfoFactory.X_MAX_MERCATOR
                layerInfo.yMax = LayerInfoFactory.Y_MAX_MERCATOR
                layerInfo.scales = LayerInfoFactory.SCALES
                layerInfo.resolutions = LayerInfoFactory.RESOLUTIONS_MERCATOR
                layerInfo.tileMatrixSet = LayerInfoFactory.TILE_MATRIX_SET_MERCATOR
                layerInfo.lods = lods102100
                break;
        }
    }
}

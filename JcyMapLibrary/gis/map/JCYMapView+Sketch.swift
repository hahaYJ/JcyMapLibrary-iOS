//
//  JCYMapView+draw.swift
//  JcyMapLibrary-iOS
//
//  Created by 杨捷 on 2023/4/25.
//

import Foundation

/**
 绘图操作
 */
extension JCYMapView {
    
    /**
     * 绘面
     */
    func createModeFreehandPolygon() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .freehandPolygon)
    }

    /**
     * 点面
     */
    func createModePolygon() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .polygon)
    }
    
    /**
     绘图完成
     */
    func drawingFinish() {
//        if (mSketchEditor?.geometry == null || mSketchEditor?.geometry?.isEmpty == true) {
//               toast("请绘制图斑")
//               return@setOnClickListener
//           }
//           if (mSketchEditor?.isSketchValid == false) {
//               toast("至少选择三个点")
//               return@setOnClickListener
//           }
//           mSketchEditor?.geometry?.apply {
//               val geometryJson = toJson() ?: ""
//               lastSketchGeometryMd5 = geometryJson.md5()
//               createGeometry?.let { it(geometryJson) }
//               stopAndArea()
//           }
        guard let sketchEditor = mSketchEditor else { return }
    }
    
    /**
     * 删除绘制
     */
    func clearSketch() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.stop()
        sketchEditor.clearGeometry()
    }
}

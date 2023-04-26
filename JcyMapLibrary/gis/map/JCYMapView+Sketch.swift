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
    func createModeFreehandPolygon(onSketchGeometry: ((String) -> Void)?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .freehandPolygon)
    }

    /**
     * 点面
     */
    func createModePolygon(onSketchGeometry: ((String) -> Void)?) {
        self.onSketchGeometry = onSketchGeometry
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.start(with: nil, creationMode: .polygon)
    }
    
    /**
     绘图完成
     */
    func drawingFinish() {
        guard let sketchEditor = mSketchEditor else { return }
        if (sketchEditor.geometry == nil || sketchEditor.geometry?.isEmpty == true) {
            print("请绘制图斑")
            return
        }
        if (sketchEditor.isSketchValid == false) {
            print("至少选择三个点")
            return
        }
        guard let json = try? sketchEditor.geometry?.toJSON() as? NSDictionary else { return }
        if let onSketchGeometry = onSketchGeometry { onSketchGeometry(json.toJson()) }
        clearSketch()
    }
    
    /**
     * 删除绘制
     */
    func clearSketch() {
        guard let sketchEditor = mSketchEditor else { return }
        sketchEditor.stop()
        sketchEditor.clearGeometry()
        onSketchGeometry = nil
    }
}

//
//  JCYMapView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/5.
//

import Foundation

public protocol JCYMapView {
    
    /**
     添加图斑
     */
    func addProjectPolygon()
    
    /**
     清空图形选中状态
     */
    func clearGraphicsSelection()
}

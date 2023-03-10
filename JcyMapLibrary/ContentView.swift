//
//  ContentView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/4.
//

import SwiftUI
import ArcGIS

struct MapView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIView {
        return JCYWrapperMapView.createMapView {_ in
            
        }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MapView>) {
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            MapView().frame(maxWidth:.infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

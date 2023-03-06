//
//  ContentView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/4.
//

import SwiftUI
import ArcGIS

struct MapView: UIViewRepresentable {
    var bColor: UIColor
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIView {
        return createMapView {_ in
            
        }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MapView>) {
        uiView.backgroundColor = bColor
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            MapView(bColor: UIColor.blue).frame(width: 300, height: 300)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  JcyMapLibrary
//
//  Created by 杨捷 on 2023/3/4.
//

import SwiftUI
import ArcGIS

struct MapView: UIViewRepresentable {
    var mapState: Int
    var time: TimeInterval

    func addGraphics(mapView: JCYMapView) {
//        mapView.addProjectPolygon(polygon: "{\"geometry\":{\"type\":\"MultiPolygon\",\"coordinates\":[[[[36837909.785413630306721,2611221.517419451847672,0.0],[36837910.414232008159161,2611226.563728773035109,0.0],[36837914.254700198769569,2611231.014482215046883,0.0],[36837920.010079890489578,2611234.580277379136533,0.0],[36837923.651445552706718,2611235.469912651460618,0.0],[36837943.739792793989182,2611240.377904770895839,0.0],[36837949.230354629456997,2611240.492984909564257,0.0],[36837965.461057841777802,2611240.833174452651292,0.0],[36837981.399382010102272,2611239.047210437711328,0.0],[36837989.075674660503864,2611239.473030685912818,0.0],[36838008.765295997262001,2611248.366121780127287,0.0],[36838010.726919539272785,2611250.509233588352799,0.0],[36838029.316483557224274,2611252.395784619264305,0.0],[36838040.463774986565113,2611244.354254369158298,0.0],[36838040.070851035416126,2611225.94097257591784,0.0],[36838039.95740968734026,2611220.624906930606812,0.0],[36838038.544412404298782,2611217.20391013706103,0.0],[36838036.253175035119057,2611210.930926468223333,0.0],[36838034.118253491818905,2611205.615461499430239,0.0],[36838032.907592371106148,2611202.179675101302564,0.0],[36838031.759513929486275,2611198.921585516538471,0.0],[36838030.340016454458237,2611196.116548622492701,0.0],[36838029.398319460451603,2611195.173919820226729,0.0],[36838027.20831361413002,2611191.698075736407191,0.0],[36838023.88511523604393,2611186.423512443434447,0.0],[36838011.430864423513412,2611180.86682339431718,0.0],[36837993.825503006577492,2611175.677540662698448,0.0],[36837992.921050429344177,2611174.582745736464858,0.0],[36837966.264723338186741,2611175.006038865074515,0.0],[36837958.406462155282497,2611186.989863391499966,0.0],[36837942.792545258998871,2611198.697750110644847,0.0],[36837929.081712476909161,2611206.223701800685376,0.0],[36837923.136068023741245,2611210.254196655005217,0.0],[36837916.512975208461285,2611212.609909930732101,0.0],[36837909.008197218179703,2611215.279179650824517,0.0],[36837909.785413630306721,2611221.517419451847672,0.0]]]]}}".toParsePolygon(), id: "id", showTag: "showTag", pindding: 135, color: UIColor.red, isMoveToGeometry: true) { g in
//            print(g)
//        }
        
        mapView.showLocationAndOrientationOnMap(imageLocation: UIImage(named: "jcy_map_location_arrow"), longitude: 108.11, latitude: 23.44, azimuth: 90, height: 40, width: 23.5)
        mapView.addCircle(point: AGSPointMakeWGS84(23.44, 108.11), radius: 1 / 1000.0)
//
//        let arrowImg = UIImage(named: "map_arrow")
//        // 添加方向角
//        mapView.addPictureAngle(arrowImage: arrowImg, azimuth: 242.06, longitude: 111.30997668, latitude: 23.56701794, id: "Angle1", isSelected: true) { graphic in
//            print(graphic)
//        }
//        // 添加方向角
//        mapView.addPictureAngle(arrowImage: arrowImg, azimuth: 131.44, longitude: 111.30974884, latitude: 23.56688617, id: "Angle2", isSelected: false) { graphic in
//            print(graphic)
//        }
        
        
//        // 画线
//        let points = [AGSPoint(x: 108.4356464, y: 23.778678, spatialReference: nil), AGSPoint(x: 108.567378, y: 23.789065, spatialReference: nil), AGSPoint(x: 108.123469, y: 23.863097, spatialReference: nil)]
//        mapView.addGpsRouteLine(points: points, pindding: 135, isMoveToGeometry: true, isMoveUp: false)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            mapView.selecteAngle(id: "Angle2", isSelected: true)
//        })
//        mapView.addPictureMarker(image: UIImage(named: "map_arrow"), longitude: 111.30997668, latitude: 23.56701794, id: "Angle1", isSelected: true, pindding: 80.0, isMoveToGeometry: true, isMoveUp: true) { graphic in
//            print(graphic)
//        }
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIView {
        let mapView = JCYMapView()
        mapView.initMapView {
            JCYLocationService().startUpdatingLocation(allowsBackgroundLocationUpdates: true) { location in
                mapView.addCircle(point: AGSPointMakeWGS84(location.coordinate.latitude, location.coordinate.longitude), radius: 1 / 1000.0)
            }
            addGraphics(mapView: mapView)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MapView>) {
        guard let mapView = uiView as? JCYMapView else { return }
        switch(mapState) {
        case 0:
            mapView.clearAllGraphics()
            addGraphics(mapView: mapView)
            break
        case 1:
            mapView.createModeFreehandPolygon { code, area, geometryJson, msg in
                print("\(area)   \(geometryJson)")
            }
            break
        case 2:
            mapView.createModePolygon { code, area, geometryJson, msg in
                print("\(area)   \(geometryJson)")
            }
            break
        case 3:
            mapView.drawingFinish()
            break
        case 4:
            mapView.mapZoomin()
            break
        case 5:
            mapView.mapZoomout()
            break
        case 6:
//            mapView.zoomToLocation()
            break
        case 7:
            mapView.baseMapLayerStyle(basemapStyle: .TIANDITU_VECTOR)
            break
        default:
            break
        }
    }
}

struct ContentView: View {
    
    @State private var mapState = -1
    @State private var time = Date().timeIntervalSince1970

    var body: some View {
        ZStack {
            MapView(mapState: mapState, time: time).frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack(spacing: 10) {
                Button("重载") {
                    time = Date().timeIntervalSince1970
                    mapState = 0
                }
                Button("绘面") {
                    time = Date().timeIntervalSince1970
                    mapState = 1
                }
                Button("点面") {
                    time = Date().timeIntervalSince1970
                    mapState = 2
                }
                Button("结束绘") {
                    time = Date().timeIntervalSince1970
                    mapState = 3
                }
                Button("放大") {
                    time = Date().timeIntervalSince1970
                    mapState = 4
                }
                Button("缩小") {
                    time = Date().timeIntervalSince1970
                    mapState = 5
                }
                Button("定位") {
                    time = Date().timeIntervalSince1970
                    mapState = 6
                }
                Button("样式") {
                    time = Date().timeIntervalSince1970
                    mapState = 7
                }
            }.frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottom).background(Color.clear)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

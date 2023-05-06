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
//        mapView.addProjectPolygon(polygon: "{\"geometry\":{\"type\":\"MultiPolygon\",\"coordinates\":[[[[36837909.785413630306721,2611221.517419451847672,0.0],[36837910.414232008159161,2611226.563728773035109,0.0],[36837914.254700198769569,2611231.014482215046883,0.0],[36837920.010079890489578,2611234.580277379136533,0.0],[36837923.651445552706718,2611235.469912651460618,0.0],[36837943.739792793989182,2611240.377904770895839,0.0],[36837949.230354629456997,2611240.492984909564257,0.0],[36837965.461057841777802,2611240.833174452651292,0.0],[36837981.399382010102272,2611239.047210437711328,0.0],[36837989.075674660503864,2611239.473030685912818,0.0],[36838008.765295997262001,2611248.366121780127287,0.0],[36838010.726919539272785,2611250.509233588352799,0.0],[36838029.316483557224274,2611252.395784619264305,0.0],[36838040.463774986565113,2611244.354254369158298,0.0],[36838040.070851035416126,2611225.94097257591784,0.0],[36838039.95740968734026,2611220.624906930606812,0.0],[36838038.544412404298782,2611217.20391013706103,0.0],[36838036.253175035119057,2611210.930926468223333,0.0],[36838034.118253491818905,2611205.615461499430239,0.0],[36838032.907592371106148,2611202.179675101302564,0.0],[36838031.759513929486275,2611198.921585516538471,0.0],[36838030.340016454458237,2611196.116548622492701,0.0],[36838029.398319460451603,2611195.173919820226729,0.0],[36838027.20831361413002,2611191.698075736407191,0.0],[36838023.88511523604393,2611186.423512443434447,0.0],[36838011.430864423513412,2611180.86682339431718,0.0],[36837993.825503006577492,2611175.677540662698448,0.0],[36837992.921050429344177,2611174.582745736464858,0.0],[36837966.264723338186741,2611175.006038865074515,0.0],[36837958.406462155282497,2611186.989863391499966,0.0],[36837942.792545258998871,2611198.697750110644847,0.0],[36837929.081712476909161,2611206.223701800685376,0.0],[36837923.136068023741245,2611210.254196655005217,0.0],[36837916.512975208461285,2611212.609909930732101,0.0],[36837909.008197218179703,2611215.279179650824517,0.0],[36837909.785413630306721,2611221.517419451847672,0.0]]]]}}".toParsePolygon(), id: "Polygon1", pindding: 135, isMoveToGeometry: true) { graphic in
//            print(graphic)
//        }
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
        
        mapView.addAreaGeometry(geometryJson: "{\"rings\":[[[109.64038133215035,22.334784792209273],[109.64035087850176,22.334758270995113],[109.64031875303949,22.334727884567624],[109.64028277792433,22.334690225812835],[109.64024893365584,22.334647867805131],[109.6402114712738,22.334605336765328],[109.64017842805677,22.334562988716304],[109.64014183550334,22.334520374272543],[109.64010690698338,22.334477825805049],[109.64007875036695,22.334435183974914],[109.64005164127937,22.334397942239921],[109.64003281159077,22.334355183395278],[109.64001383252194,22.334321656248552],[109.64000388379894,22.334285203739086],[109.63999719903386,22.334255345121726],[109.63999901306997,22.334229343003848],[109.64000968939915,22.334205183242084],[109.64002343175746,22.334186342661173],[109.64004613381719,22.334172468972753],[109.64006813596832,22.334160184938895],[109.6401012196425,22.334151388933297],[109.64013590448597,22.334146290088277],[109.64017887495261,22.334147094251822],[109.64022168265703,22.334156487778319],[109.64026410103925,22.334160919391671],[109.64030213511185,22.334173835801813],[109.64034477943166,22.334189844382621],[109.64038934795549,22.334206271228059],[109.64043077669371,22.334229981604313],[109.64047724234641,22.334248568238838],[109.64051973043939,22.334267337864144],[109.64056205265808,22.334285949395376],[109.64060509159066,22.334304919439148],[109.64064069574492,22.334323745082035],[109.64067419581649,22.334337580180566],[109.64070290109402,22.334356717032257],[109.64072599963377,22.334375404498434],[109.64074513959754,22.334399642684819],[109.64076039754272,22.334421841831126],[109.64076990185956,22.334450356026458],[109.64077927484627,22.334478473119358],[109.64078242116726,22.334506699757757],[109.64077732232224,22.334535281174187],[109.64077266663855,22.334563065896088],[109.64076038073745,22.334584708601056],[109.64074393646432,22.334605347968846],[109.64072291493211,22.334623900992824],[109.64069859894353,22.334637273012653],[109.64067567281346,22.334650911427218],[109.64065235144821,22.334665538240941],[109.64063622554168,22.334674899401726],[109.64061902223028,22.334681668815602],[109.64060719007161,22.334688637403108],[109.64059771998774,22.334691866505644],[109.64058770466606,22.334691866505644],[109.64038133215035,22.334784792209273]]],\"spatialReference\":{\"wkid\":4326}}", id: "Area1", showTag: "建房", pindding: 135, isMoveToGeometry: false) { graphic in
            print(graphic)
        }
        
//        // 画线
//        let points = [AGSPoint(x: 108.4356464, y: 23.778678, spatialReference: nil), AGSPoint(x: 108.567378, y: 23.789065, spatialReference: nil), AGSPoint(x: 108.123469, y: 23.863097, spatialReference: nil)]
//        mapView.addGpsRouteLine(points: points, pindding: 135, isMoveToGeometry: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            mapView.selecteAngle(id: "Angle2", isSelected: true)
//        })
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIView {
        let mapView = JCYMapView()
        mapView.initMapView {
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
            mapView.createModeFreehandPolygon { geometryJson in
                print(geometryJson)
            }
            break
        case 2:
            mapView.createModePolygon { geometryJson in
                print(geometryJson)
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
            mapView.moveToGeometry(extent: mapView.mDrawGeometryExtent, pindding: 150.0, moveUp: true)
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

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
        
        mapView.addAreaGeometry(geometryJson: "{\"rings\":[[[108.3933714280287,22.739793300318023],[108.39336768300602,22.739778141684376],[108.39336302605838,22.739764725539313],[108.3933584065426,22.739753171947299],[108.39335608195323,22.739735840005505],[108.3933538063784,22.739719794872315],[108.39335200908391,22.739703353667629],[108.39334969480595,22.739690008713733],[108.393347380528,22.739678623776985],[108.393347380528,22.739669835340329],[108.39334969480595,22.739658268188094],[108.39335719304395,22.739641511143226],[108.39337206338162,22.739625437194565],[108.39338942089009,22.739611472990511],[108.39340752604706,22.739602690486453],[108.39342316536234,22.739596315769386],[108.39344217820671,22.739589392428325],[108.39345786681905,22.739584748617151],[108.39348736298662,22.739582432644163],[108.39352316013756,22.739583006128569],[108.39354985866174,22.739583006128569],[108.39357236425215,22.739583006128569],[108.39359292112559,22.739583006128569],[108.39361345031358,22.73958532040653],[108.39363991068636,22.73958532040653],[108.3936596014006,22.739590475833594],[108.39367762773878,22.739595117384731],[108.3936911169113,22.739601928288952],[108.39369995464502,22.739609267194329],[108.39371245900638,22.739616563724017],[108.39372677083237,22.739630913829401],[108.3937378341376,22.739650012555177],[108.39374641973593,22.739663166818445],[108.3937529262414,22.73967490403847],[108.39375754928849,22.739686458760502],[108.39376220439985,22.739698110381624],[108.39376679891396,22.739714741994433],[108.39376915782765,22.739728227635638],[108.39376857911691,22.739739195595543],[108.39376570265473,22.739745567770068],[108.39376626483894,22.739755247226338],[108.393763950561,22.739762161527256],[108.39376163628303,22.739768586812648],[108.39375650769391,22.739778405543706],[108.39375189679453,22.739787627342469],[108.3937449792448,22.739794062515525],[108.39373753708398,22.739803819095563],[108.39373333680508,22.739808019374461],[108.39372641078022,22.739812630980104],[108.39371662029963,22.739819584831668],[108.39371253259883,22.739824195024791],[108.39370001933858,22.739829283498256],[108.39369110448109,22.739833499879918],[108.39367964439812,22.739835262426329],[108.39366740544986,22.739840444126322],[108.39365871927988,22.739842749646641],[108.3936523280363,22.73984220526021],[108.3936453757385,22.739845066184639],[108.39363844957239,22.739847363794826],[108.39363147975932,22.739846833816134],[108.39362451206503,22.739849148094095],[108.39361761711568,22.739851996305813],[108.39361066637167,22.739851462372055],[108.39360773679861,22.739854933788997],[108.39360370234994,22.739853776650016],[108.39360137182796,22.739856090927979],[108.3935993442922,22.739856090927979],[108.39359963682575,22.739853482280189],[108.3935921195187,22.73985088775763],[108.3933714280287,22.739793300318023]]],\"spatialReference\":{\"wkid\":4326}}", id: "Area1", showTag: "建房", pindding: 135, isMoveToGeometry: false) { graphic in
            print(graphic)
        }

        mapView.addAreaGeometry(geometryJson: "{\"rings\":[[[108.39314847828786,22.738330085266917],[108.39314421464677,22.73831307790855],[108.39314304195665,22.738299847025896],[108.39314304195665,22.738289499482448],[108.39314496965868,22.738278603028256],[108.39314644427803,22.738262425172781],[108.39314768249001,22.738250601404978],[108.3931529949528,22.738238183597545],[108.39315730353394,22.738229226552452],[108.39316567031588,22.73821999306934],[108.39317324847528,22.738210867971077],[108.39318258769971,22.738199981902195],[108.39319213717943,22.738190718207274],[108.39320108015714,22.738184851452257],[108.3932190614686,22.738177063604045],[108.39323086474901,22.738174560178297],[108.39324487094214,22.738173013333846],[108.39325910221321,22.738176425757299],[108.39327651705329,22.738186717031258],[108.39329356708585,22.738200999662396],[108.39331227385827,22.738220406593431],[108.39332185789274,22.738231485073751],[108.39332934513349,22.738242097159322],[108.39333588665031,22.738253283835675],[108.39334023176885,22.738269222073765],[108.39334451089347,22.73829013355272],[108.3933491163056,22.73831962216331],[108.39335031911313,22.738344374695711],[108.39334688799612,22.738365637386906],[108.3933384293514,22.738383960847056],[108.3933256497576,22.738398772562444],[108.39331157200027,22.738407560610248],[108.39329952560922,22.738413421511726],[108.39328903956353,22.7384161855143],[108.39327979475098,22.738417414757144],[108.39327389438533,22.738415553332267],[108.39327113878542,22.738415867912693],[108.39326988320165,22.738414011774879],[108.39314847828786,22.738330085266917]]],\"spatialReference\":{\"wkid\":4326}}", id: "Area2", showTag: "啦啦", pindding: 135, isMoveToGeometry: false) { graphic in
            print(graphic)
        }
        
//        // 画线
//        let points = [AGSPoint(x: 108.4356464, y: 23.778678, spatialReference: nil), AGSPoint(x: 108.567378, y: 23.789065, spatialReference: nil), AGSPoint(x: 108.123469, y: 23.863097, spatialReference: nil)]
//        mapView.addGpsRouteLine(points: points, pindding: 135, isMoveToGeometry: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            mapView.selecteAngle(id: "Angle2", isSelected: true)
//        })
        mapView.addPictureMarker(image: UIImage(named: "map_arrow"), longitude: 111.30997668, latitude: 23.56701794, id: "Angle1", isSelected: true, pindding: 80.0, isMoveToGeometry: true, isMoveUp: true) { graphic in
            print(graphic)
        }
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIView {
        let mapView = JCYMapView()
        mapView.initMapView {
            mapView.startUpdatingLocation { location in
                print("\(location.horizontalAccuracy) \(location.coordinate.longitude)  \(location.coordinate.latitude)")
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
            mapView.zoomToLocation()
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

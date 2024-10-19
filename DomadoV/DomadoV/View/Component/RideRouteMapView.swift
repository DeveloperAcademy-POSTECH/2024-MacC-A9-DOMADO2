//
//  RideRouteMapView.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import SwiftUI
import MapKit


struct RideRouteMapView: View {
    let routes: [[CLLocationCoordinate2D]]
    @State private var position: MapCameraPosition
    
    init(route: [CLLocationCoordinate2D], maxDistanceGap: CLLocationDistance = 100) {
        self.routes = Self.splitRoute(route, maxDistanceGap: maxDistanceGap)
        
        if let firstCoordinate = route.first {
            _position = State(initialValue: .region(MKCoordinateRegion(
                center: firstCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            _position = State(initialValue: .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )))
        }
    }
    
    var body: some View {
        if routes.isEmpty {
            VStack(spacing: 18){
                Image(systemName: "mappin.slash")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                Text("유효한 주행 경로가 없습니다")
                    .customFont(.subInfoTitle)
            }
            .frame(height: 300)
        } else {
            Map(position: $position) {
                ForEach(routes.indices, id: \.self) { index in
                    let route = routes[index]
                    MapPolyline(coordinates: route)
                        .stroke(
                            .lavenderPurple,
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    
                    if index == 0, let startPoint = route.first {
                        Marker("시작", coordinate: startPoint)
                            .tint(.electricBlue)
                    }
                    
                    if index == routes.count - 1, let endPoint = route.last {
                        Marker("도착", coordinate: endPoint)
                            .tint(.sunsetOrange)
                    }
                }
            }
            .frame(height: 300)
            .onAppear {
                setRegionToFitAllRoutes()
            }
        }
    }
    
    private static func splitRoute(_ route: [CLLocationCoordinate2D], maxDistanceGap: CLLocationDistance) -> [[CLLocationCoordinate2D]] {
        var routes: [[CLLocationCoordinate2D]] = []
        var currentSegment: [CLLocationCoordinate2D] = []
        
        for (index, coordinate) in route.enumerated() {
            if index == 0 {
                currentSegment.append(coordinate)
                continue
            }
            
            let previousCoordinate = route[index - 1]
            let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                .distance(from: CLLocation(latitude: previousCoordinate.latitude, longitude: previousCoordinate.longitude))
            
            if distance > maxDistanceGap && !currentSegment.isEmpty {
                routes.append(currentSegment)
                currentSegment = [coordinate]
            } else {
                currentSegment.append(coordinate)
            }
        }
        
        if !currentSegment.isEmpty {
            routes.append(currentSegment)
        }
        
        return routes
    }
    
    private func setRegionToFitAllRoutes() {
        guard !routes.isEmpty else { return }
        
        var minLat = Double.greatestFiniteMagnitude
        var maxLat = -Double.greatestFiniteMagnitude
        var minLon = Double.greatestFiniteMagnitude
        var maxLon = -Double.greatestFiniteMagnitude
        
        for route in routes {
            for coordinate in route {
                minLat = min(minLat, coordinate.latitude)
                maxLat = max(maxLat, coordinate.latitude)
                minLon = min(minLon, coordinate.longitude)
                maxLon = max(maxLon, coordinate.longitude)
            }
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.1,
            longitudeDelta: (maxLon - minLon) * 1.1
        )
        
        position = .region(MKCoordinateRegion(center: center, span: span))
    }
}

struct StartPoint: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green)
                .frame(width: 30, height: 30)
            Image(systemName: "figure.walk")
                .foregroundColor(.white)
        }
    }
}

struct EndPoint: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 30, height: 30)
            Image(systemName: "flag.checkered")
                .foregroundColor(.white)
        }
    }
}

struct RideRouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 연속적인 경로가 있는 경우
            RideRouteMapView(route: [
                CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                CLLocationCoordinate2D(latitude: 37.5668, longitude: 126.9782),
                CLLocationCoordinate2D(latitude: 37.5670, longitude: 126.9785),
                CLLocationCoordinate2D(latitude: 37.5672, longitude: 126.9788),
                CLLocationCoordinate2D(latitude: 37.5675, longitude: 126.9790),
                CLLocationCoordinate2D(latitude: 37.5678, longitude: 126.9793),
                CLLocationCoordinate2D(latitude: 37.5680, longitude: 126.9795),
                CLLocationCoordinate2D(latitude: 37.5683, longitude: 126.9798),
                CLLocationCoordinate2D(latitude: 37.5685, longitude: 126.9800),
                CLLocationCoordinate2D(latitude: 37.5688, longitude: 126.9803),
                CLLocationCoordinate2D(latitude: 37.5690, longitude: 126.9805),
                CLLocationCoordinate2D(latitude: 37.5693, longitude: 126.9808),
                CLLocationCoordinate2D(latitude: 37.5695, longitude: 126.9810),
                CLLocationCoordinate2D(latitude: 37.5698, longitude: 126.9813),
                CLLocationCoordinate2D(latitude: 37.5700, longitude: 126.9815)
            ])
            .previewDisplayName("Continuous Route")

            // 중간에 끊긴 경로가 있는 경우
            RideRouteMapView(route: [
                CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                CLLocationCoordinate2D(latitude: 37.5668, longitude: 126.9782),
                CLLocationCoordinate2D(latitude: 37.5670, longitude: 126.9785),
                CLLocationCoordinate2D(latitude: 37.5672, longitude: 126.9788),
                CLLocationCoordinate2D(latitude: 37.5675, longitude: 126.9790),
                // 큰 간격
                CLLocationCoordinate2D(latitude: 37.5700, longitude: 126.9820),
                CLLocationCoordinate2D(latitude: 37.5703, longitude: 126.9823),
                CLLocationCoordinate2D(latitude: 37.5705, longitude: 126.9825),
                // 다른 큰 간격
                CLLocationCoordinate2D(latitude: 37.5730, longitude: 126.9855),
                CLLocationCoordinate2D(latitude: 37.5733, longitude: 126.9858),
                CLLocationCoordinate2D(latitude: 37.5735, longitude: 126.9860)
            ], maxDistanceGap: 300)  // 300미터 이상의 간격을 끊김으로 간주
            .previewDisplayName("Discontinuous Route")

            // 경로가 없는 경우
            RideRouteMapView(route: [])
            .previewDisplayName("Without Route")
        }
    }
}

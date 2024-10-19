//
//  RideRouteMapView.swift
//  DomadoV
//
//  Created by 이종선 on 10/19/24.
//

import SwiftUI
import MapKit


struct RideRouteMapView: View {
    let route: [CLLocationCoordinate2D]
    @State private var position: MapCameraPosition
    
    init(route: [CLLocationCoordinate2D]) {
        self.route = route
        
        // 초기 위치 설정
        if let firstCoordinate = route.first {
            _position = State(initialValue: .region(MKCoordinateRegion(
                center: firstCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            // 기본 위치 설정 (예: 서울)
            _position = State(initialValue: .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )))
        }
    }
    
    var body: some View {
        if route.isEmpty {
            Text("경로 없음")
                .font(.title)
                .foregroundColor(.secondary)
                .frame(height: 300)
        } else {
            Map(position: $position) {
                MapPolyline(coordinates: route)
                    .stroke(
                        .lavenderPurple,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    
            }
            .frame(height: 300)
            .onAppear {
                setRegionToFitRoute()
            }
        }
    }
    
    private func setRegionToFitRoute() {
        guard !route.isEmpty else { return }
        
        var minLat = route[0].latitude
        var maxLat = route[0].latitude
        var minLon = route[0].longitude
        var maxLon = route[0].longitude
        
        for coordinate in route {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
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

struct RideRouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 경로가 있는 경우
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
            .previewDisplayName("With Route")

            // 경로가 없는 경우
            RideRouteMapView(route: [])
            .previewDisplayName("Without Route")
        }
    }
}

//
//  RidePreparationView.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import MapKit
import SwiftUI

/// 주행 시작전 화면
///
/// 1.  사용자로부터 원하는 속도 범위를 입력받습니다.
/// 2. 사용자의 지도상의 현재 위치를 표시합니다.
/// 3. 시작 버튼을 눌러 주행을 시작합니다.
struct RidePreparationView: View {
    
    @ObservedObject var vm: RidePreparationViewModel
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        
        VStack(spacing: 20){
            
            Map(position: $position) {
                UserAnnotation()
            }
            .mapStyle(.standard)
            .edgesIgnoringSafeArea(.all)
            .frame(height: 300)
            
            Text("주행 속도 범위 입력받는 arc 모양 Slider")
            
            Button {
                vm.startRide()
            } label: {
                Text("시작 버튼")
            }
            
            Button {
                vm.showHistory()
            } label: {
                Text("주행 기록 보기 버튼")
            }
            
            Spacer()
            
        }
        .onAppear {
            vm.prepareRide()
        }
        .alert(isPresented: $vm.showLocationPermissionAlert) {
            Alert(
                title: Text("위치 권한 필요"),
                message: Text("이 앱은 위치 정보를 사용하여 주행을 기록합니다. 설정에서 위치 권한을 허용해주세요."),
                primaryButton: .default(Text("설정으로 이동")) {
                    vm.openSystemSettings()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

#Preview {
    RidePreparationView(vm: RidePreparationViewModel(rideSession: RideSession()))
}

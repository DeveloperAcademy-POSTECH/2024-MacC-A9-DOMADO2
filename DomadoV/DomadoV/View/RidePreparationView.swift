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
        
        ZStack {
            VStack(spacing: 0){
                // 지도 표시
                Map(position: $position) {
                    UserAnnotation()
                }
                .mapStyle(.standard)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 400)
                
                Spacer()
            }
            GeometryReader { geometry in
                VStack(spacing: 0){
                    // 운동 기록 버튼
                    HStack {
                        Spacer()
                        
                        Button {
                            vm.showHistory()
                        } label: {
                            Text("운동 기록")
                                .foregroundStyle(.lavenderPurple)
                        }
                    }
                    
                    // 페이스 설정
                    VStack(spacing: 0){
                        Text("페이스 설정")
                            .customFont(.pageTitle)
                            .padding(.top, 28)
                        
                        HStack (spacing: 20){
                            Text("\(vm.userSettingTargetSpeedRange.lowerBound.formatToDecimal(0))")
                                .customFont(.paceSettingNumber)
                                .frame(width: 70, alignment: .trailing)
                            Text("-")
                                .customFont(.supplementaryTimeDistanceNumber)
                                .opacity(0.3)
                            Text("\(vm.userSettingTargetSpeedRange.upperBound.formatToDecimal(0))")
                                .customFont(.paceSettingNumber)
                                .frame(width: 70, alignment: .leading)
                            Text("km/h")
                                .customFont(.supplementaryTimeDistanceNumber)
                                .opacity(0.3)
                                .offset(y:10)
                        }
                        .frame(width: 350)
                        .padding(.bottom, 28)
                        
                    }
                    
                    // 양방향 슬라이더
                    ArcRangeSlider(range: $vm.userSettingTargetSpeedRange)
                        .frame(width: 300, height: 200)
                        .padding(.bottom, 10)
                    
                    // 라이딩 시작 버튼
                    Button {
                        vm.startRide()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 145, height: 145)
                                .foregroundStyle(.lavenderPurple)
                            Text("라이딩 시작")
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .padding(30)
                .background(Color(.systemBackground))
                .cornerRadius(35)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: -1)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
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
}

#Preview {
    RidePreparationView(vm: RidePreparationViewModel(rideSession: RideSession()))
}

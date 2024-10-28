//
//  ActiveRideView.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import SwiftUI

/// 주행 중 화면
///
/// 1. 주행거리, 주행시간을 보여줍니다.
/// 2. 사용자의 현재 속도를 보여줍니다.
/// 3. 사용자가 설정한 속도범위를 기준으로 현재 속도 상태를 배경색으로 보여줍니다.
/// 4. 일시정지 버튼을 눌러 주행을 정지합니다.
struct ActiveRideView: View {
    
    @ObservedObject var vm: ActiveRideViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            speedometer
                .padding(.bottom, 135)
            
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 45) {
                    timeView
                    distanceView
                }
                Spacer()
            }
            .padding(.bottom, 50)
            
            pauseButton
        }
        .padding([.horizontal, .bottom], 30)
        .background(
            // 페이스 기준 현재 속도에 따라 색상 변경
            colorScheme == .dark ? vm.backgroundColorDark : vm.backgroundColor
        )
    }
    
    private var speedometer: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 0){
                HStack (alignment: .bottom, spacing: 0){
                    Text(vm.formattedCurrentSpeed())
                        .customFont(.mainNumber)
                        .offset(y: 37)
                        .foregroundColor(.white)
                    
                    Text("km/h")
                        .customFont(.supplementaryTimeDistanceNumber)
                        .foregroundColor(.white)
                }
                .offset(y: -74)
                .padding(.bottom, -62)
                
                Text("현재 속도")
                    .customFont(.infoTitle)
                    .foregroundColor(.white)
            }
            .padding(.top, 160)
            
            
        }
    }
    private var timeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("시간")
                .customFont(.infoTitle)
                .foregroundColor(.white)
                .padding(.bottom, 6)
            
            Text(vm.formattedTotalRideTime())
                .customFont(.baseTimeDistanceNumber)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
        }
        
    }
    
    private var distanceView: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("거리")
                .customFont(.infoTitle)
                .foregroundColor(.white)
                .padding(.bottom, 6)
            
            Text(vm.formattedTotalDistance())
                .customFont(.baseTimeDistanceNumber)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        
    }
    
    private var pauseButton: some View {
        HStack {
            Button(action: {
                vm.pauseRide()
            }) {
                Circle()
                    .stroke(.white,lineWidth: 1)
                    .frame(width: 104, height: 104)
                    .overlay(
                        Image(systemName: "pause.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                            .foregroundColor(.white)
                    )
            }
            Spacer()
        }
    }
}

#Preview {
    ActiveRideView(vm: ActiveRideViewModel(rideSession: RideSession()))
}

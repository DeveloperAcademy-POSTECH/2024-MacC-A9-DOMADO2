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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                speedometer
                
                HStack(spacing: 20) {
                    distanceView
                    Divider().background(Color.white)
                    timeView
                }
                
                Spacer()
                
                pauseButton
            }
            .padding()
        }
    }
    
    private var speedometer: some View {
        VStack {
            Text("Current Speed")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(vm.formattedCurrentSpeed())
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(.green)
        }
    }
    
    private var distanceView: some View {
        VStack {
            Text("Distance")
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(vm.formattedTotalDistance())
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
    
    private var timeView: some View {
        VStack {
            Text("Time")
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(vm.formattedTotalRideTime())
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
    
    private var pauseButton: some View {
        Button(action: {
            vm.pauseRide()
        }) {
            Text("Pause")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ActiveRideView(vm: ActiveRideViewModel(rideSession: RideSession()))
}

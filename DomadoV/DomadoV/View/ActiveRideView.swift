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
                
                pauseButton
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 30)
            .background(Color.indigo)
        }
    }
    
    private var speedometer: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 0){
                Text(vm.formattedCurrentSpeed())
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .padding(.bottom, 22)
                    .foregroundColor(.white)
                
                Text("현재 속도")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.top, 160)
        }
    }
    private var timeView: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("시간")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text(vm.formattedTotalRideTime())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

            }

    }
    
    private var distanceView: some View {
            VStack(alignment: .leading, spacing: 0){
                Text("거리")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text(vm.formattedTotalDistance())
                    .font(.title2)
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

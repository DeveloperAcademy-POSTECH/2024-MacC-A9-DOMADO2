//
//  PauseRideView.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import SwiftUI

/// 주행 일시 정지 화면
///
/// 1. 현재까지 주행 거리를 보여줍니다.
/// 2. 현재까지 주행 시간을 보여줍니다.
/// 3. 현재 휴식시간을 카운트 합니다.
/// 4. 재개버튼을 눌러 주행을 다시 시작합니다.
/// 5. 종료 버튼을 눌러 주행을 종료합니다.
struct PauseRideView: View {
    
    @ObservedObject var vm: PauseRideViewModel
    
    @State private var showAlert = false
    @State private var isActive = false
    
    var body: some View {
            ZStack {
                mainContent
                if showAlert { alertView }


            }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack(spacing: 45) {
            distanceSection
            timeSection
            restTimeSection
            Spacer()
            buttonSection
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Distance Section
    
    private var distanceSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("거리")
                    .customFont(.infoTitle)
                Spacer()
            }
            Text("105 km")
                .customFont(.baseTimeDistanceNumber)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 37)
    }
    
    // MARK: - Time Section
    
    private var timeSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("시간")                                .customFont(.infoTitle)
                Spacer()
            }
            Text("01:30:27")
                .customFont(.baseTimeDistanceNumber)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Rest Time Section
    
    private var restTimeSection: some View {
        VStack(spacing: 17) {
            Text("휴식 시간")
                .customFont(.infoTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("12:45")
                .customFont(.paceSettingNumber)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 65)
    }
    
    // MARK: - Button Section
    
    private var buttonSection: some View {
        HStack(spacing: 125) {
            stopButton
            playButton
        }
    }
    
    private var stopButton: some View {
        Button(action: { showAlert = true }) {
            Image(systemName: "stop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
                .frame(width: 104, height: 104)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
        }
        .gesture(
            LongPressGesture(minimumDuration: 1.0)
                .onEnded { _ in
                    vm.finishRide()
                    self.isActive = true
                }
        )
    }
    
    private var playButton: some View {
        Button{
            vm.resumeRide()
        } label: {
            
            Image(systemName: "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .frame(width: 104, height: 104)
                .background(Color.lavenderPurple)
                .clipShape(Circle())
        }
    }
    
    // MARK: - AlertView
    
    private var alertView: some View {
        VStack(alignment: .center) {
            Spacer()
            alertContent
            .overlay(alignment: .topTrailing) {
            closeButton
                        }
            .frame(width: 333, height: 88)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            Spacer().frame(height: 530)
        }
    }
    
    private var alertContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "exclamationmark.bubble")
                .foregroundColor(.midnightCharcoal)
                .opacity(0.5)
            Text("길게 눌러서 주행을 종료하세요.")
                .customFont(.infoTitle)
                .foregroundColor(.midnightCharcoal)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var closeButton: some View {
        Button(action: { showAlert = false }) {
            Image(systemName: "xmark")
                .foregroundColor(.midnightCharcoal)
                .opacity(0.3)
                .padding(.vertical, -20)
                .padding(.horizontal, 10)
        }
    }
}

#Preview {
    PauseRideView(vm: PauseRideViewModel(rideSession: RideSession()))
}

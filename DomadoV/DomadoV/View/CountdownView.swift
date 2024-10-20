//
//  CountdownView.swift
//  DomadoV
//
//  Created by 이종선 on 10/20/24.
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var vm: CountdownViewModel
    
    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
            
            // 채워진 부분
            Circle()
                .trim(from: 0, to: CGFloat(vm.countdownTime) / 3.0)
                .stroke(.sunsetOrange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: vm.countdownTime)
            
            // 카운트다운 숫자
            Text("\(vm.countdownTime)")
                .customFont(.paceSettingNumber)
        }
        .frame(width: 300, height: 300)
        .onAppear {
            vm.startCountdown()
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(vm: CountdownViewModel(rideSession: RideSession()))
    }
}

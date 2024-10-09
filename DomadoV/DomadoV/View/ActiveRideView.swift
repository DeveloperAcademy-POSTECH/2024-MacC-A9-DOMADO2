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
    var body: some View {
        ZStack{
            /// 배경색
            Color.yellow.ignoresSafeArea()
            
            VStack(spacing: 20){
                HStack{
                    Text("거리")
                    
                    Text("시간")
                }
                
                Text("현재 속도")
                
                Text("일시정지버튼")
            }
        }
    }
}

#Preview {
    ActiveRideView()
}

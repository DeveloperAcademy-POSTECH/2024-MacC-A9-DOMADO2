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
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("주행거리")
                Text("주행시간")
            }
            
            Text("휴식시간")
            
            HStack{
                Text("종료버튼")
                Text("재개버튼")
            }
        }
    }
}

#Preview {
    PauseRideView()
}

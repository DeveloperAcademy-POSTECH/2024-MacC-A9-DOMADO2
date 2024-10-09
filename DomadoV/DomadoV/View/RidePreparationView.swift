//
//  RidePreparationView.swift
//  DomadoV
//
//  Created by 이종선 on 10/8/24.
//

import SwiftUI

/// 주행 시작전 화면
///
/// 1.  사용자로부터 원하는 속도 범위를 입력받습니다.
/// 2. 사용자의 지도상의 현재 위치를 표시합니다.
/// 3. 시작 버튼을 눌러 주행을 시작합니다.
struct RidePreparationView: View {
    
    @ObservedObject var vm: RidePreparationViewModel
    
    var body: some View {
        VStack(spacing: 20){
            Text("주행 속도 범위 입력받는 arc 모양 Slider")
            
            Text("지도상의 현재 사용자 위치")
            
            Text("시작 버튼 ")
        }
    }
}

#Preview {
    RidePreparationView(vm: RidePreparationViewModel())
}

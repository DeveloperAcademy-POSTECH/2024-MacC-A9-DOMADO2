//
//  RideHistoryView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

/// 주행 기록 화면
///
/// 1. 현재까지의 주행기록을 리스트의 형태로 보여줍니다.
/// 2. 각 셀을 눌렀을 때 해당 기록에 대한 상세뷰로 이동합니다.
struct RideHistoryView: View {
    
    @ObservedObject var vm: RideHistoryViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20){
                
                Button {
                    vm.returnToPreparation()
                } label: {
                    Text("주행 준비 화면으로 돌아가기")
                }

                NavigationLink(destination: RideDetailView()){
                    RideHistoryCell()
                }
            }
        }
    }
}

#Preview {
    RideHistoryView(vm: RideHistoryViewModel())
}

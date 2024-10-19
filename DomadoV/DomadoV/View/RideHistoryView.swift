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
    
    
    // Properties
    @ObservedObject var vm: RideHistoryViewModel
    
    
    // Body
    var body: some View {
        NavigationView {
            VStack(spacing: 1) {
                navigationBar
                Divider()
                historyList
            }
        }
    }
    

    //MARK: - navigationBar
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                vm.returnToPreparation()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.lavenderPurple)
            }
            .padding(.leading, 20)
            
            Spacer()
            
            Text("운동 기록")
                .font(.system(size: 20))
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
    }
    
    
    // MARK: - List
    
    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(record) { workout in
                    NavigationLink(destination: RideDetailView()) {
                        RideHistoryCell(workout: workout)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .background(Color.gray.opacity(0.1))
                }
            }
        }
    }
}


#Preview {
    RideHistoryView(vm: RideHistoryViewModel())
}

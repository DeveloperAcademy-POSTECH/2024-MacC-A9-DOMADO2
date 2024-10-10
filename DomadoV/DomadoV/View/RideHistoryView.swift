//
//  RideHistoryView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

struct RideHistoryView: View {
    
    @ObservedObject var vm: RideHistoryViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RideHistoryView(vm: RideHistoryViewModel())
}

//
//  FontView.swift
//  DomadoV
//
//  Created by 이종선 on 10/10/24.
//

import SwiftUI

struct FontView: View {
    var body: some View {
        VStack(alignment: .leading){
         
            Text("메인 123")
                .customFont(.mainNumber)
            Text("페이스 123")
                .customFont(.paceSettingNumber)
            Text("기본 시간 거리 123")
                .customFont(.baseTimeDistanceNumber)
            Text("부가 시간 거리 123")
                .customFont(.supplementaryTimeDistanceNumber)
            Text("리스트용 표시 123")
                .customFont(.listNumber)
            Text("페이스 단위 표시 123")
                .customFont(.paceUnitNumber)
            Text("페이지 제목 글씨")
                .customFont(.pageTitle)
            Text("정보 주제 글씨")
                .customFont(.infoTitle)
            Text("부가 정보 글씨")
                .customFont(.subInfoTitle)

        }
    }
}

#Preview {
    FontView()
}

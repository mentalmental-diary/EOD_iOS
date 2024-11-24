//
//  HousePreviewView.swift
//  EOD
//
//  Created by JooYoung Kim on 11/4/24.
//

import SwiftUI
import Kingfisher

// 각 RoomThemeType에 대한 고정 좌표를 설정
let themeCoordinates: [RoomThemeItemType: CGPoint] = [
    .wallpaper: CGPoint(x: 0, y: 0),
    .flooring: CGPoint(x: 0, y: 300),
    // 나머지 RoomThemeType에 대한 좌표를 추가
] // TODO: 디자인 명확하게 나오면 그때 진행 현재는 임시 좌표 진행

struct HousePreviewView: View {
    var backgroundUrl: String?
    var themeItemList: [ThemeItem]?
    
    var body: some View {
        ZStack {
            KFImage(backgroundUrl?.url)
                .resizable()
            
            ForEach(themeItemList ?? [], id: \.id) { item in
                if let coordinates = themeCoordinates[item.type] {
                    KFImage(item.homeImageUrl.url)
                        .resizable()
                        .position(coordinates)
                }
            }
        }
    }
}

#Preview {
    HousePreviewView()
}

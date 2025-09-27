//
//  HousePreviewView.swift
//  EOD
//
//  Created by JooYoung Kim on 11/4/24.
//

import SwiftUI
import Kingfisher

public enum HousePreviewViewType {
    case home
    case house
}

struct HousePreviewView: View {
    var themeItemList: [ThemeItem]?
    var viewType: HousePreviewViewType = .house
    
    var body: some View {
        GeometryReader { geometry in
            let screenCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let themeCoordinates = calculateThemeCoordinates(center: screenCenter)
            
            ZStack {
                ForEach(RoomThemeItemType.allCases, id: \.rawValue) { type in
                    if type == .backGround {
                        // 배경은 전체 화면을 채우므로 좌표 없이 처리
                        if let item = themeItemList?.first(where: { $0.type == type }) {
                            KFImage(item.homeImageUrl.url)
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .ignoresSafeArea()
                        } else {
                            Image(type.imageName)
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .ignoresSafeArea()
                        }
                    } else if let coordinates = themeCoordinates[type] {
                        // 배경이 아닌 다른 아이템들은 좌표를 사용
                        if let item = themeItemList?.first(where: { $0.type == type }) {
                            KFImage(item.homeImageUrl.url)
                                .resizable()
                                .scaledToFit()
                                .frame(width: type.frameSize(for: viewType)?.width, height: type.frameSize(for: viewType)?.height)
                                .position(coordinates)
                        } else if [.wallpaper, .flooring].contains(type) {
                            Image(type.imageName)
                                .position(coordinates)
                        }
                    }
                }
            }
        }
    }
}

extension HousePreviewView {
    private func calculateThemeCoordinates(center: CGPoint) -> [RoomThemeItemType: CGPoint] {
        return [
            .wallpaper: CGPoint(x: center.x, y: center.y - 80),
            .flooring: CGPoint(x: center.x, y: center.y + 70),
            .parts1: CGPoint(x: center.x - 50, y: center.y - 80),
            .parts2: CGPoint(x: center.x + 50, y: center.y - 80),
            .parts3: CGPoint(x: center.x - 50, y: center.y),
            .parts4: CGPoint(x: center.x + 50, y: center.y),
            .parts5: CGPoint(x: center.x - 70, y: center.y + 50),
            .parts6: CGPoint(x: center.x, y: center.y + 50),
            .parts7: CGPoint(x: center.x + 70, y: center.y + 50)
        ]
    }
}

#Preview {
    HousePreviewView(viewType: .house)
}

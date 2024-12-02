//
//  HousePreviewView.swift
//  EOD
//
//  Created by JooYoung Kim on 11/4/24.
//

import SwiftUI
import Kingfisher

struct HousePreviewView: View {
    var themeItemList: [ThemeItem]?
    
    var body: some View {
        GeometryReader { geometry in
            let screenCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let themeCoordinates = calculateThemeCoordinates(center: screenCenter)
            
            ZStack {
                ForEach(RoomThemeItemType.allCases, id: \.rawValue) { type in
                    if let coordinates = themeCoordinates[type] {
                        if let item = themeItemList?.first(where: { $0.type == type }) {
                            if type == .backGround {
                                KFImage(item.homeImageUrl.url)
                                    .resizable()
                                    .scaledToFit()
                                    .ignoresSafeArea()
                            } else {
                                KFImage(item.homeImageUrl.url)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: type.frameSize?.width, height: type.frameSize?.height)
                                    .position(coordinates)
                                
                            }
                        } else if [.backGround, .wallpaper, .flooring].contains(type) {
                            if type == .backGround {
                                Image(type.imageName)
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .ignoresSafeArea()
                            } else {
                                Image(type.imageName)
                                    .position(coordinates)
                            }
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
            .backGround: center,
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
    HousePreviewView()
}

//
//  HomeView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @State private var showCharacterView: Bool = false
    @State private var showHouseView: Bool = false
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            topView()
            Spacer()
            houseView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UIColor.CommonBackground.background.color)
    }
}

extension HomeView {
    private func topView() -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 5) {
                Image("icon_egg")
                
                Text(viewModel.userGold?.formattedDecimal() ?? "0")
                    .font(size: 20)
                    .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(red: 239/255, green: 239/255, blue: 228/255))
            .clipShape(Capsule())
           
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    self.showCharacterView = true
                } label: {
                    Image("icon_clothes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                .fullScreenCover(isPresented: $showCharacterView) {
                    CharacterView(showCharacterView: $showCharacterView, viewModel: CharacterViewModel(userGold: $viewModel.userGold))
                        .onDisappear {
                            viewModel.refreshUserInfo()
                        }
                }
                
                Button {
                    self.showHouseView = true
                } label: {
                    Image("icon_interior")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                .fullScreenCover(isPresented: $showHouseView) {
                    HouseView(showHouseView: $showHouseView, viewModel: HouseViewModel(userGold: $viewModel.userGold))
                        .onDisappear {
                            viewModel.refreshUserInfo()
                        }
                }
                
                Button {
                    // TODO: 알림 나중에 확인
                } label: {
                    Image("icon_alarm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
//                .fullScreenCover(isPresented: $showHouseView) { // TODO: 알림화면 구현시 해당 버튼 사용
//                    HouseView(showHouseView: $showHouseView, viewModel: HouseViewModel())
//                }

            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 25)
    }
    
    // 캐릭터 테마 메인 뷰
    private func houseView() -> some View {
        ZStack {
            HousePreviewView(themeItemList: viewModel.userThemeList)
            
            GeometryReader { geometry in
                KFImage(viewModel.userCharacterInfo?.imageUrl?.url)
                    .placeholder {
                        Image("character_default")
                            .resizable()
                            .scaledToFit()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: min(geometry.size.width, 120), height: min(geometry.size.height, 120)) // TODO: 사이즈 확인
                    .position(x: geometry.size.width / 2, y: (geometry.size.height / 2) + 40) // TODO: 좌표 확인
            }
        }
    }
    
    private func todayTextView() -> some View {
        VStack {
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let previewViewModel = HomeViewModel()
        previewViewModel.userCharacterInfo = CharacterItem(id: 1, imageUrl: "https://yolk-shop-image.kr.object.ncloudstorage.com/1_character/1-2_character1.webp?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20241202T021128Z&X-Amz-SignedHeaders=host&X-Amz-Expires=86400&X-Amz-Credential=9HwjhTcz2kypE8HXSl6d%2F20241202%2Fkr-standard%2Fs3%2Faws4_request&X-Amz-Signature=801f82fec7300abf3fd0302769f50947bc9f3fb53d859f9a96f8cc2a476c7d11", name: "asdf")
        previewViewModel.userGold = 1000
        
        return HomeView(viewModel: previewViewModel)
    }
}

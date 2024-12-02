//
//  HouseView.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI
import Kingfisher

struct HouseView: View {
    @Binding var showHouseView: Bool
    @ObservedObject var viewModel: HouseViewModel
    @State var showBuyAlert: Bool = false
    
    init(showHouseView: Binding<Bool>, viewModel: HouseViewModel) {
        self._showHouseView = showHouseView
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    topAreaView()
                    bottomAreaView()
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 251/255, green: 251/255, blue: 244/255))
                .toast(message: viewModel.toastMessage, visibleIcon: true, isShowing: $viewModel.isToast)
                
                bottomButtonView(proxy: proxy)
                    .animation(.easeInOut, value: availableBuyArea)
                
                if showBuyAlert {
                    CustomBuyAlert(
                        showAlert: $showBuyAlert,
                        imageUrl: viewModel.selectThemeItem?.itemImageUrl,
                        itemName: viewModel.selectThemeItem?.name,
                        itemDescription: viewModel.selectThemeItem?.details,
                        userGold: viewModel.userGold,
                        availableBuyButton: availableBuyButton,
                        acceptAction: {
                            if availableBuyButton {
                                viewModel.buyThemeItem()
                            }
                        })
                }
            }
        }
        
    }
}

extension HouseView {
    private func topAreaView() -> some View {
        ZStack(alignment: .topLeading) {
            HousePreviewView(themeItemList: viewModel.selectThemeItemList)
                .padding(.top, 53)
            
            HStack {
                Button {
                    self.showHouseView = false
                } label: {
                    Image("btn_close_B")
                }
                
                Spacer()
                
                if viewModel.currentShowType == .shop {
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
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    returnButtonView()
                    
                    Spacer()
                    
                    if viewModel.currentShowType == .item {
                        Button {
                            if availableSaveButton {
                                viewModel.setThemeItem()
                            }
                        } label: {
                            Text("저장")
                                .font(size: 14)
                                .foregroundColor(availableSaveButton ? Color.white : Color(red: 177/255, green: 177/255, blue: 163/255))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                                .background(availableSaveButton ? Color.black : Color(red: 210/255, green: 210/255, blue: 188/255))
                                .cornerRadius(6.0)
                        }
                    } else {
                        if viewModel.selectTheme != nil { // 테마 진입시 전체 구매 버튼 노출
                            Button {
                                if availableSaveButton {
                                    viewModel.setThemeItem()
                                }
                            } label: {
                                Text("전체 구매")
                                    .font(size: 14)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 24)
                                    .background(.white)
                                    .cornerRadius(6.0)
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    private func returnButtonView() -> some View {
        Button {
            // TODO: 되돌리기 로직 확인
        } label: {
            VStack(spacing: -10) {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                    
                    Image("icon_return")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                
                Text("되돌리기")
                    .font(size: 12)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(width: 51, height: 48)
        }
    }
    
    private func selectTopNavigationView() -> some View {
        ZStack(alignment: .leading) {
            Button {
                viewModel.selectTheme = nil
            } label: {
                Image("btn_left")
            }
            
            HStack(spacing: 0) {
                Spacer()
                
                Text(viewModel.selectTheme?.name ?? "하우스 이름")
                    .font(size: 20)
                    .foregroundColor(.black)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
    }
    
    private func tabButton(type: ShowType) -> some View {
        Button {
            viewModel.currentShowType = type
        } label: {
            Text(type.description)
                .font(size: 20)
                .foregroundColor(viewModel.currentShowType == type ? .black : Color(red: 118/255, green: 118/255, blue: 118/255))
                .background(
                    GeometryReader { geometry in
                        (viewModel.currentShowType == type ? UIColor.Yellow.yellow200.color : .clear)
                            .frame(width: geometry.size.width, height: 9)
                            .offset(x: 0, y: geometry.size.height - 8)
                    }
                )
        }
        .padding(.top, 31)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
    }
    
    private func bottomAreaView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if viewModel.selectTheme != nil {
                    selectTopNavigationView()
                } else {
                    tabButton(type: .item)
                    tabButton(type: .shop)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(Color(red: 235/255, green: 235/255, blue: 227/255))
            
            Spacer()
            
            themeListView()
                .padding(.horizontal, 10)
                .padding(.top, 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func themeListView() -> some View {
        ScrollView {
            if viewModel.selectTheme != nil {
                LazyVGrid(columns: columns, spacing: 10) {
                    if viewModel.currentShowType == .item { // 복수선택
                        ForEach(viewModel.themeItemList ?? [], id: \.id) { item in
                            roomThemeItemDetailView(item: item)
                        }
                    } else { // 단일선택
                        ForEach(viewModel.themeShopItemList ?? [], id: \.id) { item in
                            roomThemeShopItemDetailView(item: item)
                        }
                    }
                    
                }
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    
                    ForEach(viewModel.themeList ?? [], id: \.id) { theme in
                        roomThemeDetailView(theme: theme)
                    }
                }
            }
        }
    }
    
    private func bottomButtonView() -> some View {
        VStack(spacing: 0) {
            // 상단 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 251/255, green: 251/255, blue: 244/255).opacity(1),
                    Color(red: 251/255, green: 251/255, blue: 244/255).opacity(0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 50) // TODO: 명확한 높이값 나중에 확인해보기
            
            HStack(spacing: 16) {
                Button {
                    viewModel.selectThemeItemList = nil
                } label: {
                    Text("선택 취소")
                        .font(size: 20)
                        .foregroundColor(Color(red: 93/255, green: 93/255, blue: 79/255))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 229/255, green: 229/255, blue: 212/255))
                        .cornerRadius(8.0)
                }
                
                
                Button {
                    // TODO: 세부 로직 추후 수정
                } label: {
                    Text("선택 상품 구매")
                        .font(size: 20)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8.0)
                }
                
            }
            .padding(.horizontal, 24)
            .background(Color(red: 251/255, green: 251/255, blue: 244/255))
        }
        .padding(.bottom, 15)
    }
    
    private func roomThemeDetailView(theme: Theme) -> some View {
        Button {
            viewModel.selectTheme = theme
        } label: {
            ZStack(alignment: .bottom) {
                KFImage(theme.imageUrl.url)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fill)
                
                Text(theme.name)
                    .font(size: 14)
                    .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                    .lineSpacing(2)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 120)
            .background(.white)
            .cornerRadius(16) // 모서리를 둥글게 설정
        }
        .buttonStyle(PlainButtonStyle()) // 기본 스타일 제거
        .padding(EdgeInsets.init())
    }
    
    private func roomThemeItemDetailView(item: ThemeItem) -> some View {
        Button {
            viewModel.setSelectThemeItemList(item: item)
        } label: {
            ZStack(alignment: .top) {
                if viewModel.isSelectItem(item: item) {
                    HStack {
                        Spacer()
                        Image("btnConfirmOn")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding([.top, .trailing], 5.0)
                    .frame(maxWidth: .infinity)
                    .offset(x: 0, y: 25) // 위치 조정을 위해 offset 사용
                }
                
                VStack(spacing: 16) {
                    KFImage(item.itemImageUrl.url)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(width: 63, height: 55)
                        .aspectRatio(contentMode: .fit)
                    
                    Text(item.name)
                        .font(size: 14)
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        .lineSpacing(2)
                }
                .padding(.top, 28)
                .padding(.bottom, 12)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
            }
            .padding(EdgeInsets.init())
            .frame(height: 120)
            .background(.white) // 배경색을 흰색으로 설정
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.isSelectItem(item: item) ? Color.yellow : .clear, lineWidth: 2) // 테두리 색상과 두께 설정
            )
            .cornerRadius(16) // 모서리를 둥글게 설정
        }
        .buttonStyle(PlainButtonStyle()) // 기본 스타일 제거
        .padding(EdgeInsets.init())
    }
    
    private func roomThemeShopItemDetailView(item: ThemeItem) -> some View {
        Button {
            viewModel.setSelectThemeItem(item: item)
            
        } label: {
            ZStack(alignment: .top) {
                if viewModel.selectThemeItem == item {
                    HStack {
                        Spacer()
                        Image("btnConfirmOn")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding([.top, .trailing], 5.0)
                    .frame(maxWidth: .infinity)
                    .offset(x: 0, y: 25) // 위치 조정을 위해 offset 사용
                }
                
                VStack(spacing: 16) {
                    KFImage(item.itemImageUrl.url)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(width: 63, height: 55)
                        .aspectRatio(contentMode: .fit)
                    
                    Text(item.name)
                        .font(size: 14)
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        .lineSpacing(2)
                }
                .padding(.top, 28)
                .padding(.bottom, 12)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
            }
            .padding(EdgeInsets.init())
            .frame(height: 120)
            .background(.white) // 배경색을 흰색으로 설정
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.selectThemeItem == item ? Color.yellow : .clear, lineWidth: 2) // 테두리 색상과 두께 설정
            )
            .cornerRadius(16) // 모서리를 둥글게 설정
        }
        .buttonStyle(PlainButtonStyle()) // 기본 스타일 제거
        .padding(EdgeInsets.init())
    }
    
    private func bottomButtonView(proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // 상단 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 251/255, green: 251/255, blue: 244/255).opacity(1),
                    Color(red: 251/255, green: 251/255, blue: 244/255).opacity(0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 50) // TODO: 명확한 높이값 나중에 확인해보기
            
            HStack(spacing: 16) {
                Button {
                    withAnimation { // 버튼 동작에도 애니메이션 적용
                        viewModel.selectThemeItemList = nil
                    }
                } label: {
                    Text("선택 취소")
                        .font(size: 20)
                        .foregroundColor(Color(red: 93/255, green: 93/255, blue: 79/255))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 229/255, green: 229/255, blue: 212/255))
                        .cornerRadius(8.0)
                }
                
                
                Button {
                    viewModel.buyThemeItem()
                } label: {
                    Text("선택 상품 구매")
                        .font(size: 20)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8.0)
                }
                
            }
            .padding(.horizontal, 24)
            .background(Color(red: 251/255, green: 251/255, blue: 244/255))
            
        }
        .offset(y: availableBuyArea ? 0 : 54 + proxy.safeAreaInsets.bottom)
    }
}

extension HouseView {
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 105, maximum: 120), spacing: 10, alignment: .top)]
    }
    
    private var availableBuyArea: Bool {
        return viewModel.currentShowType == .shop && viewModel.selectThemeItem != nil
    }
    
    private var availableSaveButton: Bool {
        return viewModel.currentShowType == .item && viewModel.isModify
    }
    
    private var availableBuyButton: Bool {
        if let userGold = viewModel.userGold, let price = viewModel.selectThemeItem?.price {
            return (userGold - price) > 0
        } else {
            return false
        }
    }
}

#Preview {
    HouseView(showHouseView: .constant(false), viewModel: HouseViewModel(userGold: .constant(0)))
}

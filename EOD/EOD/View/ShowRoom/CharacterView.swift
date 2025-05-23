//
//  CharacterView.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI
import Kingfisher

struct CharacterView: View {
    @Binding var showCharacterView: Bool
    @ObservedObject var viewModel: CharacterViewModel
    @State var showBuyAlert: Bool = false
    
    init(showCharacterView: Binding<Bool>, viewModel: CharacterViewModel) {
        self._showCharacterView = showCharacterView
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    topAreaView()
                    bottomAreaView(proxy: proxy)
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 251/255, green: 251/255, blue: 244/255))
                
                bottomButtonView(proxy: proxy)
                    .animation(.easeInOut, value: availableBuyArea)
                
                if showBuyAlert {
                    CustomBuyAlert(
                        showAlert: $showBuyAlert,
                        imageUrl: viewModel.selectItem?.imageUrl,
                        itemName: viewModel.selectItem?.name,
                        itemDescription: viewModel.selectItem?.description,
                        userGold: viewModel.selectItem?.price,
                        availableBuyButton: availableBuyButton,
                        acceptAction: {
                            if availableBuyButton {
                                viewModel.buyCharacterItem()
                            }
                        })
                }
                
                
                if viewModel.showBuyCompleteView {
                    BuyCompleteView(
                        showCompleteView: $viewModel.showBuyCompleteView,
                        imageUrl: viewModel.selectItem?.imageUrl, // 현재 선택된 아이템
                        acceptAction: {
                            viewModel.selectItem = nil
                            viewModel.buyCompleteAction()
                        },
                        cancelAction: {
                            viewModel.selectItem = nil
                            viewModel.fetchShopCharacterItem()
                        })
                }
                
                ToastView(toastManager: viewModel.toastManager)
            }
            
        }
    }
}

extension CharacterView {
    private func topAreaView() -> some View {
        ZStack(alignment: .topLeading) {
            ZStack {
                Image("character_background")
                    .resizable()
                
                GeometryReader { geometry in
                    KFImage(viewModel.selectItem?.imageUrl?.url)
                        .placeholder {
                            Image("character_default")
                                .resizable()
                                .scaledToFit()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: min(geometry.size.width, 200), height: min(geometry.size.height, 200)) // TODO: 사이즈 확인
                        .position(x: geometry.size.width / 2, y: (geometry.size.height / 2) + 40) // TODO: 좌표 확인
                }
            }
            
            HStack {
                Button {
                    self.showCharacterView = false
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
            
            if viewModel.currentShowType == .item {
                VStack {
                    Spacer()
                    
                    HStack {
                        returnButtonView()
                        
                        Spacer()
                        
                        Button {
                            if availableSaveButton {
                                viewModel.setCharacterItem()
                            }
                            // TODO: 세부 로직 추후 수정
                        } label: {
                            Text("저장")
                                .font(size: 14)
                                .foregroundColor(availableSaveButton ? Color.white : Color(red: 177/255, green: 177/255, blue: 163/255))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                                .background(availableSaveButton ? Color.black : Color(red: 210/255, green: 210/255, blue: 188/255))
                                .cornerRadius(6.0)
                        }
                        
                    }.frame(maxWidth: .infinity, alignment: .bottom)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    private func bottomAreaView(proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                tabButton(type: .item)
                tabButton(type: .shop)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(Color(red: 235/255, green: 235/255, blue: 227/255))
            
            itemListView(proxy: proxy)
                .padding(.horizontal, 10)
                .padding(.top, 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func tabButton(type: ShowType) -> some View {
        ZStack(alignment: .topTrailing) {
            Button {
                viewModel.currentShowType = type
            } label: {
                ZStack(alignment: .topTrailing) {
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
                    
                    if type == .item && viewModel.existNewItem {
                        Image("new_mark")
                            .offset(x: 4, y: -2)
                    }
                }
            }
            .padding(.top, 31)
            .padding(.bottom, 28)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func itemListView(proxy: GeometryProxy) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(viewModel.presentItemList ?? [], id: \.id) { item in
                    characterDetailView(item: item)
                }
            }
            
            Spacer().frame(height: 54 + proxy.safeAreaInsets.bottom)
        }
    }
    
    private func returnButtonView() -> some View {
        Button {
            viewModel.selectItem = viewModel.originalCharacter
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
                        viewModel.selectItem = nil
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
                    showBuyAlert = true
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
    
    private func characterDetailView(item: CharacterItem) -> some View {
        Button {
            viewModel.setSelectItem(item: item)
        } label: {
            ZStack(alignment: .top) {
                if viewModel.selectItem == item {
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
                    KFImage(item.imageUrl?.url)
                        .resizable()
                        .frame(width: 63, height: 55)
                        .scaledToFit()
                    
                    ZStack(alignment: .topTrailing) {
                        Text(item.name)
                            .font(size: 14)
                            .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                            .lineSpacing(2)
                        
                        if item.isClicked == false {
                            Image("new_mark")
                                .offset(x: 4, y: -2)
                        }
                    }
                }
                .padding(.top, 28)
                .padding(.bottom, 12)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
                
                if viewModel.currentShowType == .shop, item.hasItem == true {
                    ZStack {
                        // 배경색과 blur 효과
                        Color(red: 75 / 255, green: 66 / 255, blue: 46 / 255, opacity: 0.7)
                            .blur(radius: 3) // Blur 효과 적용
                        
                        Text("Sold Out")
                            .font(size: 20)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(EdgeInsets.init())
            .frame(height: 120)
            .background(.white) // 배경색을 흰색으로 설정
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.selectItem == item ? Color.yellow : .clear, lineWidth: 2) // 테두리 색상과 두께 설정
            )
            .cornerRadius(16) // 모서리를 둥글게 설정
        }
        .buttonStyle(PlainButtonStyle()) // 기본 스타일 제거
        .padding(EdgeInsets.init())
    }
}

extension CharacterView {
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 105, maximum: 120), spacing: 10, alignment: .top)]
    }
    
    private var availableSaveButton: Bool { // 기존 캐릭터랑 다른 캐릭터가 선택되었을경우 저장버튼 활성화
        return viewModel.selectItem != viewModel.originalCharacter
    }
    
    private var availableBuyArea: Bool {
        return viewModel.currentShowType == .shop && viewModel.selectItem != nil
    }
    
    private var availableBuyButton: Bool {
        if let userGold = viewModel.userGold, let price = viewModel.selectItem?.price {
            return (userGold - price) > 0
        } else {
            return false
        }
    }
}

#Preview {
    let a = CharacterItem(id: 1, imageUrl: "asdf", name: "asdf", hasItem: true)
    let b = CharacterItem(id: 2, imageUrl: "asdf", name: "asdf")
    let c = CharacterItem(id: 3, imageUrl: "asdf", name: "asdf", isClicked: false)
    let d = CharacterItem(id: 4, imageUrl: "asdf", name: "asdf")
    
    let userItems = [a, b, c, d]
    
    let shopa = CharacterItem(id: 1, imageUrl: "asdf", name: "asdf", hasItem: true)
    let shopb = CharacterItem(id: 2, imageUrl: "asdf", name: "asdf")
    let shopc = CharacterItem(id: 3, imageUrl: "asdf", name: "asdf")
    let shopd = CharacterItem(id: 4, imageUrl: "asdf", name: "asdf", hasItem: true)
    let shope = CharacterItem(id: 5, imageUrl: "asdf", name: "asdf")
    let shopf = CharacterItem(id: 6, imageUrl: "asdf", name: "asdf")
    
    let shopItems = [shopa, shopb, shopc, shopd, shope, shopf]
    
    CharacterView(showCharacterView: .constant(false), viewModel: CharacterViewModel(userItems: userItems, shopItems: shopItems, userGold: 0, originalCharacter: nil))
}

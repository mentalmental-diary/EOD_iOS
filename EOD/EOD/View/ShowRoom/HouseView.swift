//
//  HouseView.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

struct HouseView: View {
    @Binding var showHouseView: Bool
    @ObservedObject var viewModel: HouseViewModel
    
    init(showHouseView: Binding<Bool>, viewModel: HouseViewModel) {
        self._showHouseView = showHouseView
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topAreaView()
            bottomAreaView()
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 251/255, green: 251/255, blue: 244/255))
    }
}

extension HouseView {
    private func topAreaView() -> some View {
        ZStack(alignment: .topLeading) {
            HousePreviewView(backgroundUrl: viewModel.selectTheme?.imageUrl, themeItemList: viewModel.themeItemList)
            
            HStack {
                Button {
                    self.showHouseView = false
                } label: {
                    Image("btn_close_B")
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            VStack {
                Spacer()
                
                HStack {
                    returnButtonView()
                    
                    Spacer()
                    
                    Button {
                        // TODO: 세부 로직 추후 수정
                    } label: {
                        Text("저장")
                            .font(size: 14)
                            .foregroundColor(Color.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(Color.black)
                            .cornerRadius(6.0)
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    private func returnButtonView() -> some View {
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
//            itemListView()
//                .padding(.horizontal, 10)
//                .padding(.top, 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func selectTopNavigationView() -> some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("하우스 이름") // TODO: 아마 해당 테마 이름일듯 -> viewModel.selectTheme.name
                
                Spacer()
            }
            
            Button {
                viewModel.selectTheme = nil
            } label: {
                Image("btn_left")
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
}

#Preview {
    HouseView(showHouseView: .constant(false), viewModel: HouseViewModel())
}

//
//  GoldInfoView.swift
//  EOD
//
//  Created by JooYoung Kim on 6/7/25.
//

import SwiftUI

struct GoldInfoView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    NavigationBarView(title: "골드 보유 내역", dismissAction: {
                        viewModel.showGoldInfoView = false
                        presentationMode.wrappedValue.dismiss()
                    })
                    .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                    
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        Image("icon_egg")
                            .resizable()
                            .frame(width: 26, height: 30)
                        
                        Spacer().frame(width: 8)
                        
                        Text(viewModel.userGold?.formattedDecimal() ?? "0")
                            .font(size: 34)
                            .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        
                        Spacer()
                    }
                    .padding(EdgeInsets.init(top: 30, leading: 0, bottom: 48, trailing: 0))
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                    
                    tabView()
                    
                    Divider()
                        .frame(minHeight: 1.0)
                        .overlay(Color(red: 235/255, green: 235/255, blue: 227/255))
                    
                    Spacer()
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .background(UIColor.CommonBackground.background.color)
                
            }
            
        })
        .ignoresSafeArea(.keyboard)
    }
}

extension GoldInfoView {
    @ViewBuilder func tabView() -> some View {
        HStack(spacing: 24) {
            tabButton(type: .all)
            tabButton(type: .earn)
            tabButton(type: .use)
        }
        .padding(.leading, 30)
        .padding(.vertical, 24)
    }
    
    private func tabButton(type: GoldInfoType) -> some View {
        Button {
            viewModel.currentInfoTab = type
        } label: {
            Text(type.title)
                .font(type: .omyu, size: 20)
                .foregroundColor(type == viewModel.currentInfoTab ? .black : Color(red: 118/255, green: 118/255, blue: 118/255))
                .underlinedBackground(color: type == viewModel.currentInfoTab ? UIColor.Yellow.yellow200.color : .clear)
        }
    }
}

#Preview {
    GoldInfoView(viewModel: HomeViewModel())
}

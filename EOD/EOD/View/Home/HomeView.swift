//
//  HomeView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct HomeView: View {
    @State private var showCharacterView: Bool = false
    @State private var showHouseView: Bool = false
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            topView()
            Spacer()
            Text("메인 홈 화면")
                .foregroundColor(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension HomeView {
    private func topView() -> some View {
        HStack(spacing: 0) {
            Button {
                self.showCharacterView = true
            } label: {
                Image("icon_clothes")
            }
            .fullScreenCover(isPresented: $showCharacterView) {
                CharacterView(showCharacterView: $showCharacterView, viewModel: CharacterViewModel()) // TODO: 변수 추가
            }
            
            Button {
                self.showHouseView = true
            } label: {
                Image("icon_interior")
            }
            .fullScreenCover(isPresented: $showHouseView) {
                HouseView(showHouseView: $showHouseView, viewModel: HouseViewModel())
            }


        }
        .padding(.vertical, 20)
        .padding(.top, 15)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

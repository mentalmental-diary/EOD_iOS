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
    
    var body: some View {
        VStack {
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
                Text("캐릭터 꾸미기")
            }
            
            Button {
                
            } label: {
                Text("방꾸미기")
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

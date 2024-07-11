//
//  HomeView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct HomeView: View {
    @State var isShow: Bool = false
    
    var body: some View {
        VStack {
            NavigationBarView(title: "메인 홈 화면")
                .frame(height: 54)
            Spacer()
            Text("주로 활용되는 메인 홈 화면 -> 탭으로 구성")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

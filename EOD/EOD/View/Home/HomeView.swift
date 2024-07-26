//
//  HomeView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct HomeView: View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

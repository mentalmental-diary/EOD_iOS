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
        VStack {
            topAreaView()
            Text("")
        }
    }
}

extension HouseView {
    private func topAreaView() -> some View {
        ZStack {
            HStack {
                Button {
                    self.showHouseView = false
                } label: {
                    Image("btn_close_B")
                }

            }
        }
    }
}

#Preview {
    HouseView(showHouseView: .constant(false), viewModel: HouseViewModel())
}

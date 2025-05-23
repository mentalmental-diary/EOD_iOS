//
//  PageControlView.swift
//  EOD
//
//  Created by USER on 2023/10/04.
//

import SwiftUI

struct PageControlView: View {
    @Binding var currentPage: Int
    var pages: Int // 총 페이지 갯수
    
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 10) {
                ForEach(0..<pages, id: \.self) { page in
                    Circle()
                        .foregroundColor(page == currentPage ? UIColor.Yellow.yellow500.color : UIColor.Gray.gray100.color) // 현재 페이지인 경우 채우기
                        .frame(width: 10, height: 10)
                        .cornerRadius(5)
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}

struct PageControlView_Previews: PreviewProvider {
    static var previews: some View {
        PageControlView(currentPage: .constant(2), pages: 5)
    }
}

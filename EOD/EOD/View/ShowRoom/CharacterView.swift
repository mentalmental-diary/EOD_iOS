//
//  CharacterView.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var viewModel: CharacterViewModel
    
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("캐릭터 꾸미기 화면")
            returnButtonView()
        }
        .background(.gray)
        
    }
}

extension CharacterView {
    private func returnButtonView() -> some View {
        VStack(spacing: -10) {
            ZStack {
                Circle()
                    .foregroundColor(.white) // 배경 색 설정
                    .frame(width: 40, height: 40)
                
                Image("icon_return") // 아이콘
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color.orange)
            }
            
            Text("되돌리기")
                .font(size: 12)
                .frame(maxWidth: .infinity) // 텍스트가 가득 차도록 설정
                .padding(.vertical, 4) // 텍스트 위아래 여백 추가
                .background(Color.white) // 텍스트 영역 배경색
                .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)) // 텍스트 색상
                .clipShape(RoundedRectangle(cornerRadius: 20)) // 모서리 둥글게 처리
        }
        .frame(width: 51, height: 48) // 전체 뷰 너비 설정
    }
}

#Preview {
    CharacterView(viewModel: CharacterViewModel())
}

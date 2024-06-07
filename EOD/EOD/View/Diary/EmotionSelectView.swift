//
//  EmotionSelectView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/28/24.
//

import SwiftUI

struct EmotionSelectView: View {
    @Binding var isShow: Bool
    
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBarView(isShow: $isShow)
            
            VStack(alignment: .leading) {
                Text("오늘 하루는 어땠나요?")
                    .font(size: 28)
                    .foregroundColor(Color.black)
                
                Text("\(currentDiaryDay) 오늘 기분은")
                    .font(size: 24)
                    .foregroundColor(Color.black)
                
                selectStickerView()
                
                Spacer()
            }
            
            .padding(.horizontal, 20)
            
        }
    }
}

extension EmotionSelectView {
    @ViewBuilder func selectStickerView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image("select_happy")
                    Text("행복해")
                        .font(size: 16)
                        .foregroundColor(Color.black)
                }
//                .padding(10)
                Image("select_angry")
                Image("select_relax")
                Image("select_nomoral")
            }
            HStack(spacing: 36) {
                Image("select_sad")
                Image("select_excited")
                Image("select_proud")
                Image("select_worry")
            }
        }
    }
}

extension EmotionSelectView {
    private var currentDiaryDay: String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "M.dd EEEE"
        dateFormmater.locale = Locale(identifier: "ko_KR")
        
        if viewModel.selectDate != nil {
            let dateString = dateFormmater.string(from: viewModel.selectDate ?? Date())
            
            return dateString
        } else {
            return ""
        }
    }
}

#Preview {
    EmotionSelectView(isShow: .constant(false), viewModel: CalendarViewModel())
}

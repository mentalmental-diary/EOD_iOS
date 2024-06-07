//
//  DiaryView.swift
//  EOD
//
//  Created by JooYoung Kim on 6/7/24.
//

import SwiftUI

struct DiaryView: View {
    @Binding var isShow: Bool
    
    @ObservedObject var viewModel: CalendarViewModel
    
    @State private var text: String = ""
    
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
                
                writeDiaryView()
                
                Spacer()
                    .frame(height: 225)
                
                Button {
                    isShow = false
                } label: {
                    Text("저장하기")
                        .font(size: 20)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(8.0)

            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
        }
        .ignoresSafeArea(.keyboard)
        .background(UIColor.CommonBackground.background.color)
    }
}

extension DiaryView {
    @ViewBuilder func writeDiaryView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            /// 감정 노출 영역
            HStack { // TODO: 아직 미리보기엔 반영되지 않기 때문에 일단 임시로 하드코딩 진행
                Image("icon_happy")
                
                Text("행복해")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    if text.isEmpty {
                        Text("일기를 작성해주세요. (최대 2,000자)")
                            .font(size: 16)
                            .foregroundColor(UIColor.Gray.gray500.color)
                            
                    }
                    Spacer()
                }
                .padding(.leading, 3)
                .allowsHitTesting(false)
                
                CustomTextView(text: $text)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(17)
    }
}

extension DiaryView {
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

private struct CustomTextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    var maxLength: Int = 2000
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "omyu pretty", size: 16)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        textView.textColor = UIColor.black
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> CustomTextView.Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView
        
        init(parent: CustomTextView) {
            self.parent = parent
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textViewDidChange(_ textView: UITextView) {
            if textView.text.count > parent.maxLength {
                textView.text = String(textView.text.prefix(parent.maxLength))
            }
            parent.text = textView.text
        }
        
        /// TextView 정보 업데이트
        func updateTextView(_ textView: UITextView) {
            
        }
    }
}

#Preview {
    DiaryView(isShow: .constant(false), viewModel: CalendarViewModel())
}

//
//  DiaryView.swift
//  EOD
//
//  Created by JooYoung Kim on 6/7/24.
//

import SwiftUI

struct DiaryView: View {
    @Binding var isShow: Bool
    
    @ObservedObject var viewModel: DiaryViewModel
    
    init(isShow: Binding<Bool>, viewModel: DiaryViewModel) {
        self._isShow = isShow
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                NavigationBarView()
                
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
            
            if viewModel.showEmotionSelectView {
                EmotionSelectView(viewModel: viewModel, showModalView: $viewModel.showEmotionSelectView, isShowDiaryView: $isShow)
            }
        }
    }
}

extension DiaryView {
    @ViewBuilder func writeDiaryView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            /// 감정 노출 영역
            HStack { // TODO: 아직 미리보기엔 반영되지 않기 때문에 일단 임시로 하드코딩 진행
                Image(viewModel.diary.emotion?.imageName ?? "icon_basic")
                
                Text(viewModel.diary.emotion?.description ?? "감정을 선택해주세요.")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .onTapGesture {
                viewModel.showEmotionSelectView = true
            }
            
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    if viewModel.diary.diaryContents?.count == 0 {
                        Text("일기를 작성해주세요. (최대 2,000자)")
                            .font(size: 16)
                            .foregroundColor(UIColor.Gray.gray500.color)
                            
                    }
                    Spacer()
                }
                .padding(.leading, 3)
                .allowsHitTesting(false)
                
                CustomTextView(text: $viewModel.diary.diaryContents)
                    .frame(minHeight: 16)
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
        
        let dateString = dateFormmater.string(from: viewModel.selectDate ?? Date())
        
        return dateString
    }
}

private struct CustomTextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String?
    var maxLength: Int = 2000
    var lineHeight: CGFloat = 19  // 추가된 라인 높이 설정
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "omyu pretty", size: 16)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textView.textColor = UIColor.black
        
        // 키보드 위에 'Done' 버튼을 추가
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textView.frame.size.width, height: 50))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard(_:))) // TODO: 나중에 이미지로 변경
        ]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
        // 라인 높이 설정을 적용
        updateTextView(textView, text: text)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        updateTextView(uiView, text: text)
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
        
        @objc func dismissKeyboard(_ sender: UIBarButtonItem) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    /// TextView의 NSAttributedString을 업데이트하여 라인 높이를 적용
    private func updateTextView(_ textView: UITextView, text: String?) {
        guard let text = text, let font = textView.font else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

#Preview {
    DiaryView(isShow: .constant(false), viewModel: DiaryViewModel())
}

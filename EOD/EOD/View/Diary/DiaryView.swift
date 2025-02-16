//
//  DiaryView.swift
//  EOD
//
//  Created by JooYoung Kim on 6/7/24.
//

import SwiftUI

struct DiaryView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    NavigationBarView()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("오늘 하루는 어땠나요?")
                            .font(size: 28)
                            .foregroundColor(Color.black)
                        
                        Spacer().frame(height: 16)
                        
                        Text("\(currentDiaryDay) 오늘 기분은")
                            .font(size: 24)
                            .foregroundColor(Color.black)
                        
                        Spacer().frame(height: 20)
                        
                        writeDiaryView()
                            .shadow(color: Color(red: 242/255, green: 242/255, blue: 229/255), radius: 17, x: 0, y: 0)
                        
                        Spacer()
                            .frame(height: 241)
                        
                        Button {
                            viewModel.isModify ? viewModel.modifyDiary() : viewModel.uploadDiary()
                        } label: {
                            Text("저장하기")
                                .font(size: 20)
                                .foregroundColor(Color.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(viewModel.isModified ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8.0)
                        
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .edgesIgnoringSafeArea(.bottom)
                .background(UIColor.CommonBackground.background.color)
                
                if viewModel.showEmotionSelectView {
                    EmotionSelectView(viewModel: viewModel, showModalView: $viewModel.showEmotionSelectView, isShowDiaryView: $viewModel.showDiaryView)
                }
                
                if viewModel.showDiaryBackgroundSelectView {
                    DiaryBackgroundSelectView(viewModel: viewModel, showModalView: $viewModel.showDiaryBackgroundSelectView, height: $viewModel.keyboardHeight)
                }
                
                ToastView(toastManager: viewModel.toastManager)
            }
            .onAppear {
                addKeyboardObservers()
            }
            .onDisappear {
                viewModel.resetData()
                removeKeyboardObservers()
            }
            
        })
        .ignoresSafeArea(.keyboard)
    }
}

extension DiaryView {
    @ViewBuilder func writeDiaryView() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                /// 감정 노출 영역
                HStack { // TODO: 아직 미리보기엔 반영되지 않기 때문에 일단 임시로 하드코딩 진행
                    Image(viewModel.diary.emotion?.imageName ?? "icon_basic")
                    
                    Text(viewModel.diary.emotion?.description ?? "감정을 선택해주세요.")
                        .font(size: 20)
                        .foregroundColor(Color.black)
                        .background(
                            GeometryReader { geometry in
                                (viewModel.diary.emotion?.description == nil ? UIColor.Gray.gray100.color : UIColor.Yellow.yellow200.color)
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Spacer()
                }
                .onTapGesture {
                    viewModel.showEmotionSelectView = true
                }
                
                ZStack(alignment: .topLeading) {
                    HStack(spacing: 0) {
                        if viewModel.diary.content?.count == 0 {
                            Text("일기를 작성해주세요. (최대 2,000자)")
                                .font(size: 16)
                                .foregroundColor(UIColor.Gray.gray500.color)
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 3)
                    .allowsHitTesting(false)
                    
                    CustomTextView(text: $viewModel.diary.content, showBackgroundView: $viewModel.showDiaryBackgroundSelectView)
                        .frame(minHeight: 16)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            Image(viewModel.diary.diary_background?.imageName ?? diaryBackgroundType.white.imageName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(-1)
        }
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
    
    // ✅ 키보드 높이 감지
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                viewModel.keyboardHeight = keyboardFrame.height
            }
        }
    }
    
    // ✅ 옵저버 해제
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

private struct CustomTextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String?
    @Binding var showBackgroundView: Bool
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
        
        // Adding the toolbar
        let toolbar = ShadowToolbar()
        toolbar.sizeToFit()
        
        // Setting the toolbar height
        let customToolbarHeight: CGFloat = 36
        var frame = toolbar.frame
        frame.size.height = customToolbarHeight
        toolbar.frame = frame
        toolbar.barTintColor = UIColor(red: 251/255, green: 251/255, blue: 244/255, alpha: 1.0)
        
        let leftButton = UIBarButtonItem(title: "속지선택", style: .plain, target: context.coordinator, action: #selector(Coordinator.selectBackgroundAction(_:))) // 좌측 버튼 추가

        // Adding buttons to the toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard(_:))) // TODO: 나중에 이미지로 변경
        toolbar.items = [
            leftButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ]
        
        textView.inputAccessoryView = toolbar
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != (text ?? "") {
            uiView.text = text ?? ""
        }
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
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            parent.showBackgroundView = false
            
            return true
        }
        
        /// TextView 정보 업데이트
        func updateTextView(_ textView: UITextView) {
            
        }
        
        @objc func dismissKeyboard(_ sender: UIBarButtonItem) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        @objc func selectBackgroundAction(_ sender: UIBarButtonItem) {
            // 원하는 기능 추가 (예: 텍스트 리셋)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            parent.showBackgroundView = true
        }
    }
}

class ShadowToolbar: UIToolbar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setting the toolbar shadow
        self.layer.shadowColor = UIColor(red: 242/255, green: 242/255, blue: 229/255, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1) // X: 0, Y: -1
        self.layer.shadowRadius = 6 / 2.0 // Blur value is halved for shadowRadius
        self.layer.shadowOpacity = 1.0
        
        // Customizing the shadow spread by setting shadowPath
        let spread: CGFloat = 2
        let rect = self.bounds.insetBy(dx: -spread, dy: -spread)
        self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        self.layer.masksToBounds = false
    }
}

#Preview {
    DiaryView(viewModel: CalendarViewModel())
}

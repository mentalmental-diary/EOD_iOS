//
//  EmotionSelectView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/28/24.
//

import SwiftUI

struct EmotionSelectView: View {
    @State var appearAnimation: Bool = false
    @ObservedObject var viewModel: CalendarViewModel
    @State var selectYear: Int
    @Binding var showModalView: Bool
    @Binding var isShowDiaryView: Bool
    
    init(viewModel: CalendarViewModel, showModalView: Binding<Bool>, isShowDiaryView: Binding<Bool>) {
        self.viewModel = viewModel
        self.selectYear = viewModel.diary.writeDate?.year ?? 2024
        self._showModalView = showModalView
        self._isShowDiaryView = isShowDiaryView
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // dimmed View
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(appearAnimation ? 0.3 : 0.0))
                    .zIndex(-1)
                    .onTapGesture {
                        checkAndDismiss()
                    }
                
                if appearAnimation {
                    VStack(spacing: 0) {
                        Color(.white)
                            .frame(height: 20.0)
                            .zIndex(1)
                        
                        selectStickerView(geometry: geometry)
                            .background(Color.white)
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(corners: [.topLeft, .topRight], radius: 20)
                    
                }
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 0.2)) {
                   appearAnimation = true
                }
            })
        }
    }
}

extension EmotionSelectView {
    @ViewBuilder func selectStickerView(geometry: GeometryProxy) -> some View {
        VStack {
            HStack {
                Text("감정 선택")
                    .font(size: 22)
                    .foregroundColor(UIColor.Gray.gray900.color)
                
                Spacer()
                
                Button(action: {
                    checkAndDismiss()
                }, label: {
                    Image("btn_close")
                })
            }
            
            Spacer()
                .frame(height: 30)
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 16) {
                
                // 날짜 그리드
                ForEach(EmotionType.allCases, id: \.self) { emotion in
                    VStack {
                        Image(emotion.selectImageName)
                        Text(emotion.description)
                            .font(size: 16)
                            .foregroundColor(UIColor.Gray.gray900.color)
                    }
                    .onTapGesture {
                        viewModel.diary.emotion = emotion
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            dismissWithAnimation()
                        })
                    }
                    .frame(width: 72, height: 90)
                    .background(viewModel.diary.emotion == emotion ? UIColor.Yellow.yellow50.color : Color.clear)
                    .cornerRadius(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.diary.emotion == emotion ? UIColor.Yellow.yellow200.color : Color.clear, lineWidth: 1)
                    )
                }
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, geometry.safeAreaInsets.bottom)
    }
}

extension EmotionSelectView {
    private func dismissWithAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            appearAnimation = false
            showModalView = false
        }
    }
    
    private func checkAndDismiss() {
        if !viewModel.isModify, viewModel.diary.emotion == nil { // 등록 진입이면서 선택된 감정이 없는경우
            isShowDiaryView = false
        } else {
            dismissWithAnimation()
        }
    }
}

#Preview {
    EmotionSelectView(viewModel: CalendarViewModel(), showModalView: .constant(true), isShowDiaryView: .constant(false))
}

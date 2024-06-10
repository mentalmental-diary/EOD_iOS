//
//  EmotionSelectView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/28/24.
//

import SwiftUI

struct EmotionSelectView: View {
    @State var appearAnimation: Bool = false
    @ObservedObject var viewModel: DiaryViewModel
    @State var selectYear: Int
    @Binding var showModalView: Bool
    
    init(viewModel: DiaryViewModel, showModalView: Binding<Bool>) {
        self.viewModel = viewModel
        self.selectYear = viewModel.diary.date?.year ?? 2024
        self._showModalView = showModalView
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
                        dismissWithAnimation()
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
                    dismissWithAnimation()
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
}

#Preview {
    EmotionSelectView(viewModel: DiaryViewModel(), showModalView: .constant(true))
}

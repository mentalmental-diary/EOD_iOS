//
//  DiaryBackgroundSelectView.swift
//  EOD
//
//  Created by JooYoung Kim on 2/8/25.
//

import SwiftUI

struct DiaryBackgroundSelectView: View {
    @State var appearAnimation: Bool = false
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var showModalView: Bool
    @Binding var height: CGFloat
    
    init(viewModel: CalendarViewModel, showModalView: Binding<Bool>, height: Binding<CGFloat>) {
        self.viewModel = viewModel
        self._showModalView = showModalView
        self._height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // dimmed View
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.clear)
                    .zIndex(-1)
                    .onTapGesture {
                        dismissWithAnimation()
                    }
                
                if appearAnimation {
                    VStack {
                        selectDiaryBackgroundView(geometry: geometry)
                            .background(UIColor.CommonBackground.background.color)
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity)
                    
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

extension DiaryBackgroundSelectView {
    @ViewBuilder func selectDiaryBackgroundView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Divider()
                .frame(minHeight: 1.0)
                .overlay(Color(red: 235/255, green: 235/255, blue: 227/255))
            
            HStack {
                Button(action: {
                    dismissWithAnimation()
                }, label: {
                    Image("btn_left")
                })
                
                Spacer()
                
                Text("속지 꾸미기")
                    .font(size: 20)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .background(UIColor.CommonBackground.background.color)
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
            .frame(height: 36)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(Color(red: 235/255, green: 235/255, blue: 227/255))
            
            Spacer().frame(height: 17)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    
                    // 날짜 그리드
                    ForEach(diaryBackgroundType.allCases, id: \.self) { background in
                        ZStack(alignment: .topTrailing) {
                            Image(background.imageName)
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            if viewModel.selectDiaryBackground == background {
                                Image("btnConfirmOn")
                                    .padding(.trailing, 4)
                                    .padding(.top, 4)
                            }
                        }
                        .onTapGesture {
                            viewModel.selectDiaryBackground = background
                        }
                        .frame(width: 105, height: 80)
                        .cornerRadius(14.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(viewModel.selectDiaryBackground == background ? UIColor.Yellow.yellow500.color : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: height)
        .padding(.bottom, geometry.safeAreaInsets.bottom)
    }
}

extension DiaryBackgroundSelectView {
    private func dismissWithAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            appearAnimation = false
            showModalView = false
        }
    }
}

#Preview {
    DiaryBackgroundSelectView(viewModel: CalendarViewModel(), showModalView: .constant(true), height: .constant(150))
}

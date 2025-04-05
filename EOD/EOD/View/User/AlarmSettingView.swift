//
//  AlarmSettingView.swift
//  EOD
//
//  Created by JooYoung Kim on 3/23/25.
//

import SwiftUI

struct AlarmSettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDiaryTimePicker = false
    @State private var showGameTimePicker = false
    @State private var anchorFrame: CGRect = .zero
    
    @State private var expandedPicker: PickerType? = nil
    
    enum PickerType {
        case diary, game
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBarView(title: "알림 설정")
                
                Spacer().frame(height: 28)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("서비스 알림 설정")
                        .font(type: .omyu, size: 22)
                        .foregroundColor(.black)
                    
                    Spacer().frame(height: 14)
                    
                    Text("받고 싶은 알림만 선택해서 푸시로 받을 수 있어요.")
                        .font(type: .omyu, size: 18)
                        .foregroundColor(UIColor.Gray.gray500.color)
                    
                    Spacer().frame(height: 14)
                    
                    notificationToggleView(title: "일기 쓰기 알림", isOn: $viewModel.diaryNotificationEnabled)
                    
                    Spacer().frame(height: 8)
                    
                    if viewModel.diaryNotificationEnabled {
                        notificationDateSelectView(date: viewModel.diaryNotificationTime ?? Date(),
                                                   showPicker: {
                            togglePicker(.diary)
                        }, type: .diary)
                        
                        Spacer().frame(height: 8)
                    }
                    
                    notificationToggleView(title: "게임 플레이 알림", isOn: $viewModel.gameNotificationEnabled)
                    
                    Spacer().frame(height: 8)
                    
                    if viewModel.gameNotificationEnabled {
                        notificationDateSelectView(date: viewModel.gameNotificationTime ?? Date(),
                                                   showPicker: {
                            togglePicker(.game)
                        }, type: .game)
                    }
                    
                    Spacer().frame(height: 22)
                    
                    Text("보안 및 개인 정보 보호")
                        .font(type: .omyu, size: 22)
                        .foregroundColor(.black)
                    
                    Spacer().frame(height: 14)
                    
                    Text("새로운 기능이나 아이템이 나오면 알려드려요.")
                        .font(type: .omyu, size: 18)
                        .foregroundColor(UIColor.Gray.gray500.color)
                    
                    Spacer().frame(height: 14)
                    
                    notificationToggleView(title: "마케팅 정보 알림 수선", isOn: $viewModel.marketingNotificationEnabled)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
            }
            .background(UIColor.CommonBackground.background.color)
            
            // DatePicker 오버레이 추가
            if let pickerType = expandedPicker {
                Color.black.opacity(0.01) // 투명 클릭 가능 배경
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            expandedPicker = nil
                        }
                    }
                
                DatePicker(
                    "",
                    selection: Binding(
                        get: {
                            if pickerType == .diary {
                                return viewModel.diaryNotificationTime ?? Date()
                            } else {
                                return viewModel.gameNotificationTime ?? Date()
                            }
                        },
                        set: { newValue in
                            if pickerType == .diary {
                                viewModel.diaryNotificationTime = newValue
                            } else {
                                viewModel.gameNotificationTime = newValue
                            }
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .frame(width: 221, height: 196)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .colorScheme(.light)
                .transition(.opacity)
                .position(
                    x: anchorFrame.maxX - 120,
                    y: anchorFrame.minY + 80
                )
            }
            
            ToastView(toastManager: viewModel.toastManager)
        }
    }
}

extension AlarmSettingView {
    private func notificationToggleView(title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(type: .omyu, size: 18)
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: UIColor.Yellow.yellow500.color))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .cornerRadius(10)
        
    }
    
    private func notificationDateSelectView(date: Date, showPicker: @escaping (() -> Void), type: PickerType) -> some View {
        HStack(spacing: 0) {
            Image("icon_clock")
            
            Spacer().frame(width: 8)
            
            Text("알림 받을 시간")
                .font(type: .omyu, size: 18)
                .foregroundColor(.black)
            
            Spacer()
            
            GeometryReader { geo in
                Button {
                    anchorFrame = geo.frame(in: .global)
                    showPicker()
                } label: {
                    Text(formattedTime(date))
                        .font(type: .omyu, size: 18)
                        .foregroundColor(Color(red: 107/255, green: 88/255, blue: 23/255))
                        .padding(10)
                        .background(expandedPicker == nil ? UIColor.Yellow.yellow100.color : UIColor.Gray.gray50.color)
                        .cornerRadius(6)
                }
            }
            .frame(width: 90, height: 40) // GeometryReader 고정 크기 필요!
        }
        .padding(.leading, 16)
        .padding(.vertical, 12)
        .background(.white)
        .cornerRadius(10)
    }
}

extension AlarmSettingView {
    private func togglePicker(_ type: PickerType) {
        if expandedPicker == type {
            expandedPicker = nil
        } else {
            expandedPicker = type
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func pickerPositionY(for type: PickerType) -> CGFloat {
        switch type {
        case .diary:
            return 120
        case .game:
            return 200
        }
    }
}

#Preview {
    AlarmSettingView(viewModel: SettingViewModel())
}

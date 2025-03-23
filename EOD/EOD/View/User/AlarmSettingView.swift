//
//  AlarmSettingView.swift
//  EOD
//
//  Created by JooYoung Kim on 3/23/25.
//

import SwiftUI

struct AlarmSettingView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDiaryTimePicker = false
    @State private var showGameTimePicker = false
    @State private var anchorFrame: CGRect = .zero
    
    @State private var expandedPicker: PickerType? = nil
    
    enum PickerType {
        case diary, game
    }
    
    var body: some View {
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
                    ZStack {
                        notificationDateSelectView(date: viewModel.diaryNotificationTime ?? Date(), showPicker: {
                            togglePicker(.diary)
                        })
                        
                        if expandedPicker == .diary {
                            datePickerView(selection: $viewModel.diaryNotificationTime, position: anchorFrame)
                        }
                        
                    }
                    
                    Spacer().frame(height: 8)
                }
                
                notificationToggleView(title: "게임 플레이 알림", isOn: $viewModel.gameNotificationEnabled)
                
                Spacer().frame(height: 8)
                
                if viewModel.gameNotificationEnabled {
                    notificationDateSelectView(date: viewModel.gameNotificationTime ?? Date(), showPicker: {
                        togglePicker(.game)
                    })
                    Spacer().frame(height: 8)
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
        .background(UIColor.CommonBackground.background.color)
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
    
    private func notificationDateSelectView(date: Date, showPicker: @escaping (() -> Void)) -> some View {
        HStack(spacing: 0) {
            Image("icon_clock")
            
            Spacer().frame(width: 8)
            
            Text("알림 받을 시간")
                .font(type: .omyu, size: 18)
                .foregroundColor(.black)
            
            Spacer()
            
            Button {
                showPicker()
            } label: {
                Text(formattedTime(date))
                    .font(type: .omyu, size: 18)
                    .foregroundColor(Color(red: 107/255, green: 88/255, blue: 23/255))
                    .padding(10)
                    .background(UIColor.Yellow.yellow100.color)
                    .cornerRadius(6)
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    anchorFrame = geo.frame(in: .global)
                                }
                        }
                    )
            }

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .cornerRadius(10)
    }
    
    private func datePickerView(selection: Binding<Date?>, position: CGRect) -> some View {
        VStack {
            DatePicker("", selection: Binding(
                get: { selection.wrappedValue ?? Date() },
                set: { newValue in selection.wrappedValue = newValue }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .frame(width: 221, height: 196)
            .background(Color.white)
            .clipped()
        }
        .position(x: position.midX, y: position.minY - 98) // 98은 height의 절반 (위에 뜨도록)
        .transition(.opacity)
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
}

#Preview {
    AlarmSettingView(viewModel: MainViewModel())
}

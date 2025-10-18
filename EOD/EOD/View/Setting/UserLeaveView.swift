import SwiftUI

struct UserLeaveView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isAgreed: Bool = false
    @State private var showConfirmAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar()
            
            Spacer().frame(height: 137)
            
            // 중앙 일러스트레이션
            
            Image("leave_image")
            
            Spacer().frame(height: 48)
            
            Text("노른자의 하루를 그만 사용하고 싶으신가요...")
                .font(type: .omyu, weight: .regular, size: 20)
                .foregroundColor(UIColor.Gray.gray800.color)
            
            Spacer().frame(height: 24)
            
            warningMessageBox()
            
            Spacer()
            
            // 확인 체크박스
            confirmationCheckbox()
            
            Spacer().frame(height: 18)
            
            // 액션 버튼들
            actionButtons()
            
            Spacer().frame(height: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UIColor.CommonBackground.background.color)
        .navigationBarHidden(true)
        .alert("정말 탈퇴하시겠어요?", isPresented: $showConfirmAlert) {
            Button("취소", role: .cancel) { }
            Button("탈퇴하기", role: .destructive) {
                mainViewModel.userLeaveAction()
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("탈퇴 후에는 모든 데이터가 복구되지 않습니다.")
        }
    }
}

// MARK: - View Components
extension UserLeaveView {
    private func navigationBar() -> some View {
        ZStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("icon_back")
                        .frame(maxHeight: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0.0, leading: 13.0, bottom: 2.0, trailing: 16.0))
                        .foregroundColor(Color.black)
                }
                
                Spacer()
            }
            HStack {
                Spacer()
                Text("회원 탈퇴")
                    .font(type: .omyu, size: 22)
                    .foregroundColor(.black)
                Spacer()
            }
            
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
    }
    
    private func warningMessageBox() -> some View {
        HStack(alignment: .top, spacing: 12) {
            // 경고 아이콘
            Image("error_icon")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("회원 탈퇴 시 지금까지의 모든 기록이 지워져요.")
                    .font(type: .omyu, size: 16)
                    .foregroundColor(.red)
                
                Text("(일기, 감정 아이콘, 게임 정보, 아이템 구매 내역, 재화 정보 등)")
                    .font(type: .omyu, size: 14)
                    .foregroundColor(UIColor.Gray.gray800.color)
                
                Text("탈퇴 후에는 복구할 수 없으니 신중히 진행해주세요.")
                    .font(type: .omyu, size: 16)
                    .foregroundColor(UIColor.Gray.gray800.color)
            }
        }
        .padding(.top, 12)
        .padding(.leading, 15)
        .padding(.trailing, 11)
        .padding(.bottom, 11)
        .background(Color(red: 239/255, green: 239/255, blue: 228/255))
        .cornerRadius(11)
        .padding(.horizontal, 20)
    }
    
    private func confirmationCheckbox() -> some View {
        HStack(spacing: 4) {
            Button(action: {
                isAgreed.toggle()
            }) {
                Image(isAgreed ? "btnConfirmOn" : "btnConfirmOff")
            }
            
            Text("위 내용을 전부 확인하였으며 계속 진행하겠습니다.")
                .font(type: .omyu, size: 16)
                .foregroundColor(UIColor.Gray.gray800.color)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private func actionButtons() -> some View {
        VStack(spacing: 12) {
            // 탈퇴 버튼
            Button(action: {
                if isAgreed {
                    showConfirmAlert = true
                }
            }) {
                Text("탈퇴할래요")
                    .font(type: .omyu, size: 20)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isAgreed ? Color(red: 255/255, green: 89/255, blue: 89/255) : Color(red: 211/255, green: 210/255, blue: 207/255))
                    .cornerRadius(8)
            }
            .disabled(!isAgreed)
            
            // 계속 사용 버튼
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("계속 써 볼래요")
                    .font(type: .omyu, size: 20)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    UserLeaveView(mainViewModel: MainViewModel())
}

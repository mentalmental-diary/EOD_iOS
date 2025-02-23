//
//  UserInfoSetView.swift
//  EOD
//
//  Created by JooYoung Kim on 12/29/24.
//

import SwiftUI

struct UserInfoSetView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State var inputNickname: String = ""
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Text("닉네임 설정")
                            .font(size: 28)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 56)
                    
                    Text("노른자의 하루에서 사용할")
                        .font(size: 22)
                        .foregroundColor(.black)
                        .background(
                            GeometryReader { geometry in
                                UIColor.Yellow.yellow200.color
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Text("닉네임을 알려주세요!")
                        .font(size: 22)
                        .foregroundColor(.black)
                        .background(
                            GeometryReader { geometry in
                                UIColor.Yellow.yellow200.color
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Spacer().frame(height: 137)
                    
                    nicknameView()
                    
                    Spacer().frame(height: 250)
                    
                    bottonView()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                ToastView(toastManager: viewModel.toastManager)
            }
            .background(UIColor.CommonBackground.background.color)
            .ignoresSafeArea(.keyboard)
        }
        
    }
}

extension UserInfoSetView {
    private func nicknameView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .font(type: .omyu, size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 20)
            
            CustomTextField(text: $inputNickname, placeholder: "닉네임을 입력해주세요.")
                .frame(height: 16)
            
            Spacer().frame(height: 16)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputNickname.isEmpty ? UIColor.Gray.gray500.color : Color.black)
            
            Spacer().frame(height: 14)
            
            Text("닉네임은 설정 > 시스템 설정 > 프로필 관리에서 변경할 수 있어요.")
                .font(size: 14)
                .foregroundColor(UIColor.Gray.gray700.color)
        }
    }
    
    private func bottonView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.confirmTerms.toggle() // TODO: 약관 관련 값 변경
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Spacer().frame(width: 4)
                
                HStack(spacing: 0) {
                    Text("(필수) ")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    
                    Button {
                        
                    } label: {
                        Text("개인 정보 처리 방침")
                            .underline()
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                    
                    Text(" 및 ")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    
                    Button {
                        
                    } label: {
                        Text("서비스 이용 약관")
                            .underline()
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                    
                    Text("에 동의합니다.")
                        .font(.system(size: 13))
                        .foregroundColor(.black)

                }
            }
            
            Spacer().frame(height: 6)
            
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.confirmTerms.toggle()
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Spacer().frame(width: 4)
                
                Text("(선택) 이벤트 및 광고성 알림 수신에 동의합니다.")
                    .font(.system(size: 13))
                    .foregroundColor(.black)
            }
            
            Spacer().frame(height: 22)
            
            Button(action: {
                viewModel.setNickname(nickName: inputNickname)
            }, label: {
                Text("시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.confirmTerms ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                    .cornerRadius(8.0)
                    .contentShape(Rectangle()) // 전체 영역이 터치 가능하도록 설정
            })
        }
    }
}

private struct CustomTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    @Binding var text: String
    var placeholder: String
    var placeholderColor: UIColor = UIColor.Gray.gray500.uiColor ?? UIColor.gray
    var placeholderFont: UIFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = UIFont(name: "Pretendard-Medium", size: 16)
        textField.backgroundColor = UIColor.clear
        textField.returnKeyType = .done
        // Placeholder 스타일 적용
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: placeholderFont
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textField.textColor = UIColor.black
        
        // Adding the toolbar
        let toolbar = ShadowToolbar()
        toolbar.sizeToFit()
        
        // Setting the toolbar height
        let customToolbarHeight: CGFloat = 36
        var frame = toolbar.frame
        frame.size.height = customToolbarHeight
        toolbar.frame = frame
        toolbar.barTintColor = UIColor(red: 251/255, green: 251/255, blue: 244/255, alpha: 1.0)
        
        // Adding buttons to the toolbar
        
        let doneButton = UIButton(type: .system)
        doneButton.setImage(UIImage(named: "keyboard_close"), for: .normal)
        doneButton.tintColor = UIColor.black
        doneButton.addTarget(context.coordinator, action: #selector(Coordinator.dismissKeyboard(_:)), for: .touchUpInside)
        
        let doneBarButton = UIBarButtonItem(customView: doneButton)
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBarButton
        ]
        
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        
        init(parent: CustomTextField) {
            self.parent = parent
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }
        
        /// TextView 정보 업데이트
        func updateTextView(_ textView: UITextView) {
            
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }
        
        @objc func dismissKeyboard(_ sender: UIBarButtonItem) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct UserInfoSetView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoSetView(viewModel: MainViewModel())
    }
}

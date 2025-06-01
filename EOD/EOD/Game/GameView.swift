//
//  GameView.swift
//  EOD
//
//  Created by JooYoung Kim on 8/24/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameDataViewModel: GameDataViewModel = GameDataViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 5) {
                    Image("icon_egg")
                    
                    Text(gameDataViewModel.userGold?.formattedDecimal() ?? "0")
                        .font(size: 20)
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                .clipShape(Capsule())
            }
            
            Spacer().frame(height: 16)
            
            TabView(selection: $gameDataViewModel.selectedIndex) {
                ForEach(gameDataViewModel.gameDataList.indices, id: \.self) { index in
                    GamePageView(gameData: gameDataViewModel.gameDataList[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer().frame(height: 16)
            
            PageControlView(currentPage: $gameDataViewModel.selectedIndex, pages: gameDataViewModel.gameDataList.count)
            
            Spacer().frame(height: 16)
            
            HStack(spacing: 2) {
                Text(gameDataViewModel.selectedGame.game.title)
                    .font(size: 28)
                    .background(
                        GeometryReader { geometry in
                            (UIColor.Yellow.yellow200.color)
                                .frame(width: geometry.size.width, height: 9)
                                .offset(x: 0, y: geometry.size.height - 8)
                        }
                    )
                
                Button {
                    // TODO: Info Alert노출해야함
                } label: {
                    Image("icon_question")
                }

            }
            
            Spacer().frame(height: 14)
            
            GameDescriptionView(gameData: gameDataViewModel.selectedGame)
        }
        .padding(.horizontal, 20)
    }
}

extension GameView {
    private func GamePageView(gameData: GameData) -> some View {
        ZStack(alignment: .top) {
            Image(gameData.game.thumbnailImageName)
                .resizable()
                .scaledToFit()
                .clipped()
            
            HStack(spacing: 4) {
                Text("나의 최고 점수")
                    .font(type: .omyu, size: 18)
                    .foregroundColor(UIColor.Gray.gray900.color)
                    .padding(.leading, 6)
                
                Text("\(gameData.score)")
                    .font(type: .omyu, size: 18)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Color.white)
                    .cornerRadius(6)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .background(Color(red: 235/255, green: 235/255, blue: 221/255))
            .cornerRadius(6)
            .offset(y: 12)
        }
    }
    
    @ViewBuilder func GameDescriptionView(gameData: GameData) -> some View {
        VStack(spacing: 0) {
            Text(gameData.game.mainDescription)
                .font(type: .omyu, size: 18)
                .foregroundColor(UIColor.Gray.gray900.color)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer().frame(height: 32)
            
            SpeechBubbleView(text: gameDataViewModel.gameLimitText)
            
            Spacer().frame(height: 4)
            
            GameStartButton()
            
            Spacer().frame(height: 8)
            
            Text("* 1회당 10골드 획득")
                .font(type: .omyu, size: 14)
                .foregroundColor(UIColor.Gray.gray700.color)
        }
        .padding(.vertical, 37)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(16)
    }
    
    private func SpeechBubbleView(text: String) -> some View {
        VStack(spacing: 0) {
            Text(text)
                .font(type: .omyu, size: 16)
                .foregroundColor(UIColor.Gray.gray800.color)
                .padding(.vertical, 12.5)
                .padding(.horizontal, 19)
                .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                .cornerRadius(40)
            
            Triangle()
                .fill(Color(red: 0.94, green: 0.94, blue: 0.88))
                .frame(width: 16, height: 8)
                .rotationEffect(.degrees(180))
        }
    }
    
    private func GameStartButton() -> some View {
        Button {
            guard gameDataViewModel.checkGameLimit else { return }

#if !PREVIEW
            GameManager.shared.launchUnity()
            gameDataViewModel.sendGameStartMessage(for: gameDataViewModel.selectedGame.game)
#endif
        } label: {
            VStack(spacing: 0) {
                Text("게임 시작")
                    .font(type: .omyu, size: 20)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 41.5)
                    .background(Color(red: 255/255, green: 241/255, blue: 193/255))
                    .cornerRadius(8)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    GameView()
}

//
//  DiaryViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 6/10/24.
//

import Foundation

class DiaryViewModel: ObservableObject {
    @Published var showEmotionSelectView: Bool = false
    
    @Published var diary: Diary = Diary()
    
    var original: Diary? // 수정진입이 최초 일기 정보
    
    init(original: Diary? = nil) {
        self.original = original
        self.diary = original ?? Diary()
        
        self.showEmotionSelectView = original == nil // 초기 작성 진입인경우 모달 노출
    }
}

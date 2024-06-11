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
    
    var selectDate: Date?
    
    var original: Diary? // 수정진입이 최초 일기 정보
    
    init(original: Diary? = nil, selectDate: Date? = nil) {
        self.original = original
        self.diary = original ?? Diary()
        
        self.selectDate = selectDate
        
        self.showEmotionSelectView = self.diary.emotion == nil // 저장된 감정 표현이 없을 경우 노출
    }
}

extension DiaryViewModel {
    var isModify: Bool { return original != nil }
}

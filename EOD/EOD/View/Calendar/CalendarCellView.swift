//
//  CalendarCellView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct CalendarCellView: View {
    var day: Int
    
    var body: some View {
        if day == 0 {
            Rectangle()
                .foregroundColor(.clear)
        } else {
            VStack(spacing: 2) {
                if day == 16 { // TODO: 임시 설정 -> 입력된 날짜 기록에 따라 변경될예정
                    Image("angry")
                } else {
                    Image("default")
                }
                Text("\(day)")
                    .font(size: 12)
                    .foregroundColor(UIColor.Gray.gray300.color)
                    .background(Color.clear)
            }
        }
    }
}

#Preview {
    CalendarCellView(day: 1)
}

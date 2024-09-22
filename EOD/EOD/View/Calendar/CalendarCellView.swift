//
//  CalendarCellView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct CalendarCellView: View {
    var day: Int
    var emotionType: EmotionType? = nil
    
    var body: some View {
        if day == 0 {
            Rectangle()
                .foregroundColor(.clear)
        } else {
            VStack(spacing: 2) {
                if day == today {
                    Image(emotionType?.imageName ?? "icon_today")
                        .frame(width: 36, height: 34)
                } else {
                    Image(emotionType?.imageName ?? "icon_default")
                        .frame(width: 36, height: 34)
                }
                
                Text("\(day)")
                    .font(size: 12)
                    .foregroundColor(UIColor.Gray.gray300.color)
                    .background(Color.clear)
            }
        }
    }
}

extension CalendarCellView {
    private var today: Int {
        let calendar = Calendar.current

        let day = calendar.component(.day, from: Date())
        
        return day
    }
}

#Preview {
    CalendarCellView(day: 1)
}

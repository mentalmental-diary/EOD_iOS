//
//  CalendarCellView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct CalendarCellView: View {
    var day: Int
    var diaryInfo: DiarySummary? = nil
    var selectDay: Date? = nil
    
    var body: some View {
        if day == 0 {
            Rectangle()
                .foregroundColor(.clear)
        } else {
            VStack(spacing: 2) {
                if day == today {
                    Image(diaryInfo?.emotion.imageName ?? "icon_today")
                        .frame(width: 36, height: 34)
                } else {
                    Image(diaryInfo?.emotion.imageName ?? "icon_default")
                        .frame(width: 36, height: 34)
                }
                
                Text("\(day)")
                    .font(size: 12)
                    .foregroundColor(dayColor)
                    .padding(.horizontal, 8)
                    .frame(width: 26, height: 12)
                    .background(dayBGColor)
                    .cornerRadius(20)
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
    
    private var dayColor: Color {
        if selectDay == nil {
            return today == day ? .black : UIColor.Gray.gray300.color
        } else {
            return selectDay?.day == day ? .white : UIColor.Gray.gray300.color
        }
    }
    
    private var dayBGColor: Color {
        return selectDay?.day == day ? .black : .clear
    }
}

#Preview {
    CalendarCellView(day: 1)
}

#Preview {
    CalendarCellView(day: 5, selectDay: Date())
}

//
//  NotificationType.swift
//  EOD
//
//  Created by JooYoung Kim on 2/16/25.
//

/// 실제 알림 (알림목록, 푸시) 에서 사용하는 타입
enum NotificationType: String, CaseIterable, Decodable {
    case SELECTIVE_NOTIFICATION // 서비스 공지 알림
    case LIVE_BROADCASTER
    case PROMOTION_BROADCASTER
    case LIVE_PUSH_ONE
    case AI_CUE_SHEET_NOTIFICATION
    case SHORTCLIP_COMMENT_NOTIFICATION
    
    case BROADCAST_WEEKLY_TRADING_AMOUNT // 주간 라이브 거래액
    case SHORTCLIP_WEEKLY_TRADING_AMOUNT // 주간 숏클립 거래액
    case MONTHLY_NOTIFICATION_COUNT_ACHIEVEMENT // 월간 알림받기수 성과
    case BROADCAST_MONTHLY_HIGH_RECORD_ACHIEVEMENT // 월간 라이브 하이레코드
    case SHORTCLIP_MONTHLY_HIGH_RECORD_ACHIEVEMENT // 월간 숏클립 하이레코드
    case NEW_FEATURE_UPDATE // 신규 기능공지
    case BROADCAST_UPLOAD_SUGGESTION_CHECK_SCHEDULED // 라이브 업로드 권유
    case BROADCAST_UPLOAD_SUGGESTION_CREATE // 라이브 업로드 권유
    case SHORTCLIP_UPLOAD_SUGGESTION_CREATE // 숏클립 업로드 권유
}

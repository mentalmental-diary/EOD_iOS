//
//  UserDefaultsManager.swift
//  EOD
//
//  사용자별 로컬 데이터 관리 유틸리티
//

import Foundation

/// UserDefaults 기반 로컬 데이터 관리자
/// - 유저별 독립 데이터를 {userNo}_key 형식으로 저장
/// - 세션 데이터와 전역 데이터 분리 관리
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    // MARK: - 현재 로그인된 사용자 정보
    
    /// 현재 로그인된 사용자의 userNo
    var currentUserNo: Int? {
        get { defaults.integer(forKey: Keys.currentUserNo) }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Keys.currentUserNo)
            } else {
                defaults.removeObject(forKey: Keys.currentUserNo)
            }
        }
    }
    
    // MARK: - 세션 데이터 (로그아웃 시 삭제)
    
    var accessToken: String? {
        get { defaults.string(forKey: Keys.accessToken) }
        set { setOrRemove(newValue, forKey: Keys.accessToken) }
    }
    
    var refreshToken: String? {
        get { defaults.string(forKey: Keys.refreshToken) }
        set { setOrRemove(newValue, forKey: Keys.refreshToken) }
    }
    
    var isLogin: Bool {
        get { defaults.bool(forKey: Keys.isLogin) }
        set { defaults.set(newValue, forKey: Keys.isLogin) }
    }
    
    // MARK: - 유저별 독립 데이터 (로그아웃 시 유지, 탈퇴 시 삭제)
    
    /// 게임 최고 점수 조회/저장
    func getGameScore(for gameType: GameType, userNo: Int) -> Int {
        return defaults.integer(forKey: userKey(userNo, gameType.scoreKey))
    }
    
    func setGameScore(_ score: Int, for gameType: GameType, userNo: Int) {
        defaults.set(score, forKey: userKey(userNo, gameType.scoreKey))
    }
    
    /// 게임 코인 조회/저장
    func getGameCoin(for gameType: GameType, userNo: Int) -> Int {
        return defaults.integer(forKey: userKey(userNo, gameType.coinKey))
    }
    
    func setGameCoin(_ coin: Int, for gameType: GameType, userNo: Int) {
        defaults.set(coin, forKey: userKey(userNo, gameType.coinKey))
    }
    
    /// 게임 일일 접근 데이터
    func getGameDailyAccess(for gameType: GameType, userNo: Int) -> GameDailyAccessData? {
        guard let data = defaults.data(forKey: userKey(userNo, gameType.dailyAccessKey)),
              let decoded = try? JSONDecoder().decode(GameDailyAccessData.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    func setGameDailyAccess(_ data: GameDailyAccessData, for gameType: GameType, userNo: Int) {
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: userKey(userNo, gameType.dailyAccessKey))
        }
    }
    
    /// 알림 설정
    func getDiaryNotificationEnabled(userNo: Int) -> Bool {
        return defaults.bool(forKey: userKey(userNo, "diaryNotificationEnabled"))
    }
    
    func setDiaryNotificationEnabled(_ enabled: Bool, userNo: Int) {
        defaults.set(enabled, forKey: userKey(userNo, "diaryNotificationEnabled"))
    }
    
    func getGameNotificationEnabled(userNo: Int) -> Bool {
        return defaults.bool(forKey: userKey(userNo, "gameNotificationEnabled"))
    }
    
    func setGameNotificationEnabled(_ enabled: Bool, userNo: Int) {
        defaults.set(enabled, forKey: userKey(userNo, "gameNotificationEnabled"))
    }
    
    func getMarketingNotificationEnabled(userNo: Int) -> Bool {
        return defaults.bool(forKey: userKey(userNo, "marketingNotificationEnabled"))
    }
    
    func setMarketingNotificationEnabled(_ enabled: Bool, userNo: Int) {
        defaults.set(enabled, forKey: userKey(userNo, "marketingNotificationEnabled"))
    }
    
    func getDiaryNotificationTime(userNo: Int) -> Date? {
        return defaults.object(forKey: userKey(userNo, "diaryNotificationTime")) as? Date
    }
    
    func setDiaryNotificationTime(_ time: Date?, userNo: Int) {
        setOrRemove(time, forKey: userKey(userNo, "diaryNotificationTime"))
    }
    
    func getGameNotificationTime(userNo: Int) -> Date? {
        return defaults.object(forKey: userKey(userNo, "gameNotificationTime")) as? Date
    }
    
    func setGameNotificationTime(_ time: Date?, userNo: Int) {
        setOrRemove(time, forKey: userKey(userNo, "gameNotificationTime"))
    }
    
    /// 앱 잠금 설정
    func getLockEnabled(userNo: Int) -> Bool {
        return defaults.bool(forKey: userKey(userNo, "lockEnable"))
    }
    
    func setLockEnabled(_ enabled: Bool, userNo: Int) {
        defaults.set(enabled, forKey: userKey(userNo, "lockEnable"))
    }
    
    func getAppPassword(userNo: Int) -> String? {
        return defaults.string(forKey: userKey(userNo, "appPassword"))
    }
    
    func setAppPassword(_ password: String?, userNo: Int) {
        setOrRemove(password, forKey: userKey(userNo, "appPassword"))
    }
    
    // MARK: - 데이터 삭제
    
    /// 로그아웃 시: 세션 데이터만 삭제
    func clearSessionData() {
        defaults.removeObject(forKey: Keys.accessToken)
        defaults.removeObject(forKey: Keys.refreshToken)
        defaults.removeObject(forKey: Keys.isLogin)
        defaults.removeObject(forKey: Keys.currentUserNo)
        
        debugLog("✅ 세션 데이터 삭제 완료")
    }
    
    /// 회원 탈퇴 시: 해당 유저의 모든 데이터 삭제
    func clearUserData(userNo: Int) {
        // 게임 데이터
        for gameType in GameType.allCases {
            defaults.removeObject(forKey: userKey(userNo, gameType.scoreKey))
            defaults.removeObject(forKey: userKey(userNo, gameType.coinKey))
            defaults.removeObject(forKey: userKey(userNo, gameType.dailyAccessKey))
        }
        
        // 알림 설정
        defaults.removeObject(forKey: userKey(userNo, "diaryNotificationEnabled"))
        defaults.removeObject(forKey: userKey(userNo, "gameNotificationEnabled"))
        defaults.removeObject(forKey: userKey(userNo, "marketingNotificationEnabled"))
        defaults.removeObject(forKey: userKey(userNo, "diaryNotificationTime"))
        defaults.removeObject(forKey: userKey(userNo, "gameNotificationTime"))
        
        // 보안 설정
        defaults.removeObject(forKey: userKey(userNo, "lockEnable"))
        defaults.removeObject(forKey: userKey(userNo, "appPassword"))
        
        debugLog("✅ 유저 데이터 삭제 완료: userNo=\(userNo)")
    }
    
    // MARK: - 기존 사용자 데이터 마이그레이션
    
    /// 기존 형식의 데이터를 새 형식으로 마이그레이션
    /// - Parameter userNo: 마이그레이션할 사용자 번호
    func migrateOldDataIfNeeded(userNo: Int) {
        // 이미 마이그레이션했는지 확인
        let migrationKey = "migrated_\(userNo)"
        if defaults.bool(forKey: migrationKey) {
            debugLog("✅ userNo=\(userNo)의 데이터는 이미 마이그레이션됨")
            return
        }
        
        debugLog("🔄 userNo=\(userNo)의 기존 데이터 마이그레이션 시작...")
        
        // 게임 데이터 마이그레이션
        for gameType in GameType.allCases {
            // 점수
            if let oldScore = defaults.object(forKey: gameType.scoreKey) as? Int {
                setGameScore(oldScore, for: gameType, userNo: userNo)
                defaults.removeObject(forKey: gameType.scoreKey)
                debugLog("  ✅ \(gameType.scoreKey): \(oldScore) → \(userNo)_\(gameType.scoreKey)")
            }
            
            // 코인
            if let oldCoin = defaults.object(forKey: gameType.coinKey) as? Int {
                setGameCoin(oldCoin, for: gameType, userNo: userNo)
                defaults.removeObject(forKey: gameType.coinKey)
                debugLog("  ✅ \(gameType.coinKey): \(oldCoin) → \(userNo)_\(gameType.coinKey)")
            }
            
            // 일일 접근 데이터
            if let oldData = defaults.data(forKey: gameType.dailyAccessKey) {
                defaults.set(oldData, forKey: userKey(userNo, gameType.dailyAccessKey))
                defaults.removeObject(forKey: gameType.dailyAccessKey)
                debugLog("  ✅ \(gameType.dailyAccessKey) → \(userNo)_\(gameType.dailyAccessKey)")
            }
        }
        
        // 알림 설정 마이그레이션
        if defaults.object(forKey: "diaryNotificationEnabled") != nil {
            let enabled = defaults.bool(forKey: "diaryNotificationEnabled")
            setDiaryNotificationEnabled(enabled, userNo: userNo)
            defaults.removeObject(forKey: "diaryNotificationEnabled")
            debugLog("  ✅ diaryNotificationEnabled: \(enabled)")
        }
        
        if defaults.object(forKey: "gameNotificationEnabled") != nil {
            let enabled = defaults.bool(forKey: "gameNotificationEnabled")
            setGameNotificationEnabled(enabled, userNo: userNo)
            defaults.removeObject(forKey: "gameNotificationEnabled")
            debugLog("  ✅ gameNotificationEnabled: \(enabled)")
        }
        
        if defaults.object(forKey: "marketingNotificationEnabled") != nil {
            let enabled = defaults.bool(forKey: "marketingNotificationEnabled")
            setMarketingNotificationEnabled(enabled, userNo: userNo)
            defaults.removeObject(forKey: "marketingNotificationEnabled")
            debugLog("  ✅ marketingNotificationEnabled: \(enabled)")
        }
        
        if let oldTime = defaults.object(forKey: "diaryNotificationTime") as? Date {
            setDiaryNotificationTime(oldTime, userNo: userNo)
            defaults.removeObject(forKey: "diaryNotificationTime")
            debugLog("  ✅ diaryNotificationTime: \(oldTime)")
        }
        
        if let oldTime = defaults.object(forKey: "gameNotificationTime") as? Date {
            setGameNotificationTime(oldTime, userNo: userNo)
            defaults.removeObject(forKey: "gameNotificationTime")
            debugLog("  ✅ gameNotificationTime: \(oldTime)")
        }
        
        // 보안 설정 마이그레이션
        if defaults.object(forKey: "lockEnable") != nil {
            let enabled = defaults.bool(forKey: "lockEnable")
            setLockEnabled(enabled, userNo: userNo)
            defaults.removeObject(forKey: "lockEnable")
            debugLog("  ✅ lockEnable: \(enabled)")
        }
        
        if let oldPassword = defaults.string(forKey: "appPassword") {
            setAppPassword(oldPassword, userNo: userNo)
            defaults.removeObject(forKey: "appPassword")
            debugLog("  ✅ appPassword 마이그레이션 완료")
        }
        
        // 마이그레이션 완료 표시
        defaults.set(true, forKey: migrationKey)
        debugLog("✅ userNo=\(userNo)의 데이터 마이그레이션 완료!")
    }
    
    // MARK: - Helper Methods
    
    /// 유저별 키 생성: "{userNo}_{key}"
    private func userKey(_ userNo: Int, _ key: String) -> String {
        return "\(userNo)_\(key)"
    }
    
    /// nil이면 삭제, 값이 있으면 저장
    private func setOrRemove(_ value: Any?, forKey key: String) {
        if let value = value {
            defaults.set(value, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
    
    // MARK: - Keys
    
    private struct Keys {
        static let currentUserNo = "currentUserNo"
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let isLogin = "isLogin"
    }
}


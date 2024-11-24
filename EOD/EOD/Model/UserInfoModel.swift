//
//  UserInfoModel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/16/24.
//

class UserInfoModel: Decodable {
    let characterInfo: [CharacterItem]
    let roomItems: [String: ThemeItem]
}

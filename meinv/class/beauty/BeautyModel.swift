//
//  BeautyModel.swift
//  meinv
//
//  Created by tropsci on 16/3/14.
//  Copyright © 2016年 topsci. All rights reserved.
//

import Argo
import Curry

enum ResposeCode: Int {
    case NoError = 0
    case InvalidType = 421
    case InvalidUsername = 431
    case UsernameHasBeenUsed = 432
    case InvalidPassword = 433
    case IncorrectUsernameOrPassword = 441
}

extension ResposeCode: Decodable {}

struct RequestResult {
    let code:       ResposeCode
    let desc:       String
    let beauties:   [Beauty]?
    let types: [String]?
    let userInfo: UserInfo?
}

extension RequestResult: Decodable {
    static func decode(json: JSON) -> Decoded<RequestResult> {
        return curry(RequestResult.init)
        <^> json <| "code"
        <*> json <| "desc"
        <*> json <||? "beauties"
        <*> json <||? "types"
        <*> json <|? "user_info"
    }
}

struct Beauty {
    let name:   String
    let url:    String
    let type:   String
    let width:  Int
    let height: Int
    let beautyID: Int
    let favorited: Bool
}

extension Beauty: Decodable {
    static func decode(json: JSON) -> Decoded<Beauty> {
        return curry(Beauty.init)
        <^> json <| "name"
        <*> json <| "url"
        <*> json <| "type"
        <*> json <| "width"
        <*> json <| "height"
        <*> json <| "image_id"
        <*> json <| "favorited"
    }
}

struct UserInfo {
    let username: String
    let userNickname: String
    let userUUID: String
}

extension UserInfo: Decodable {
    static func decode(json: JSON) -> Decoded<UserInfo> {
        return curry(UserInfo.init)
            <^> json <| "user_name"
            <*> json <| "user_nickname"
            <*> json <| "user_uuid"
    }
}

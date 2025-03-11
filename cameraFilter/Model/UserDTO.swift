//
//  UserDTO.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation

struct UserDTO {
    let uid : String
    let nickname : String
    let idToken : String
    let accessToken : String
    let loginType : String
    let pn : String
    let regDate : String
    
    // data layer 에 필요한 정보들
}

extension UserDTO
{
    func toEntity() -> User
    {
        return User(uid: uid, nickname: nickname, idToken: idToken, accessToken: accessToken, loginType: loginType, pn: pn, regDate: regDate)
    }
}

//
//  UserLoginRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine

protocol UserLoginRepositoryProtocol {
//    var onUserLoginPublisher: AnyPublisher<UserDTO, Error> { get }
    func userLogin(loginType : LoginType) -> UserDTO?
}

class UserLoginRepository : UserLoginRepositoryProtocol {
    
//    private let onUserLoginSubject = PassthroughSubject<UserDTO, Error>()
//
//    var onUserLoginPublisher: AnyPublisher<UserDTO, Error> {
//        onUserLoginSubject.eraseToAnyPublisher()
//    }
    
    func userLogin(loginType: LoginType) -> UserDTO? {
        
        if loginType == .apple {
            return appleLoginProcess()
        }
        else if loginType == .google
        {
            return googleLoginProcess()
        }
        else
        {
            return nil
        }
    }
    
    func appleLoginProcess() -> UserDTO? {
        let dummy = UserDTO(uid: "test", nickname: "test", idToken: "test", accessToken: "test", loginType: "test", pn: "test", regDate: "test")
        return dummy
    }
    
    func googleLoginProcess() -> UserDTO? {
        let dummy = UserDTO(uid: "test", nickname: "test", idToken: "test", accessToken: "test", loginType: "test", pn: "test", regDate: "test")
        return dummy
    }
}

//
//  UserLoginRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine
import AuthenticationServices
import CryptoKit

protocol UserLoginRepositoryProtocol {
    //    var onUserLoginPublisher: AnyPublisher<UserDTO, Error> { get }
    func userLogin(loginType : LoginType) -> AnyPublisher<User, Error>
}

class UserLoginRepository : UserLoginRepositoryProtocol {
    
    var authManger : AuthManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager : AuthManagerProtocol)
    {
        self.authManger = authManager
    }
    
    func userLogin(loginType: LoginType) -> AnyPublisher<User, Error> {
        
        authManger.signinWithApple()
        
        return authManger.onSNSLoginPublisher
            .map { result in
                UserDTO(uid: result.uid, nickname: result.nickname, idToken: result.idToken, loginType: result.loginType, pn: "SNS", regDate: Date().toString())
                    .toEntity()
            }
            .eraseToAnyPublisher()
    }
    
    private func appleLoginProcess(result authResult : AuthResult) -> UserDTO? {
        let dummy = UserDTO(uid: "test", nickname: "test", idToken: "Test", loginType: "test", pn: "test", regDate: "test")
        return dummy
    }
    
    private func googleLoginProcess() -> UserDTO? {
        let dummy = UserDTO(uid: "test", nickname: "test", idToken: "Test", loginType: "test", pn: "test", regDate: "test")
        return dummy
    }
}

//
//  UserLoginUseCase.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine

protocol UserLoginUseCaseProtocol {
    func checkUserInvalid()
    func excute(loginType : LoginType) -> AnyPublisher<User, Error>
}

class UserLoginUseCase : UserLoginUseCaseProtocol {
    
    var userLoginRepository : UserLoginRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository : UserLoginRepositoryProtocol)
    {
        self.userLoginRepository = repository
    }
    
    func checkUserInvalid() {
        
    }
    
    func excute(loginType: LoginType) -> AnyPublisher<User, Error> {
        
        return userLoginRepository.userLogin(loginType: loginType)
    }
}

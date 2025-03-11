//
//  UserLoginUseCase.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine

protocol UserLoginUseCaseProtocol {
    var onUserLoginPublisher : AnyPublisher<User, Error> { get }
    func checkUserInvalid()
    func excute(loginType : LoginType)
}

class UserLoginUseCase : UserLoginUseCaseProtocol {
    
    var userLoginRepository : UserLoginRepositoryProtocol
    
    private let onUserLoginSubject = PassthroughSubject<User, Error>()
    
    var onUserLoginPublisher: AnyPublisher<User, Error> {
        onUserLoginSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository : UserLoginRepositoryProtocol)
    {
        self.userLoginRepository = repository
    }
    
    func checkUserInvalid() {
        
    }
    
    func excute(loginType: LoginType) {
        
        guard let responseDTO = userLoginRepository.userLogin(loginType: loginType) else {
            return
        }
        
        let userEntity = responseDTO.toEntity()
        
        onUserLoginSubject.send(userEntity)
    }
}

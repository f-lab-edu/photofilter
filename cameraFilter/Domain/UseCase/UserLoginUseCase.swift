//
//  UserLoginUseCase.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine

enum LoginState: Equatable {
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.trying, .trying), (.loggedIn, .loggedIn), (.loggedOut, .loggedOut):
            return true
        default:
            return false
        }
    }
    
    case initial
    case trying
    case loggedIn
    case loggedOut
    case error(LoginError)
}

protocol UserLoginUseCaseProtocol {
    var onLoginStateUpdate : AnyPublisher<LoginState?, Error> { get }
    func checkUserInvalid()
    func login(loginType : LoginType)
}


class UserLoginUseCase : UserLoginUseCaseProtocol {
   
    
    private let userLoginSubject = CurrentValueSubject<LoginState?, Error>(nil)
    
    var onLoginStateUpdate: AnyPublisher<LoginState?, Error> {
        userLoginSubject.eraseToAnyPublisher()
    }
    
    let userLoginRepository : UserLoginRepositoryProtocol
    
    init(repository : UserLoginRepositoryProtocol)
    {
        self.userLoginRepository = repository
    }
    
    func checkUserInvalid() {
        
    }
    
    func login(loginType: LoginType) {
        
        userLoginSubject.send(.trying)
        
        userLoginRepository.userLogin(loginType: loginType) { [weak self] result in
            //result 에 따라서 userSubject 업데이트
            switch result {
            case .success(let userDTO):
                self?.userLoginSubject.send(.loggedIn)
            case .failure(let error):
                self?.userLoginSubject.send(.error(error))
            }
        }
    }
}

class UserLoginUseCaseMock : UserLoginUseCaseProtocol {
    
    private let userLoginSubject = CurrentValueSubject<LoginState?, Error>(nil)
    
    var onLoginStateUpdate: AnyPublisher<LoginState?, any Error>
    {
        userLoginSubject.eraseToAnyPublisher()
    }
    
    let userLoginRepository : UserLoginRepositoryProtocol
    
    init(repository : UserLoginRepositoryProtocol)
    {
        self.userLoginRepository = repository
    }
    
    func checkUserInvalid() {
        
    }
    
    func login(loginType: LoginType) {
        userLoginSubject.send(.error(.error(msg: "Failed Login")))
    }
}

//
//  UserLoginUseCase.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine

protocol UserLoginUseCaseProtocol {
    var loginState: UserLoginUseCase.LoginState { get }
    var onLoginStateUpdate : AnyPublisher<UserLoginUseCase.LoginState?, Error> { get }
    func checkUserInvalid()
    func login(loginType : LoginType)
}


class UserLoginUseCase : UserLoginUseCaseProtocol {
    enum LoginState: Equatable {
        static func == (lhs: UserLoginUseCase.LoginState, rhs: UserLoginUseCase.LoginState) -> Bool {
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
    
    var loginState: LoginState = .initial
    
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

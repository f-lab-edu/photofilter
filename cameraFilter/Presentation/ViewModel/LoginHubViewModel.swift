//
//  LoginHubViewModel.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/8/25.
//

import SwiftUI
import Combine

class LoginHubViewModel: ObservableObject {
    enum UserLoginState: Equatable {
        static func == (lhs: LoginHubViewModel.UserLoginState, rhs: LoginHubViewModel.UserLoginState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial), (.loading, .loading), (.success, .success):
                return true
            default:
                return false
            }
        }
        
        case initial
        case loading
        case success
        case fail(error : LoginError)
    }
    
    var loginType : LoginType = .notSelected
    var userLoginUsecase : UserLoginUseCaseProtocol
    
    @Published var loginState : UserLoginState = .initial
    @Published var showSuccessAlert : Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userLoginUseCase : UserLoginUseCaseProtocol)
    {
        self.userLoginUsecase = userLoginUseCase
        
    }
    
    func bind()
    {
        userLoginUsecase.onLoginStateUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.loginState = .fail(error: .error(msg: error.localizedDescription))
                    self?.showSuccessAlert = false
                }
            } receiveValue: { [weak self] loginState in
                guard let usecaseLoginState = loginState else {
                    self?.loginState = .fail(error: .invalidCredential)
                    self?.showSuccessAlert = false
                    return
                }
                
                if usecaseLoginState == .loggedIn
                {
                    self?.loginState = .success
                    self?.showSuccessAlert = true
                }
                else {
                    self?.loginState = .fail(error: .error(msg: "Login Failed!!"))
                    self?.showSuccessAlert = false
                }
            }
            .store(in: &cancellables)
    }
    
    func login(type : LoginType)
    {
        loginState = .loading
        
        userLoginUsecase.login(loginType: type)
    }
}

//
//  LoginHubViewModel.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/8/25.
//

import SwiftUI
import Combine

class LoginHubViewModel: ObservableObject {
    enum UserLoginState {
        case initial
        case loading
        case success
        case fail(error : Error)
    }
    
    var loginType : LoginType = .notSelected
    var userLoginUsecase : UserLoginUseCaseProtocol
    
    @Published var updateUIState : UserLoginState = .initial
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userLoginUseCase : UserLoginUseCaseProtocol)
    {
        self.userLoginUsecase = userLoginUseCase
    }
    
    func onClickLogin(type : LoginType)
    {
        updateUIState = .loading
        
        userLoginUsecase.onUserLoginPublisher
            .sink { [weak self] status in
                switch status {
                case .finished:
                    break
                case .failure(let error):
                    self?.updateUIState = .fail(error: error)
                }
            } receiveValue: { [weak self] user in
                self?.updateUIState = .success
            }
            .store(in: &cancellables)
        
        userLoginUsecase.excute(loginType: type)
    }
}

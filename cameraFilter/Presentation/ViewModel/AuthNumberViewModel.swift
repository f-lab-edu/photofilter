//
//  AuthNumberViewModel.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/19/25.
//

import Foundation
import Combine

class AuthNumberViewModel : ObservableObject {
    enum AuthNumberUIState {
        case initial
        case loading
        case success
        case fail(error: Error)
    }
    
    let authNumberUsecase : AuthNumberUseCaseProtocol
    
    @Published var onUpdateUIState : AuthNumberUIState = .initial
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authNumberUsecase: AuthNumberUseCaseProtocol) {
        self.authNumberUsecase = authNumberUsecase
    }
    
    func bind()
    {
        authNumberUsecase.onResponseAuthenticate
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.onUpdateUIState = .fail(error: error)
                }
            }, receiveValue: { [weak self] user in
                self?.onUpdateUIState = .success
            })
            .store(in: &cancellables)
    }
    
    func phoneAuthenticate(authNumber : String)
    {
        onUpdateUIState = .loading
        authNumberUsecase.requestAuthenticate(authNumber: authNumber)
    }
}

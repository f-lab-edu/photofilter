//
//  AuthNumberUseCase.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/19/25.
//

import Foundation
import Combine

protocol AuthNumberUseCaseProtocol {
    var onResponseAuthenticate : AnyPublisher<User, Error> { get }
    func requestAuthenticate(authNumber : String)
}

final class AuthNumberUseCase : AuthNumberUseCaseProtocol {
    
    let repository : AuthNumberRepositoryProtocol
    
    let authenticateSubject = PassthroughSubject<User,Error>()
    var onResponseAuthenticate : AnyPublisher<User, Error> {
        authenticateSubject.eraseToAnyPublisher()
    }
    
    init(repository : AuthNumberRepositoryProtocol)
    {
        self.repository = repository
    }
    
    func requestAuthenticate(authNumber: String) {
        
        repository.requestAuthenticate(authNumber: authNumber) { [weak self] result in
            switch result {
            case .success(let userDTO):
                let user = userDTO.toEntity()
                self?.authenticateSubject.send(user)
            case .failure(let error):
                self?.authenticateSubject.send(completion: .failure(error))
            }
        }
    }
}

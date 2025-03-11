//
//  PhoneLoginRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/10/25.
//

import Foundation
import Combine

protocol PhoneLoginRepositoryProtocol {
    var onPhoneLoginPublisher : AnyPublisher<String, Error> {get}
    func requestPhoneLogin(phoneNumber : String)
}

class PhoneLoginRepository : PhoneLoginRepositoryProtocol {
    
    private let onPhoneLoginSubject = PassthroughSubject<String, Error>()
    
    var onPhoneLoginPublisher: AnyPublisher<String, Error> {
        onPhoneLoginSubject.eraseToAnyPublisher()
    }
    
    func requestPhoneLogin(phoneNumber: String) {
        
    }
}

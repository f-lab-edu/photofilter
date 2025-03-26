//
//  PhoneLoginViewModel.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/10/25.
//

import Foundation
import SwiftUI

class PhoneLoginViewModel : ObservableObject {
    enum PhoneLoginState {
        case initial
        case loading
        case success
        case fail(error: Error)
    }
    
    @Published var phoneLoginState : PhoneLoginState = .initial
    
    var phoneLoginRepository : PhoneLoginRepositoryProtocol
    
    init(repository : PhoneLoginRepositoryProtocol)
    {
        phoneLoginRepository = repository
    }
    
    func requestPhoneLogin(phoneNumber : String)
    {
        phoneLoginState = .loading
        
        phoneLoginRepository.requestPhoneLogin(phoneNumber: phoneNumber) { [weak self] isAuthorized, error in
            DispatchQueue.main.async {
                if let error = error
                {
                    self?.phoneLoginState = .fail(error: error)
                    return
                }
                
                self?.phoneLoginState = .success
            }
        }
        
    }
    
}

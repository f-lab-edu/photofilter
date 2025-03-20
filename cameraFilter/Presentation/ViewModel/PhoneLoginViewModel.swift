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
    
    @Published var updateUIState : PhoneLoginState = .initial
    
    var phoneLoginRepository : PhoneLoginRepositoryProtocol
    
    init(repository : PhoneLoginRepositoryProtocol)
    {
        phoneLoginRepository = repository
    }
    
    func requestPhoneLogin(phoneNumber : String)
    {
        updateUIState = .loading
        
        phoneLoginRepository.requestPhoneLogin(phoneNumber: phoneNumber) { [weak self] isAuthorized, error in
            if let error = error
            {
                self?.updateUIState = .fail(error: error)
                return
            }
            
            self?.updateUIState = .success
        }
        
    }
    
}

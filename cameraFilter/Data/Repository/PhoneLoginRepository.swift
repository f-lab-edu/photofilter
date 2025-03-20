//
//  PhoneLoginRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/10/25.
//

import Foundation
import Combine
import FirebaseAuth

protocol PhoneLoginRepositoryProtocol {
    func requestPhoneLogin(phoneNumber : String, completion : @escaping (Bool, Error?) -> Void)
}

class PhoneLoginRepository : PhoneLoginRepositoryProtocol {
    
    func requestPhoneLogin(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                // 파이어베이스 인증번호 요청 실패
                completion(false, error)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(true, nil)
        }
    }
}

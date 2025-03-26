//
//  AuthNumberRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/19/25.
//

import Foundation
import FirebaseAuth

protocol AuthNumberRepositoryProtocol {
    func requestAuthenticate(authNumber : String, completion : @escaping (Result<User, Error>) -> Void)
}

final class AuthNumberRepository : AuthNumberRepositoryProtocol {
    
    func requestAuthenticate(authNumber : String, completion : @escaping (Result<User, Error>) -> Void) {
        
        let service = PhoneSignInCredential()
        
        service.signinWithPhone(authNumber: authNumber)
        
        service.getAuthCredential { result in
            switch result {
            case .success(let credential):
                guard let phoneCredential = credential as? PhoneAuthCredential else {
                    return
                }
                
                Auth.auth().signIn(with: phoneCredential) { authResult, error in
                    if let error = error {
                        print("Error google sign in: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }
                    
                    // 로그인에 성공했을 시 실행할 메서드 추가
                    let user = authResult?.user
                    let userDTO = UserDTO(uid: user?.uid ?? "", nickname: user?.displayName ?? UUID().uuidString, idToken: authResult?.credential?.idToken ?? "", loginType: "Phone", pn: user?.phoneNumber ?? "Phone", regDate: Date().toString())
                    
                    completion(.success(userDTO.toEntity()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  UserLoginRepository.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import Foundation
import Combine
import AuthenticationServices
import CryptoKit
import FirebaseCore
import FirebaseAuth

protocol UserLoginRepositoryProtocol {
    func userLogin(loginType : LoginType, completion : @escaping (Result<UserDTO, LoginError>) -> Void)
}

class UserLoginRepository : UserLoginRepositoryProtocol {
    
    var signinService : SignInProtocol?
    
    func userLogin(loginType: LoginType, completion: @escaping (Result<UserDTO, LoginError>) -> Void) {
        if loginType == .apple
        {
            if let appleService = signinService as? AppleSignInCredential
            {
                appleService.signinWithApple()
                
                appleService.getAuthCredential { result in
                    switch result {
                    case .success(let credential):
                        guard let userCredential = credential as? OAuthCredential else {
                            completion(.failure(.invalidCredential))
                            return
                        }
                        
                        Auth.auth().signIn(with: userCredential) { authResult, error in
                            if let error = error {
                                print("Error Apple sign in: \(error.localizedDescription)")
                                return
                            }
                            // 로그인에 성공했을 시 실행할 메서드 추가
                            let user = authResult?.user
                            let userDTO = UserDTO(uid: user?.uid ?? "", nickname: user?.displayName ?? UUID().uuidString, idToken: userCredential.idToken ?? "", loginType: "Apple", pn: user?.phoneNumber ?? "SNS", regDate: Date().toString())
                            completion(.success(userDTO))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            else
            {
                signinService = AppleSignInCredential()
                (signinService as? AppleSignInCredential)?.signinWithApple()
                
                (signinService as? AppleSignInCredential)?.getAuthCredential { result in
                    switch result {
                    case .success(let credential):
                        guard let userCredential = credential as? OAuthCredential else {
                            completion(.failure(.invalidCredential))
                            return
                        }
                        
                        Auth.auth().signIn(with: userCredential) { authResult, error in
                            if let error = error {
                                print("Error Apple sign in: \(error.localizedDescription)")
                                return
                            }
                            // 로그인에 성공했을 시 실행할 메서드 추가
                            let user = authResult?.user
                            let userDTO = UserDTO(uid: user?.uid ?? "", nickname: user?.displayName ?? UUID().uuidString, idToken: userCredential.idToken ?? "", loginType: "Apple", pn: user?.phoneNumber ?? "SNS", regDate: Date().toString())
                            completion(.success(userDTO))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        else if loginType == .google
        {
            if let googleService = signinService as? GoogleSignInCredential
            {
                googleService.signinWithGoogle()
                googleService.getAuthCredential { result in
                    switch result {
                    case .success(let credential):
                        guard let userCredential = credential else {
                            completion(.failure(.invalidCredential))
                            return
                        }
                        
                        Auth.auth().signIn(with: userCredential) { authResult, error in
                            if let error = error {
                                print("Error google sign in: \(error.localizedDescription)")
                                completion(.failure(.error(msg: error.localizedDescription)))
                                return
                            }
                            
                            
                            // 로그인에 성공했을 시 실행할 메서드 추가
                            let user = authResult?.user
                            let userDTO = UserDTO(uid: user?.uid ?? "", nickname: user?.displayName ?? UUID().uuidString, idToken: authResult?.credential?.idToken ?? "", loginType: "Apple", pn: user?.phoneNumber ?? "SNS", regDate: Date().toString())
                            completion(.success(userDTO))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                        
                    }
                }
            }
            else
            {
                signinService = GoogleSignInCredential()
                (signinService as? GoogleSignInCredential)?.signinWithGoogle()
                (signinService as? GoogleSignInCredential)?.getAuthCredential { result in
                    switch result {
                    case .success(let credential):
                        guard let userCredential = credential else {
                            completion(.failure(.invalidCredential))
                            return
                        }
                        
                        Auth.auth().signIn(with: userCredential) { authResult, error in
                            if let error = error {
                                print("Error google sign in: \(error.localizedDescription)")
                                completion(.failure(.error(msg: error.localizedDescription)))
                                return
                            }
                            
                            
                            // 로그인에 성공했을 시 실행할 메서드 추가
                            let user = authResult?.user
                            let userDTO = UserDTO(uid: user?.uid ?? "", nickname: user?.displayName ?? UUID().uuidString, idToken: authResult?.credential?.idToken ?? "", loginType: "Apple", pn: user?.phoneNumber ?? "SNS", regDate: Date().toString())
                            completion(.success(userDTO))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
}

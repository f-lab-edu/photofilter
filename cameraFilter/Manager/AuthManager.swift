//
//  AuthManager.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/11/25.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Combine
import FirebaseAuth

protocol AuthManagerProtocol {
    var onSNSLoginPublisher : AnyPublisher<AuthResult,Error> {get}
    func signinWithApple()
    func signinWithGoogle()
}

class AuthManager : NSObject, AuthManagerProtocol
{
    
    private let snsLoginSubject = PassthroughSubject<AuthResult, Error>()
    
    var onSNSLoginPublisher: AnyPublisher<AuthResult, Error> {
        snsLoginSubject.eraseToAnyPublisher()
    }
    
    private var appleCurrentNonce : String?
    
    override init()
    {
        super.init()
    }
    
    func signinWithGoogle() {
        
    }
    
    //MARK: Apple Login
    func signinWithApple() {
        
        let nonce = randomNonceString()
        appleCurrentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        var randomBytes = [UInt8](repeating: 0, count: length)
        
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
        
    }
    
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
        
    }
}

extension AuthManager : ASAuthorizationControllerDelegate
{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = appleCurrentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Error Apple sign in: \(error.localizedDescription)")
                    self?.snsLoginSubject.send(completion: .failure(error))
                    return
                }
                // 로그인에 성공했을 시 실행할 메서드 추가
                let user = authResult?.user
                let authResult = AuthResult(uid: user?.uid ?? "", idToken: idTokenString, loginType: "Apple", nickname: (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""))
                self?.snsLoginSubject.send(authResult)
            }
        }
    }
}

//MARK: Apple login window present
extension AuthManager : ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
}

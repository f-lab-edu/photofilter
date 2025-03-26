import Combine
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import CryptoKit
import GoogleSignIn

enum LoginError : Error {
    case invalidCredential
    case failTokenVerify
    case serverError
    case error(msg : String)
}

protocol SignInProtocol {
    func getAuthCredential(completion: @escaping (Result<AuthCredential?, LoginError>) -> Void)
    func signIn()
}

//MARK: Apple Sign in
class AppleSignInCredential : NSObject, SignInProtocol {
    
    private var appleCurrentNonce : String?
    
    var completion : ((Result<AuthCredential?, LoginError>) -> Void)?
    
    func getAuthCredential(completion: @escaping (Result<AuthCredential?, LoginError>) -> Void)
    {
        self.completion = completion
    }
    
    func signIn() {
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

extension AppleSignInCredential : ASAuthorizationControllerDelegate
{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = appleCurrentNonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                completion?(.failure(.serverError))
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                completion?(.failure(.failTokenVerify))
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                completion?(.failure(.failTokenVerify))
                return
            }
            
            
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            completion?(.success(credential))
        }
        else {
            completion?(.failure(.invalidCredential))
        }
    }
}

extension AppleSignInCredential : ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
}

//MARK: Google Signin 
class GoogleSignInCredential : SignInProtocol {
    
    var completion : ((Result<AuthCredential?, LoginError>) -> Void)?
    
    func getAuthCredential(completion: @escaping (Result<AuthCredential?, LoginError>) -> Void) {
        self.completion = completion
    }
    
    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController  else {return}
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                // ...
                print("Error google sign in: \(error.localizedDescription)")
                self?.completion?(.failure(.error(msg: error.localizedDescription)))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                self?.completion?(.failure(.failTokenVerify))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            self?.completion?(.success(credential))
            
        }
    }
}

class PhoneSignInCredential : SignInProtocol {
    
    var completion : ((Result<AuthCredential?, LoginError>) -> Void)?
    
    func getAuthCredential(completion: @escaping (Result<FirebaseAuth.AuthCredential?, LoginError>) -> Void) {
        self.completion = completion
    }
    
    func signIn() {
        
    }
    
    func signinWithPhone(authNumber : String)
    {
        guard let verificationId = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion?(.failure(.invalidCredential))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: authNumber)
        completion?(.success(credential))
    }
}

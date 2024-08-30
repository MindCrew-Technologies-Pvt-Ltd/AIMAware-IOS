//
//  AuthenticationViewModel.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 20/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices

@MainActor
class AuthenticationViewModel: NSObject, ObservableObject {
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    var completionHandler: ((Bool, String?, NSDictionary) -> Void)?
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func doLogin(email: String, password: String, completion: @escaping (Bool, String?, NSDictionary) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                let newError = error.localizedDescription
                print(error.localizedDescription)
                Auth.auth().fetchSignInMethods(forEmail: email) { providers, error in
                    if let error = error{
                        completion(false, error.localizedDescription, [:])
                    }else{
                        if providers?[0] == nil || providers?[0] == ""{
                            completion(false, newError, [:])
                        }else{
                            completion(false, providers?[0], [:])
                        }
                    }
                }
            }else{
                guard let userID = authResult?.user.uid else {
                    completion(false, "Unable to get user details", [:])
                    return
                }
                let fullName = authResult?.user.displayName
                let userEmail = authResult?.user.email
                let dict = NSMutableDictionary()
                dict.setValue(fullName, forKey: "fullName")
                dict.setValue(email, forKey: "email")
                USER_DEFAULTS.set(userID, forKey: USERID)
                self.sendVerificationEmailIfNotVerified(user: authResult?.user)
                AnalyticsHelper.logEvent(key: "login", value: email)
                completion(true, nil, dict)
            }
        }
    }
    
    func doCreateUser(email: String, password: String, completion: @escaping (Bool, String?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil{
                //Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error{
                        completion(false, error.localizedDescription)
                    }else{
                        guard let userID = authResult?.user.uid else {
                            completion(false, "Unable to get user details")
                            return
                        }
                        
                        USER_DEFAULTS.set(userID, forKey: USERID)
                        self.sendVerificationEmailIfNotVerified(user: authResult?.user)
                        AnalyticsHelper.logEvent(key: "login", value: email)
                        completion(true, nil)
                    }
               // }
            }else{
                guard let userID = authResult?.user.uid else {
                    completion(false, "Unable to register user details")
                    return
                }
                USER_DEFAULTS.set(userID, forKey: USERID)
                self.sendVerificationEmailIfNotVerified(user: authResult?.user)
                AnalyticsHelper.logEvent(key: "register", value: email)
                completion(true, nil)
            }
        }
    }
    
    
    func doGoogleSignIn(completion: @escaping (Bool, String?, NSDictionary) -> ()){
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let controller = sceneDelegate.window?.rootViewController else{
            completion(false, "Unable to fetch login details from Google", [:])
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false, "Unable to fetch login details from Google", [:])
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { result, error in
            guard error == nil else {
                completion(false, error?.localizedDescription, [:])
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString
                    
            else {
                completion(false, "Unable to fetch login details from Google", [:])
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error{
                    completion(false, error.localizedDescription, [:])
                }else{
                    guard let userID = authResult?.user.uid else {
                        completion(false, "Unable to get user details", [:])
                        return
                    }
                    let fullName = user.profile?.name
                    let email = user.profile?.email
                    let dict = NSMutableDictionary()
                    dict.setValue(fullName, forKey: "fullName")
                    dict.setValue(email, forKey: "email")
                    USER_DEFAULTS.set(userID, forKey: USERID)
                    completion(true, nil, dict)
                }
            }
        }
    }
    
    func doAppleSignIn(completion: @escaping (Bool, String?, NSDictionary) -> ()){
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let controller = sceneDelegate.window?.rootViewController else{
            completion(false, "Unable to fetch login details from Google", [:])
            return
        }
        
        completionHandler = completion
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = controller as? any ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    private func sendVerificationEmailIfNotVerified(user: User?){
        if user?.isEmailVerified == false{
            user?.sendEmailVerification(completion: { (error) in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                } else {
                    print("Verification email sent.")
                }
            })
        }
    }
    
    func sendPasswordResetEmail(email: String, completion: @escaping (Bool, String?) -> ()){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, "Error sending password reset email: \(error.localizedDescription)")
            } else {
                completion(true, "Password reset email sent.")
            }
        }
    }
}

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
              //            fatalError("Invalid state: A login callback was received, but no login request was sent.")
              completionHandler!(false, "Invalid state: A login callback was received, but no login request was sent.", [:])
              return
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
              //            print("Unable to fetch identity token")
              completionHandler!(false, "Unable to fetch identity token", [:])
              return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              completionHandler!(false, "Unable to serialize token string from data: \(appleIDToken.debugDescription)", [:])
            return
          }
            
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                self.completionHandler!(false, error.localizedDescription, [:])
              return
            }else{
                guard let userID = authResult?.user.uid else {
                    self.completionHandler!(false, "Unable to get user details", [:])
                    return
                }
                let fullName = authResult?.user.displayName
                let email = authResult?.user.email
                let dict = NSMutableDictionary()
                dict.setValue(fullName, forKey: "fullName")
                dict.setValue(email, forKey: "email")
                USER_DEFAULTS.set(userID, forKey: USERID)
                //self.completionHandler!(false, nil, dict)
                self.completionHandler!(true, nil, dict)
            }
          }
        }
      }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
//        print("Sign in with Apple errored: \(error)")
          completionHandler!(false, error.localizedDescription, [:])
      }

    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
//        fatalError(
//          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
//        )
          completionHandler!(false, "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)", [:])
          return ""
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

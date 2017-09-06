//
//  SignInVC.swift
//  iOS-Social
//
//  Created by akshay Grover on 2017-07-06.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: customField!
    @IBOutlet weak var pwdField: customField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
   
    
    @IBAction func facebookBtnClicked(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("login error: unable to auth with facebok ")
            }else if result?.isCancelled == true{
                print("user cancelled FB authentication")
            }else{
                print("FB auth sucessful")
                let credentials =  FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials)
                
            }
        }
        
    }
    func firebaseAuth(_ credential: AuthCredential){
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print("unable to auth with firebase")
            }else{
                print("firebase auth sucessful")
                if let user = user  {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInBtnClicked(_ sender: UIButton) {
        
        if let email = emailField.text , let pwd = pwdField.text{
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil{
                    print("user auth with firebae")
                    if let user = user{
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("unable to auth with firebase")
                        }else{
                            print("successfully auth with firebase")
                            if let user = user{
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData )
        
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain - \(keyChainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}


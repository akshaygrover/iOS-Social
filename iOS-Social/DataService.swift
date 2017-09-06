//
//  DataService.swift
//  iOS-Social
//
//  Created by akshay Grover on 2017-07-07.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import Foundation
import Firebase
import  SwiftKeychainWrapper

let DATABASE =  Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()
class  DataService{
    
    static let ds = DataService()
    // DB references
    private var _REF_BASE = DATABASE
    private var _REF_POSTS = DATABASE.child("posts")
    private var _REF_USERS = DATABASE.child("users")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    var REF_POSTS: DatabaseReference{
        return _REF_POSTS
    }
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    var REF_USER_CURRENT: DatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user =  REF_USERS.child(uid!)
        return user
        
    }
    var REF_POST_IMAGES: StorageReference{
        return _REF_POST_IMAGES
    }
   
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}

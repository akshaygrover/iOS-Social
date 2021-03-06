//
//  Post.swift
//  iOS-Social
//
//  Created by akshay Grover on 2017-07-08.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postkey: String!
    private var _postRef: DatabaseReference!
    
    var caption: String{
        return _caption
    }
    var imageUrl: String{
        return _imageUrl
    }
    var likes: Int{
        return _likes
    }
    var postKey: String{
        return _postkey
    }
    
    init(caption: String, imageUrl: String, likes: Int){
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        
    }
    init(postkey: String, postData: Dictionary<String, AnyObject>) {
        self._postkey = postkey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
            
        }
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        _postRef = DataService.ds.REF_POSTS.child(_postkey)
        
        
    }
    
    func adjustLikes(addLike: Bool){
        if addLike{
            _likes = _likes+1
            
        }else{
            _likes = likes-1
        }
        _postRef.child("likes").setValue(_likes)
        
    }
    
    
}

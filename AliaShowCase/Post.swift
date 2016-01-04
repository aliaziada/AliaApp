//
//  Post.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/4/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imgUrl: String?
    private var _likes: Int!
    private var _postKey: String!
    private var _username: String!
    
    var postDescription : String {
        return _postDescription
    }
    var imgUrl : String? {
        return _imgUrl
    }
    var likes : Int {
        return _likes
    }
    var username : String {
        return _username
    }
    var postKey : String {
        return _postKey
    }
    init(descption: String,imgUrl: String?,username: String){
        _postDescription = descption
        _imgUrl = imgUrl
        _username = username
    }
    
    init(postKey: String,dictionary: Dictionary <String,AnyObject>){
        _postKey = postKey
        if let likes = dictionary["likes"] as? Int {
            _likes = likes
        }
        if let desc = dictionary["description"] as? String {
            _postDescription = desc
        }
        
        if let imgUrl = dictionary["imgUrl"] as? String {
            _imgUrl = imgUrl
        }
    }
}

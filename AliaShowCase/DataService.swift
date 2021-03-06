//
//  DataService.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/4/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import Foundation
import Firebase
let URL_BASE = "https://aliashowcase.firebaseio.com"
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    var REF_CURRENT_USER :Firebase {
        let uid = NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) as? String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    func createFirebaseUser(uid: String,user: Dictionary <String,String>){
        _REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}
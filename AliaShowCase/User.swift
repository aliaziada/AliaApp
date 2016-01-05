//
//  User.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/5/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import Foundation

class User {
    private var _username: String!
    private var _uid: String!
    private var _profileImgUrl: String!
    
    var username : String {
        return _username
    }
    var uid : String? {
        return _uid
    }
    var profileImgUrl : String {
        return _profileImgUrl
    }
}

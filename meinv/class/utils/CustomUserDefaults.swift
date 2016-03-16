//
//  CustomUserDefaults.swift
//  meinv
//
//  Created by tropsci on 16/3/16.
//  Copyright © 2016年 topsci. All rights reserved.
//

import Foundation
import UIKit

extension NSUserDefaults {
    
    @nonobjc static let kUserUUIDKey:String = "com.liu.user.uuid"
    @nonobjc static let kUserNicknameKey: String = "com.liu.user.nickname"
    @nonobjc static let kUsernameKey: String = "com.liu.user.name"
    
    var userUUID: String? {
        
        set {
            self.setObject(newValue, forKey:NSUserDefaults.kUserUUIDKey)
            self.synchronize()
        }
        
        get {
            return self.stringForKey(NSUserDefaults.kUserUUIDKey)
        }
    }
    
    var username: String? {
        
        set {
            self.setObject(newValue, forKey:NSUserDefaults.kUsernameKey)
            self.synchronize()
        }
        
        get {
            return self.stringForKey(NSUserDefaults.kUsernameKey)
        }
    }

    
    var userNickname: String? {
        set {
            self.setObject(newValue, forKey:NSUserDefaults.kUserNicknameKey)
            self.synchronize()
        }
        get {
            return self.stringForKey(NSUserDefaults.kUserNicknameKey)
        }
    }
}
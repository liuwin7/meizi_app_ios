//
//  UIViewFrameExtension.swift
//  meinv
//
//  Created by tropsci on 16/3/15.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit

extension UIView {
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }

        set {
            self.frame = CGRectMake(newValue, self.frame.origin.y, self.frame.width, self.frame.height)
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.width + self.frame.origin.x
        }
        
        set {
            frame = CGRectMake(newValue - frame.width, frame.origin.y, self.frame.width, self.frame.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
    }
}
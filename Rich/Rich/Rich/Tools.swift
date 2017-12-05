//
//  Tools.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/5.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    public init(top:CGFloat = 0,bottom:CGFloat = 0,left:CGFloat = 0,right:CGFloat = 0) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(horizontal:CGFloat){
        top = 0
        left = horizontal
        bottom = 0
        right = horizontal
    }
    
    public init(vertical:CGFloat){
        top = vertical
        left = 0
        bottom = vertical
        right = 0
    }
    
    
}

//extension UIEdgeInsets:ExpressibleByFloatLiteral {
//
//    public init(floatLiteral value: Float) {
//        top = CGFloat(value)
//        left = CGFloat(value)
//        bottom = CGFloat(value)
//        right = CGFloat(value)
//    }
//}



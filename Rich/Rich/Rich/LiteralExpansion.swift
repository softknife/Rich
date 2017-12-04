//
//  Protocol2.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit


public class Operation: ExpressibleByStringLiteral{
    
    public enum Value{
        case text(String)
        case image(UIImage)
    }

    public typealias Action = ()->()
    
    let value:Value
    var textColor : UIColor = .gray
    var backgroundColor:UIColor = .clear
    var action : Action? = nil
    
    public init(value:Value,textColor:UIColor = .gray,backgroundColor:UIColor = .clear , action:Action? = nil) {
        self.value = value
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    
    public required init(stringLiteral value: String) {
        self.value = .text(value)
    }

}



public struct Description:ExpressibleByStringLiteral{
    
    let value:String
    var textColor : UIColor = .gray
    var backgroundColor:UIColor = .clear

    public init(value:String,textColor:UIColor = .gray , backgroundColor:UIColor = .clear){
        self.value = value
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
}

public struct Image {
 
    let value:UIImage?
    var backgroundColor:UIColor = .clear
    var contentMode:UIViewContentMode = .scaleAspectFit
    
    public init(_ value:UIImage,backgroundColor:UIColor = .clear,contentMode:UIViewContentMode = .scaleAspectFit){
        self.value = value
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
    }
    
    public init(named:String,backgroundColor:UIColor = .clear,contentMode:UIViewContentMode = .scaleAspectFit){
        self.value = UIImage(named: named)
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
    }

}


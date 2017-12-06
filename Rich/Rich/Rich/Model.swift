//
//  Protocol2.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

public protocol AdditionalConfiguration:class {
    
    @discardableResult
    func plus(_ additional: (Self)->()) ->Self
}
public extension AdditionalConfiguration{
    
    @discardableResult
    func plus(_ additional: (Self)->()) ->Self{
        additional(self)
        return self
    }

}

final public class Operation: ExpressibleByStringLiteral,AdditionalConfiguration,AutoTriggerHideActiveView{
    
    
    public enum Value{
        case text(String)
        case image(UIImage)
    }

    
    var value:Value
    var textColor : UIColor = .gray
    var font : UIFont = .systemFont(ofSize: 16)
    var backgroundColor:UIColor = .clear
    var action : Action? = nil
    var cornerRadius : CGFloat = 0
    
    var triggerHideView:Bool = false

    
    public init(value:Value,textColor:UIColor = .gray,font:UIFont = .systemFont(ofSize: 16),backgroundColor:UIColor = .clear , action:Action? = nil,cornerRadius:CGFloat = 0) {
        self.value = value
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.action = action
        self.cornerRadius = cornerRadius
        
    }
    
    
    public required init(stringLiteral value: String) {
        self.value = .text(value)
    }
    
}

extension Operation{
    public func defaultHide(_ block:Action?) ->Self {
        
        
        
        return self
    }
}


final public class MarginOperation:ExpressibleByStringLiteral,AdditionalConfiguration {
    
    var operation : Operation = ""
    var margin : UIEdgeInsets = UIEdgeInsets(top:10)
    
    init() { }
    
    public init(stringLiteral value: String) {
        operation = Operation(stringLiteral: value)
        operation.backgroundColor = UIColor(white:1.0,alpha:0.7)
    }
    
}





final public class Description:ExpressibleByStringLiteral,AdditionalConfiguration{
    
    let value:String
    var textColor : UIColor = .gray
    var font : UIFont = .systemFont(ofSize: 17)
    var backgroundColor:UIColor = .clear
    var numberOfLines : Int = 1
    var cornerRadius : CGFloat = 0

    public init(value:String,textColor:UIColor = .gray ,font:UIFont = .systemFont(ofSize: 17), backgroundColor:UIColor = .clear,numberOfLines:Int = 1){
        self.value = value
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
    
    public required init(stringLiteral value: String) {
        self.value = value
    }
}

final public class Image:AdditionalConfiguration {
 
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


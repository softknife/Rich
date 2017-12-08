//
//  Protocol2.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit



final public class Operation: ExpressibleByStringLiteral,AdditionalConfiguration,AutoTriggerHideActiveView{
    
    
    public enum Value{
        case text(String)
        case image(UIImage)
    }

    public enum Style{
        case normal
        case danger
    }
    
    var style : Style = .normal
    var value:Value
    var textColor : UIColor = .gray
    var font : UIFont = .systemFont(ofSize: 16)
    var backgroundColor:UIColor = .clear
    var action : Action? = nil
    var cornerRadius : CGFloat = 0
    
    var triggerHide:Bool = false

    
    public init(value:Value,
                textColor:UIColor = .gray,
                font:UIFont = .systemFont(ofSize: 16),
                backgroundColor:UIColor = .clear ,
                cornerRadius:CGFloat = 0,
                style:Style = .normal,
                action:Action? = nil)
    {
        
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
    var numberOfLines : Int = 0
    var cornerRadius : CGFloat = 0
    var margin : UIEdgeInsets = .zero

    public init(value:String,
                textColor:UIColor = .gray ,
                font:UIFont = .systemFont(ofSize: 17),
                backgroundColor:UIColor = .clear,
                numberOfLines:Int = 1,
                margin : UIEdgeInsets = .zero)
    {
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
    var margin : UIEdgeInsets = .zero

    public init(_ value:UIImage,
                backgroundColor:UIColor = .clear,
                contentMode:UIViewContentMode = .scaleAspectFit,
                margin : UIEdgeInsets = .zero)
    {
        self.value = value
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
    }
    
    public init(named:String,
                backgroundColor:UIColor = .clear,
                contentMode:UIViewContentMode = .scaleAspectFit,
                margin : UIEdgeInsets = .zero)
    {
        self.value = UIImage(named: named)
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
    }

}


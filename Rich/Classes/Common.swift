//
//  Enum.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
// import YogaKit

extension UIColor {
    
    enum Color {
        case transparentGray
        
        func value() -> (CGFloat,CGFloat,CGFloat,CGFloat) {
            switch self {
            case .transparentGray:
                return ( 240/250, 240/250, 240/250,  0.7)
                
            }
        }
    }
    

    convenience init(type:Color) {
        
        let value = type.value()
        self.init(red: value.0, green: value.1, blue: value.2, alpha: value.3)
    }
    
}


////////////////////////////////////////////////////////////////////////////////
// ENUM
////////////////////////////////////////////////////////////////////////////////
public enum Animation {
    case none
    case fadedIn
    case ufo
}


public enum RichType:Int,Equatable{
    case hud  = 0
    case alert = 1
    case sheet = 2
    
//    public static func makeLevelPrinciple(_ principle:()->()){
//    
//    }
    public static func ==(lhs:RichType,rhs:RichType) ->Bool{
        return lhs.rawValue == rhs.rawValue
    }
}



public enum State:Equatable{
    
    public enum AwakeStyle:Int{
        case first = 0
        case turn2 = 1
    
    }
    
    case initial
    case sleep
    case awake(time:AwakeStyle)
//    case refresh(Background)
    case dying(finished:((Bool)->())?)
    
    private func value()->String{
        switch self {
        case .initial:return "initial"
        case .sleep: return "sleep"
        case .awake(let time): return "awake\(time.rawValue)"
//        case .refresh:return "refresh"
        case .dying: return "dying"
        }
    }
    
    public static func ==(lhs: State, rhs: State) -> Bool{
        return lhs.value() == rhs.value()
    }
}



////////////////////////////////////////////////////////////////////////////////
// TypeAlias
////////////////////////////////////////////////////////////////////////////////
//public typealias Action = ()->()

public typealias ConvenienceYGLayoutBlock = @convention(block) (YGLayout)->()

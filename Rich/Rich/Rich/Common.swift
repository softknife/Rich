//
//  Enum.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


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
public typealias Action = ()->()


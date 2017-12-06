//
//  CommonRestrict.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit


///////////////////////////////////////////////////////////////////////////////////////////
// HUD,AlertView & ActionSheet Configuration Protocol
///////////////////////////////////////////////////////////////////////////////////////////
typealias Skeleton = CommonConfigure & DistinguishAction & CommonAction



protocol BaseConfigure:class  {
    
    weak var containerView : UIView? {get set}
    var background:Background {get set}
    var animation:Animation {get set}
    var type : RichType{get set}
    var state:State {get set}

}



protocol ContentBindable {
    associatedtype ContentType
    var type : ContentType{get set}
    
}

protocol CommonConfigure:BaseConfigure{
    

    associatedtype Content where Content: ContentBindable
    var content:Content{get set}
    
    init(content:Content, container:UIView,yoga:YGLayoutConfigurationBlock?,animation:Animation)
    
}


protocol DistinguishAction {
    
    
    func configBody()
    func refreshBody()
    
    func goToSleep()
    func turnToShow(time:State.Repeat)
    func turnToHide(finished:((Bool)->())?)
}

extension DistinguishAction where Self:CommonConfigure{
    
    func goToSleep(){
        background.removeFromSuperview()
    }
    
    func refreshBody(){}
}


protocol CommonAction {
    func prepare()
    func changeAccordingState()
    func hide(showNext:Bool)
}

extension CommonAction where Self:CommonConfigure & DistinguishAction{
    
    func changeAccordingState()  {
        
        switch state {
        case .initial: break
        case .sleep: goToSleep()
        case .awake(let time):
            
            if time == .first{
                configBody()
            }
            turnToShow(time: time)
            
        case .refresh: refreshBody()
        case .dying(let finished):
            turnToHide(finished:finished)
            Rich.remove(self)

        }
    }
    
    
    
    func prepare(){

        let nodes = Rich.getNodes()
        if nodes.isEmpty {
            Rich.add(self)
            state = .awake(time: .first)
            return
        }
        
        
        let specificNodes = Rich.getNodes(type: type)
        if specificNodes.isEmpty {
            
            switch type {
            case .alert,.sheet:

                nodes.forEach{$0.state = .sleep}
                
                state = .awake(time: .first)
                Rich.add(self)

            case .hud:
                Rich.add(self)
            }
            
            return
            
            
        }

        
        switch type {
        case .hud:
            
            let oldNode = specificNodes.first!
            oldNode.background = background
            oldNode.state = .refresh
            
        case .alert,.sheet:
            
            Rich.add(self)
            configBody()

        }
        
        
    }
    
    
    func hide(showNext:Bool) {
        
        guard let next = Rich.nextWillShow(from: self) else {
            state = .dying(finished:nil)
            return
        }
        
        state = .dying(finished: { (_) in
            
            switch next.state {
            case .initial:
                next.state = .awake(time: .first)
            case .sleep:
                next.state = .awake(time: .again)
            default:
                break
            }

        })


    }
  
}

//////////////////////////////////////////////////////////////////////////////////////////
// Body Configuration protocol
//////////////////////////////////////////////////////////////////////////////////////////
protocol BodyConfigure  {
    
    associatedtype T : CommonConfigure
    
    var content : T.Content {get set}
    
}

////////////////////////////////////////////////////////////////////////////////////////////
//// Background Configuration protocol
////////////////////////////////////////////////////////////////////////////////////////////
//protocol BackgroundConfigure {
//    associatedtype T : UIView where Self:BodyConfigure
//    var contentView : T? {get set}
//    
//}


//////////////////////////////////////////////////////////////////////////////////////////
// Expose to Users directly
//////////////////////////////////////////////////////////////////////////////////////////


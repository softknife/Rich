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


/// Internal Protocol
typealias Skeleton = CommonConfigure & DistinguishAction & CommonAction



/// Base Configuration
protocol BaseConfigure: OpenConfigure  {
    
    weak var containerView : UIView? {get set}
    var animation:Animation {get set}
    var richType : RichType{get set}
    var state:State {get set}

}


/// AssociatedType1
protocol ContentBindable {
    associatedtype ContentType
    var type : ContentType{get set}
    
}


/// AssociatedType2
protocol CommonConfigure:BaseConfigure{
    

    associatedtype Content where Content: ContentBindable
    var content:Content{get set}
    
    init(content:Content, container:UIView,yoga:YGLayoutConfigurationBlock?,animation:Animation)
    
}


protocol DistinguishAction {
    
    
    /// Configure Yoga Layout and other necessary configuration
    ///
    func configBody()
    
    
    /// This method is specially for HUD
    ///
    /// - Parameter : newBackground
    func refreshBody(_ newBackground:Background)
    
    
    /// We hidden current view temporarily  when other high level type view show
    ///
    func goToSleep()
    
    
    /// Show current view to user
    ///
    /// - Parameter time: first show or not
    func turnToShow(time:State.AwakeStyle)
    
    
    /// Make current view remove from superView
    ///
    /// - Parameter finished: finish callback
    func turnToHide(finished:((Bool)->())?)
}

extension DistinguishAction where Self:CommonConfigure{
    
    
    func goToSleep(){
        background.removeFromSuperview()
    }
    
    
    func refreshBody(_ newBackground:Background){}
}


protocol CommonAction {
    
    
    /// Prepare some basic configuration for the node  ,such as hold current node , before really show its view
    func prepare()
    
    
    /// To Adjust View'layout according to state
    func changeViewLayoutAccordingState()
    
    
    /// Hidden current view , and then , decide to show next view or not
    ///
    /// - Parameter showNext: show next view or not
    func hide(showNext:Bool)
    

    /// If operation'action property is nil, we give it default action to hidden current view
    ///
    /// - Parameter ops: Operation Array
    func setDefaultHideViewAction(_ ops:[Operation])
    
}

extension CommonAction where Self:CommonConfigure & DistinguishAction{
    
    
    
    func prepare(){

        let nodes = Rich.getNodes()
        if nodes.isEmpty {
            Rich.add(self)
            state = .awake(time: .first)
            return
        }
        
        
        let specificNodes = Rich.getNodes(type: richType)
        if specificNodes.isEmpty {
            
            switch richType {
            case .alert,.sheet:

                nodes.forEach{$0.state = .sleep}
                state = .awake(time: .first)
                Rich.add(self)

            case .hud:
                Rich.add(self)
            }
            
            return
        }

        
        switch richType {
        case .hud:
            
            let oldNode = specificNodes.first!
            oldNode.state = .refresh(background)
            
        case .alert,.sheet:
            
            Rich.activeNode()?.state = .sleep
            Rich.add(self)
            state = .awake(time: .first)

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
                next.state = .awake(time: .turn2)
            default:
                break
            }

        })


    }

    func changeViewLayoutAccordingState()  {
        
        switch state {
        case .initial: break
        case .sleep: goToSleep()
        case .awake(let time):
            
            if time == .first{
                configBody()
            }
            turnToShow(time: time)
            
        case .refresh(let newBackground): refreshBody(newBackground)
        case .dying(let finished):
            turnToHide(finished:finished)
            Rich.remove(self)
            
        }
    }
    
    func setDefaultHideViewAction(_ ops:[Operation]){
        for op in ops {
            if op.action == nil && op.triggerHide{
                op.action =  {  [weak self] in
                    guard let weakSelf = self else {return}
                    weakSelf.hide(showNext: true)
                }
            }
        }

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
//// ActionDefaultTriggerHideView  protocol
//////////////////////////////////////////////////////////////////////////////////////////
protocol AutoTriggerHideActiveView:class{
    
    
    /// Decide to hide active view or not when associated action is triggered
    var triggerHide:Bool {get set}
    @discardableResult
    func triggerHide(_ hide:Bool) -> Self
}

extension AutoTriggerHideActiveView{
    
    @discardableResult
    func triggerHide(_ hide:Bool) -> Self{
        triggerHide = hide
        return self
    }
}



//////////////////////////////////////////////////////////////////////////////////////////
// Expose to Users directly
//////////////////////////////////////////////////////////////////////////////////////////
/// Public Protocol
public protocol OpenConfigure:class{
    var background:Background {get set}
    
}






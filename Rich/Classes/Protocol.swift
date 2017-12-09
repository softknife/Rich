//
//  CommonRestrict.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
// import YogaKit


///////////////////////////////////////////////////////////////////////////////////////////
// HUD,AlertView & ActionSheet Configuration Protocol
///////////////////////////////////////////////////////////////////////////////////////////


/// Internal Protocol
typealias Skeleton = CommonConfigure & DistinguishAction & CommonAction



/// Base Configuration
protocol BaseConfigure: OpenConfigure  {
    
    weak var containerView : UIView? {get set}
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
    
    init(content:Content, container:UIView)
    
    @discardableResult
    func diffChange(from node:Self) -> Self
    
    
}

extension CommonConfigure {
    @discardableResult
    func diffChange(from node:Self) -> Self{return self}

}


protocol DistinguishAction {
    
    
    /// Configure Yoga Layout and other necessary configuration
    ///
    func configBody()
    
    
    
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

extension DistinguishAction where Self:BaseConfigure{
    
    
    func goToSleep(){
        background.removeFromSuperview()
    }
    
    
    
  
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

//        objc_sync_enter(Rich.shared)
        
        Rich.shared.queue.sync {
            
            let nodes = Rich.getNodes()
            if nodes.isEmpty {
                Rich.add(self)
                state = .awake(time: .first)
                return
            }
            
            
            let specificNodes = Rich.getNodes(type: richType)
            if specificNodes.isEmpty {
                
                nodes.forEach{$0.state = .sleep}
                Rich.add(self)
                state = .awake(time: .first)
                
                //            switch richType {
                //            case .alert,.sheet:
                //
                //                nodes.forEach{$0.state = .sleep}
                //                state = .awake(time: .first)
                //                Rich.add(self)
                //
                //            case .hud:
                //                Rich.add(self)
                //            }
                
                return
            }
            
            
            switch richType {
            case .hud:
                
                let oldNode = specificNodes.first!
                (oldNode as! HUD).diffChange(from: self as! HUD)
                
                switch oldNode.state{
                case .awake(_): break
                case .sleep:
                    Rich.activeNode()?.state = .sleep
                    oldNode.state = .awake(time: .turn2)
                default: break
                }
                
            case .alert,.sheet:
                
                Rich.activeNode()?.state = .sleep
                Rich.add(self)
                state = .awake(time: .first)
                
            }

        }
        
//        objc_sync_exit(Rich.shared)

        
    }
    
    
    func hide(showNext:Bool) {
        
        Rich.shared.queue.sync {
            
            guard case State.awake(_) = state else {
                return
            }
            
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
    
    var contentView:UIView{get}
    
    func prepareRender(_ layout:@escaping ConvenienceYGLayoutBlock)
    
}

extension BodyConfigure where Self:UIView {
    func prepareRender(_ layout:@escaping ConvenienceYGLayoutBlock){
        configureLayout { (yoga) in
            layout(yoga)
        }
    }
    
    var contentView : UIView {return self}


}

protocol BodyVisualEffectConfigure :BodyConfigure{
    
    var blurView : VisualEffectView{get set}
    

}

extension BodyVisualEffectConfigure where Self:UIView {
    var contentView : UIView {return blurView.content}
    
    func prepareRender(_ layout:@escaping ConvenienceYGLayoutBlock)  {
        
        var reference : YGLayout!
        configureLayout { (yoga) in
            layout(yoga)
            reference = yoga
        }
        
        blurView.configureLayout { (yoga) in
            yoga.isEnabled = true
            yoga.justifyContent = .center
            yoga.alignItems = .stretch
        }
        
        blurView.subviews.forEach { (subView) in
            subView.configureLayout { (yoga) in
                yoga.isEnabled = true
                yoga.justifyContent = .center
                yoga.alignItems = .stretch
            }
        }
        
        contentView.configureLayout { (yoga) in
            yoga.isEnabled = true
            yoga.justifyContent = reference.justifyContent
            yoga.alignItems = reference.alignItems
        }
    }

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
//// YGLayout Default Configuration  protocol
//////////////////////////////////////////////////////////////////////////////////////////
protocol YGLayoutDefaultConfiguration {
    
    func configViewMargin(_ margin:UIEdgeInsets , layout:YGLayout)

}
extension YGLayoutDefaultConfiguration{
    
    func configViewMargin(_ margin:UIEdgeInsets , layout:YGLayout){
        
        if margin.top > 0 { layout.marginTop = YGValue(margin.top)}
        if margin.left > 0 { layout.marginLeft = YGValue(margin.left)}
        if margin.bottom > 0 { layout.marginBottom = YGValue(margin.bottom)}
        if margin.right > 0 { layout.marginRight = YGValue(margin.right)}
        
    }

}

//////////////////////////////////////////////////////////////////////////////////////////
//// ActionDefaultTriggerHideView  protocol
//////////////////////////////////////////////////////////////////////////////////////////
public protocol AutoTriggerHideActiveView:class{
    
    
    /// Decide to hide active view or not when associated action is triggered
    var triggerHide:Bool {get set}
    @discardableResult
    func triggerHideView() -> Self
}

public extension AutoTriggerHideActiveView{
    
    @discardableResult
    func triggerHideView() -> Self{
        triggerHide = true
        return self
    }
}



//////////////////////////////////////////////////////////////////////////////////////////
// Expose to Users directly
//////////////////////////////////////////////////////////////////////////////////////////
/// Public Protocol
public protocol OpenConfigure:class{
    var background:Background {get set}
    var animation:Animation {get set}
    
}



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



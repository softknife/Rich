//
//  CommonRestrict.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

typealias Skeleton = CommonConfigure & DistinguishAction & CommonAction

protocol BaseConfigure:class  {
    
    var type : RichType{get set}
    var state:State {get set}
    weak var containerView : UIView? {get set}
    var background:Background {get set}
    var animation:Animation {get set}

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
    func turnToHide()
}

extension DistinguishAction where Self:CommonConfigure{
    
    func goToSleep(){
        background.removeFromSuperview()
    }
}


protocol CommonAction {
    func prepare()
    func changeAccordingState()
    func hide(showNext:Bool)
}

extension CommonAction where Self:BaseConfigure & DistinguishAction{
    
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
        case .dying:
            Rich.shared.remove(self)
            turnToHide()
        }
    }
    
    
    
    func prepare(){

        let nodes = Rich.shared.nodes
        if nodes.isEmpty {
            Rich.shared.nodes.append(self)
            state = .awake(time: .first)
            return
        }
        
        
        let specificNodes = Rich.shared.nodes(type: type)
        if specificNodes.isEmpty {
            
            switch type {
            case .alert,.sheet:

                nodes.forEach{$0.state = .sleep}
                
                state = .awake(time: .first)
                Rich.shared.nodes.append(self)

            case .hud:
                Rich.shared.nodes.append(self)
            }
            
            return
            
            
        }

        
        switch type {
        case .hud:
            
            let oldNode = specificNodes.first!
            oldNode.background = background
            oldNode.state = .refresh
            
        case .alert,.sheet:
            
            Rich.shared.nodes.append(self)
            configBody()

        }
        
        
    }
    
    
    func hide(showNext:Bool) {
        
        if let next = Rich.shared.nextWillShow(from: self) {
            switch next.state {
            case .initial:
                next.state = .awake(time: .first)
            case .sleep:
                next.state = .awake(time: .again)
            default:
                break
            }
        }
        
        state = .dying

    }
  
}


protocol ContentBindable {
    associatedtype ContentType
    var type : ContentType{get set}
    
}




//////////////////////////////////////////////////////////////////////////////////////////
// Expose to Users directly
//////////////////////////////////////////////////////////////////////////////////////////
protocol ExternalAction{
    
    func hide()
    static func hide()

}

extension ExternalAction where Self:Skeleton{
    
    func hide() {
        hide(showNext: true)
    }
    
    static func hide(){
        
        let activeNode = Rich.shared.activeNode()
        activeNode?.hide(showNext: true)
        
    }

    
}

extension ExternalAction where Self:HUD{
    
    @discardableResult
    static func show(_ content:HUD.Content, inView container:UIView ,yoga:YGLayoutConfigurationBlock?,animation:Animation)->HUD{
        
        let hud =  HUD(content:content,container:container,yoga:yoga,animation:animation)
        hud.prepare()
        
        return hud
    }
}

extension ExternalAction where Self:Alert {
    
    @discardableResult
    static func show(_ content:Alert.Content, inView container:UIView ,yoga:YGLayoutConfigurationBlock?,animation:Animation)->Alert{
        let alert =  Alert(content:content,container:container,yoga:yoga,animation:animation)
        alert.prepare()
        return alert
    }

}

extension ExternalAction where Self:Sheet {
    
    @discardableResult
    static func show(_ content:Sheet.Content, inView container:UIView ,yoga:YGLayoutConfigurationBlock?,animation:Animation)->Sheet{
        let sheet =  Sheet(content:content,container:container,yoga:yoga,animation:animation)
        sheet.prepare()
        return sheet
    }
    
}



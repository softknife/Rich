//
//  HUD.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

public final class HUD:Skeleton{
    
    var richType : RichType = .hud
    var state:State = .initial{
        didSet{
            changeViewLayoutAccordingState()
        }
    }
    weak var containerView:UIView?
    public var background : Background
    public var animation:Animation = .fadedIn
    
    var content:Content
    
    
    required public init(content:Content, container:UIView){
        
        self.content = content.defaultConfiguration()
        self.containerView = container
        
        self.background = Background(color: .clear, layout: .default(container))
        
    }
    
}




// MARK:- DistinguishAction
extension HUD{
    
    
    
    func configBody(){
        let body = HUDBody(content:content)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 150
//            layout.aspectRatio = 1
            layout.justifyContent = .center
            layout.alignItems = .center
        }

        body.backgroundColor = .orange
        
        background.addSubview(body)
        
        background.body = body

    }

    
    func turnToShow(time:State.AwakeStyle){
        
        containerView?.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
        
        if case State.AwakeStyle.first = time{
            background.alpha = 0
            UIView.animate(withDuration: 1) {
                self.background.alpha = 1
            }
        }

    }
    
    
    func turnToHide(finished:((Bool)->())?){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
        }) { (finish) in
            self.background.removeFromSuperview()
            finished?(finish)
        }
        
    }
    
    @discardableResult
    func diffChange(from node:HUD) ->HUD {
        
        let isAwake = background.superview != nil ? true : false
        background.removeFromSuperview()
        background = node.background
        content = node.content
        configBody()
        
        
        if isAwake{
            state = .awake(time: .turn2)
        }
        
        return self
        
    }
    
    
}

// MARK:- ContentType
extension HUD {
 
    public struct Content:ContentBindable {
        var type: ContentType
        
        public static var delay : Content {return Content(type: .delay)}
        
        public static var systemActivity:Content{
            return Content(type: .systemActivity)
        }
        
        public static func success(description:Description? = nil)->Content{
            return Content(type: .success(description: description))
        }
        
        public static func failure(description:Description? = nil )->Content{
            return Content(type: .failure(description: description))
        }
        
        public static func titleThenImage(title:Description? = nil , image:Image? = nil )->Content{
            return Content(type: .titleThenImage(title: title, image: image))
        }
        
        public static func imageThenName(image:Image? = nil ,name:Description? = nil )->Content{
            return Content(type: .imageThenName(image: image, name: name))
        }
        
        public static func progress(_ type:ProgressType)->Content{
            return Content(type: .progress(type))
        }
    }

    
    public enum ProgressType{
        case `default`(Progress)
        case textInCircle(Progress)
        case pie(Progress)
    }
    
    
    internal enum ContentType  {
        
        case delay
        case systemActivity
        case success(description:Description?)
        case failure(description:Description?)
        
        case titleThenImage(title:Description?,image:Image?)
        case imageThenName(image:Image?,name:Description?)
        
        case progress(ProgressType)
    }
}

extension HUD.Content {
    
    @discardableResult
    func defaultConfiguration() ->HUD.Content {
        switch type {
        case .systemActivity:break
        case .success(let description): break
        case .failure(let description): break
        case let  .titleThenImage(title, image): break
        case let .imageThenName(image, name): break
        case .progress(let progress): break
        case .delay: break

         
        }
        return self
    }
}



/////////////////////////////////////////////////////////////////////////////////////
// Public API
/////////////////////////////////////////////////////////////////////////////////////
extension HUD {
    
    @discardableResult
    public static func show(_ content:HUD.Content, inView container:UIView ,configure: ((HUD)->())? = nil)->HUD{
        
        let hud =  HUD(content:content,container:container)
        if let config = configure { config(hud)}
        hud.prepare()
        
        return hud
    }
    
    public func hide() {
        hide(showNext: true)
    }
    
    public static func hide(){

        let activeNode = Rich.getNodes(type: .hud)
        activeNode.forEach({ (node) in
            node.hide(showNext: true)
        })

    }
    
    
}

extension HUD {
 
    @discardableResult
    public func refreshContent(_ content:Content) ->HUD{
        self.content = content
        return self
    }

}





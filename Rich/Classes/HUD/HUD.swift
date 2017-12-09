//
//  HUD.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
// import YogaKit

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
    
    var content:Content = .delay
    
    
    required public init( container:UIView){
        
        self.containerView = container
        
        self.background = Background(color: .clear, layout: .default(container))
        
    }
    
}




// MARK:- DistinguishAction
extension HUD{
    
    
    
    func configBody(){
        let body = HUDBody(content:content)

        body.prepareRender(){ layout in
            layout.isEnabled = true
            layout.width = 150
//            layout.aspectRatio = 1
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }

        
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
    
    /// in this method , we will give some default properties value to the content of HUD Node
    ///
    /// - Returns: Content
    @discardableResult
    public func defaultAppearance() ->HUD.Content {
        switch type {
        case .systemActivity:break
        case .success(let description):
            
            description?.margin = UIEdgeInsets(top:5,bottom:5)
            
        case .failure(let description):
            description?.margin = UIEdgeInsets(top:5,bottom:5)

        case let  .titleThenImage(title, image):
            title?.margin = UIEdgeInsets(top:10)
            image?.margin = UIEdgeInsets(vertical:5)

        case let .imageThenName(image, name):
            
            image?.margin = UIEdgeInsets(top:10)
            name?.margin = UIEdgeInsets(vertical:5)

        case .progress: break
        case .delay: break

         
        }
        return self
    }
}



/////////////////////////////////////////////////////////////////////////////////////
// Public API
/////////////////////////////////////////////////////////////////////////////////////
extension HUD {
    
    /// This method help you show up one HUD
    ///
    /// - Parameters:
    ///   - container: we will put the new HUD on the container you provided
    ///   - configure: in this configure block , you can custom three main feature :
    ///       1. animation:  animation style .
    ///       2. background: include backgroundcolor or whole background, even yogalayout.
    ///       3. content:  the content appearance and something that will show.
    /// - Returns: the created new HUD
    @discardableResult
    public static func show(on container:UIView ,configure: ((HUD)->())? = nil)->HUD{
        
        let hud =  HUD(container:container)
        if let config = configure { config(hud)}
        hud.prepare()
        
        return hud
    }
    
    
    /// instance method to call hide and remove
    public func hide() {
        makeHidden()
    }
    
    /// class method to call hide and remove
    public static func hide(type:Hidden = .removeDirectly){

        let activeNode = Rich.getNodes(type: .hud)
        
        guard !activeNode.isEmpty else {
            return
        }
        
        let frontNodes = activeNode.filter{$0 !== activeNode.last!}
        
        frontNodes.forEach({ (node) in
            node.makeHidden(type:type , showNext: false)
        })
        
        guard let last = activeNode.last else {
            return
        }
        last.makeHidden(type: type, showNext: true)
    }
    
    
}

extension HUD {
 
    @discardableResult
    public func refreshContent(_ content:Content) ->HUD{
        self.content = content
        return self
    }

}





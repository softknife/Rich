//
//  Alert.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
@import YogaKit

public final class Alert:Skeleton{
    
    var richType : RichType = .alert
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
        
        
        self.background = Background(color: UIColor(type:.transparentGray), layout: .default(container))
        
        

    }
    
}

/// DistinguishAciton
extension Alert{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.remove(self)
            return
        }
        
        // configura default action to decide to hide current view or not
        switch content.type {
        case let .default(_,_, ops):
            setDefaultHideViewAction(ops)
        case let .image(_, _, ops):
            setDefaultHideViewAction(ops)
        case .delay:break
        }

        
        // yoga layout configuration
        let body = AlertBody( content: content)
        
        body.prepareRender(){ layout in
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        
        background.addSubview(body)
        background.body = body
        
    }
    

    
    
    func turnToShow(time:State.AwakeStyle){
        
        containerView?.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
    }
    
    func turnToHide(finished:((Bool)->())?){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
        }) { (finish) in
            self.background.removeFromSuperview()
            finished?(finish)
        }

    }

}


extension Alert {
    public struct Content:ContentBindable{
        var type:ContentType
        
        public static var delay : Content {return Content(type: .delay)}

        public static func `default`(title:Description? = nil ,subTitle:Description? = nil,operations:[Operation])->Content{
            return Content(type: .default(title:title,subTitle:subTitle,operations:operations))
        }
        
        public static func image(title:Description? = nil,image:Image? = nil,operations:[Operation])  ->Content{
            return Content(type: .image(title: title, image: image, operations:operations))
        }
    }
    
    
    enum ContentType{
        case delay
        case `default`(title:Description?,subTitle:Description?,operations:[Operation])
        case image(title:Description?,image:Image?,operations:[Operation])

    }
}

extension Alert.Content {
    @discardableResult
    public func defaultConfiguration() ->Alert.Content{
        
        switch type {
        case let .default(title, subTitle, operations):
            configDefaultProperty(title, subTitle: subTitle, image: nil, ops: operations)
            
        case let .image(title, _, operations):
            configDefaultProperty(title, subTitle: nil, image: nil, ops: operations)
            
        case .delay: break
        }
        
        return self
    }
    
    private func configDefaultProperty(_ title: Description?,subTitle:Description?,image:Image?,ops:[Operation]?){
        
        title?.backgroundColor = .clear
        title?.textColor = .gray
        title?.font = .systemFont(ofSize: 16)
        title?.margin = UIEdgeInsets(top: 10)
        
        subTitle?.backgroundColor = .clear
        subTitle?.textColor = .gray
        subTitle?.font = .systemFont(ofSize: 17)
        subTitle?.margin = UIEdgeInsets(all:10)
        
        image?.margin = UIEdgeInsets(vertical: 10)
        
        guard let ops = ops else{   return }
        for op in ops {
            op.backgroundColor = .clear
            
            switch op.style {
            case .normal:
                op.textColor = .gray
            case .danger:
                op.textColor = .red
            }
        }

    }
}


/////////////////////////////////////////////////////////////////////////////////////
// Public API
/////////////////////////////////////////////////////////////////////////////////////
extension Alert {
 
    @discardableResult
    public static func show(_ content:Alert.Content, inView container:UIView ,configure: ((Alert)->())?  = nil)->Alert{
        let alert =  Alert(content:content,container:container)
        if let config = configure {config(alert)}
        alert.prepare()
        return alert
    }
    
    public func hide() {
        hide(showNext: true)
    }
    
    public static func hide(){
        
        let activeNode = Rich.activeNode()
        activeNode?.hide(showNext: true)
        
    }


}

extension Alert {
    
    @discardableResult
    public func refreshContent(_ content:Content) ->Alert{
        self.content = content
        return self
    }

}


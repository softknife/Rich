//
//  Sheet.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

public final class Sheet:Skeleton{

    var richType : RichType = .sheet
    var state:State = .initial{
        didSet{
            changeViewLayoutAccordingState()
        }
    }

    weak  var containerView:UIView?
    public var background : Background
    public var animation:Animation = .fadedIn
    
    var content:Content


    required public init(content:Content, container:UIView){

        self.content = content.defaultConfiguration()
        self.containerView = container

        let customLayout:Background.InitialLayout  =
            .custom({ [unowned container] (layout) in
                layout.isEnabled = true
                layout.justifyContent = .flexEnd
                layout.alignItems = .center
                layout.width = YGValue(container.frame.size.width)
                layout.height = YGValue(container.frame.size.height)
            })

        self.background = Background(color: UIColor(type:.transparentGray), layout: customLayout)

    }
}

extension Sheet{

    func configBody(){

        guard let container = containerView else {
            Rich.remove(self)
            return
        }

        // configura default action to decide to hide current view or not
        switch content.type {
        case let .system(items, others):
            
            guard let others = others else {break}
            let ops = items + others

            setDefaultHideViewAction(ops)
        case .delay:break

        }
        
        // Yoga layout configuration
        let body = SheetBody(content: content)

        body.prepareRender(){ layout in
            
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.marginBottom = 10
            layout.justifyContent = .center
            layout.alignItems = .stretch

        }
        
        background.addSubview(body)

        background.body = body
    }


    func turnToShow(time:State.AwakeStyle){

        guard let container = containerView else {
            Rich.remove(self)
            return
        }

        container.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)

        if case State.AwakeStyle.first = time {
            
            background.body!.transform = CGAffineTransform(translationX: 0, y: background.body!.bounds.height)
            UIView.animate(withDuration: 1, animations: {
                self.background.body!.transform = CGAffineTransform.identity
            })
        }
        
    }

    func turnToHide( finished:((Bool)->())?){

        UIView.animate(withDuration: 1, animations: {
            self.background.body!.transform = CGAffineTransform(translationX: 0, y: self.background.body!.bounds.height)
        }) { (finish) in
            
            self.background.removeFromSuperview()
            finished?(finish)
        }

    }

}


extension Sheet {

    public struct Content:ContentBindable{

        var type:ContentType

        public static var delay : Content {return Content(type: .delay)}

        public static func system(items:[Operation],others:[Operation]? = nil) ->Content {
            return Content(type: .system(items: items, others: others))
        }

    }

    enum ContentType{
        case delay
        case system(items:[Operation],others:[Operation]?)
    }


}

extension Sheet.Content {
    @discardableResult
    public func defaultConfiguration() ->Sheet.Content{
        
        switch type {
        case let .system(items, others):
            
            for item in items {
                item.backgroundColor = UIColor.init(white: 1.0, alpha: 0.6)
                item.textColor = .gray
            }
            
            guard let others = others else{break}
            
            for item in others {
                item.backgroundColor = UIColor.init(white: 1.0, alpha: 0.6)
                item.margin = UIEdgeInsets(top:10)
                item.cornerRadius = 10

                switch item.style {
                case .normal:
                    item.textColor = .gray
                case .danger:
                    item.textColor = .red
                }
            }
            
            
        case .delay: break
        }
        
        return self
    }
}



/////////////////////////////////////////////////////////////////////////////////////
// Public API
/////////////////////////////////////////////////////////////////////////////////////
extension  Sheet {
    
    @discardableResult
    public static func show(_ content:Sheet.Content, inView container:UIView ,configure: ((Sheet)->())?  = nil)->Sheet{
        let sheet =  Sheet(content:content,container:container)
        if let config = configure{config(sheet)}
        sheet.prepare()
        return sheet
    }

    public func hide() {
        hide(showNext: true)
    }
    
    public static func hide(){
        
        let activeNode = Rich.activeNode()
        activeNode?.hide(showNext: true)
        
    }
}

extension Sheet {
 
    
    @discardableResult
    public func refreshContent(_ content:Content) ->Sheet{
        self.content = content
        return self
    }

}

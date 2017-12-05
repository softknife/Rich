//
//  Sheet.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

public class Sheet:Skeleton,ExternalAction{
    
    var type : RichType = .sheet
    var state:State = .initial{
        didSet{
            changeAccordingState()
        }
    }

    weak var containerView:UIView?
    var background : Background
    var animation:Animation
    
    var content:Content
    
    
    required public init(content:Content, container:UIView,yoga:YGLayoutConfigurationBlock?,animation:Animation){
        
        self.content = content
        self.containerView = container
        self.animation = animation
        
        let customLayout:Background.InitialLayout
        if let yoga = yoga {
            customLayout = .custom(yoga)
        }else{
            customLayout = .custom({ [unowned container] (layout) in
                layout.isEnabled = true
                layout.justifyContent = .flexEnd
                layout.alignItems = .center
                layout.width = YGValue(container.frame.size.width)
                layout.height = YGValue(container.frame.size.height)
            })
        }
        
        self.background = Background(color: .clear, layout: customLayout)
        
    }
}

extension Sheet{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.remove(self)
            return
        }
        
        let body = SheetBody(content: content)
        
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.marginBottom = 10
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        
        background.addSubview(body)

        background.body = body
    }
 
    
    func turnToShow(time:State.Repeat){
        
        guard let container = containerView else {
            Rich.remove(self)
            return
        }
        
        container.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
        
        background.body!.transform = CGAffineTransform(translationX: 0, y: background.body!.bounds.height)
        UIView.animate(withDuration: 1, animations: {
            self.background.body!.transform = CGAffineTransform.identity
        })
    }
    
    func turnToHide(){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.body!.transform = CGAffineTransform(translationX: 0, y: self.background.body!.bounds.height)
        }) { (finished) in
            self.background.removeFromSuperview()
        }
        
    }

}

 
extension Sheet {
    
    public struct Content:ContentBindable{
        
        var type:ContentType
        
        public static func system(items:[Operation],others:[MO]? = nil) ->Content {
            return Content(type: .system(items: items, others: others))
        }
        
    }
    
    final public class MO:ExpressibleByStringLiteral,AdditionalConfiguration {
        
        var operation : Operation = ""
        var margin : UIEdgeInsets = .zero
        
        init() { }
        
        public init(stringLiteral value: String) {
            operation = Operation(stringLiteral: value)
            operation.backgroundColor = UIColor(white:1.0,alpha:0.7)
        }
        
    }
    
    
    
    internal enum ContentType{
        case system(items:[Operation],others:[MO]?)
    }
    
    
}


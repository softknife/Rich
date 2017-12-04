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
            customLayout = .default(container)
        }
        
        self.background = Background(color: .clear, layout: customLayout)
        
    }
}

extension Sheet{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.shared.remove(self)
            return
        }
        
        
        
        let body = SheetBody(content: content)
        
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        
        background.addSubview(body)

        
    }
 
    
    func turnToShow(time:State.Repeat){
        
    }
    func turnToHide(){
        
    }

}

 
extension Sheet {
    
    public struct Content:ContentBindable{
        
        var type:ContentType
        
        public static func system(items:[Operation],others:[(CGFloat,Operation)]? = nil) ->Content {
            return Content(type: .system(items: items, others: others))
        }
        
    }
    
    internal enum ContentType{
        case system(items:[Operation],others:[(CGFloat,Operation)]?)
    }
}


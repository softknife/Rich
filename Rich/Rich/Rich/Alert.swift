//
//  Alert.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

public class Alert:Skeleton,ExternalAction{
    
    var type : RichType = .alert
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

extension Alert{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.shared.remove(self)
            return
        }
        let body = AlertBody( content: content)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        
        background.addSubview(body)
        
    }
    func refreshBody(){
        
    }
    
    func turnToShow(time:State.Repeat){
        
        containerView?.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
    }
    
    func turnToHide(){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
        }) { (finished) in
            self.background.removeFromSuperview()
        }

    }

}

 
extension Alert {
    public struct Content:ContentBindable{
        var type:ContentType
        
        public static func `default`(title:String? = nil ,subTitle:String? = nil,operation1:String,operation2:String? = nil)->Content{
            return Content(type: .default(title:title,subTitle:subTitle,operation1: operation1, operation2: operation2))
        }
        
        public static func image(title:String? = nil,image:UIImage? = nil,operation1:String,operation2:String? = nil) ->Content{
         
            return Content(type: .image(title: title, image: image, operation1: operation1, operation2: operation2))
        }
    }
    
    internal enum ContentType{
        case `default`(title:String?,subTitle:String?,operation1:String,operation2:String?)
        case image(title:String?,image:UIImage?,operation1:String,operation2:String?)

    }
}


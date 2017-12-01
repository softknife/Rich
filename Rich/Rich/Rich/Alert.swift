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
        
        let body = AlertBody()
        body.configureLayout { (layout) in
            layout.isEnabled = true

            layout.width = 300
//            layout.paddingHorizontal = 20
            layout.height = 200
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
        
        public static func `default`(title:String? = nil ,subTitle:String? = nil,confirm:String? = nil,cancel:String? = nil)->Content{
            return Content(type: .default(title:title,subTitle:subTitle,confirm: confirm, cancel: cancel))
        }
    }
    
    internal enum ContentType{
        case `default`(title:String?,subTitle:String?,confirm:String?,cancel:String?)
        
    }
}


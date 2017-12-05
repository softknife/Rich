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
        
        
        switch content.type {
        case let .default(_,_, ops):
            setDefaultOperation(ops: ops)
        case let .image(_, _, ops):
            setDefaultOperation(ops: ops)
        }

    }
    
}

extension Alert{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.remove(self)
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
        background.body = body
        
    }
    
    private func setDefaultOperation(ops:[Operation]){
        
        for op in ops {
            if op.action == nil {
                op.action =  { [weak self] in
                    guard let weakSelf = self else {return}
                    Rich.remove(weakSelf)
                    weakSelf.turnToHide()
                }
            }
        }

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
        
        public static func `default`(title:Description? = nil ,subTitle:Description? = nil,operations:[Operation])->Content{
            return Content(type: .default(title:title,subTitle:subTitle,operations:operations))
        }
        
        public static func image(title:Description? = nil,image:Image? = nil,operations:[Operation])  ->Content{
            return Content(type: .image(title: title, image: image, operations:operations))
        }
    }
    
    
    
    internal enum ContentType{
        case `default`(title:Description?,subTitle:Description?,operations:[Operation])
        case image(title:Description?,image:Image?,operations:[Operation])

    }
}


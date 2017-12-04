//
//  HUD.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

public class HUD:Skeleton,ExternalAction{
    
    var type : RichType = .hud
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
    }

    func refreshBody(){
     
        containerView?.subviews.forEach{$0.removeFromSuperview()}
        configBody()
        
        
        if state == .awake(time: .first) || state == .awake(time: .again){
            containerView?.addSubview(background)
            background.yoga.applyLayout(preservingOrigin: true)
        }
    }
    
    func turnToShow(time:State.Repeat){
        
        containerView?.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
        
        if time == .first{
            background.alpha = 0
            UIView.animate(withDuration: 1) {
                self.background.alpha = 1
            }
        }

    }
    
    
    
    func turnToHide(){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
        }) { (finished) in
            self.background.removeFromSuperview()
        }
        
    }
    

    
    
}

// MARK:- ContentType
extension HUD {
 
    public struct Content:ContentBindable {
        var type: ContentType
        
        static var systemActivity:Content{
            return Content(type: .systemActivity)
        }
        
        static func success(description:Description? = nil)->Content{
            return Content(type: .success(description: description))
        }
        
        static func failure(description:Description? = nil )->Content{
            return Content(type: .failure(description: description))
        }
        
        static func titleThenImage(title:Description? = nil , image:Image? = nil )->Content{
            return Content(type: .titleThenImage(title: title, image: image))
        }
        
        static func imageThenName(image:Image? = nil ,name:Description? = nil )->Content{
            return Content(type: .imageThenName(image: image, name: name))
        }
        
        static func progress(_ type:ProgressType)->Content{
            return Content(type: .progress(type))
        }
    }

    
    public enum ProgressType{
        case `default`(Progress)
        case textInCircle(Progress)
        case pie(Progress)
    }
    
    
    internal enum ContentType  {
        
        case systemActivity
        case success(description:Description?)
        case failure(description:Description?)
        
        case titleThenImage(title:Description?,image:Image?)
        case imageThenName(image:Image?,name:Description?)
        
        case progress(ProgressType)
    }
}







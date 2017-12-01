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
        let body = HUDBody()
        body.configureLayout { (layout) in
            layout.isEnabled = true
        }

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
        
        static func success(title:String? = nil ,subtitle:String? = nil)->Content{
            return Content(type: .success(title: title, subtitle: subtitle))
        }
        
        static func failure(title:String? = nil ,subtitle:String? = nil )->Content{
            return Content(type: .failure(title: title, subtitle: subtitle))
        }
        
        static func attributes1(title:String? = nil ,subtitle:String? = nil ,image:UIImage? = nil )->Content{
            return Content(type: .attributes1(title: title, subtitle: subtitle, image: image))
        }
        
        static func attributes2(image:UIImage? = nil ,name:String? = nil ,detail:String? = nil )->Content{
            return Content(type: .attributes2(image: image, name: name, detail: detail))
        }
        
        static func progress(_ type:ProgressType)->Content{
            return Content(type: .progress(type))
        }
    }

    
    public enum ProgressType{
        case `default`
        case textInCircle
        case pie
    }
    
    
    internal enum ContentType  {
        
        
        case systemActivity
        
        
        case success(title:String?,subtitle:String?)
        case failure(title:String?,subtitle:String?)
        
        
        case attributes1(title:String?,subtitle:String?,image:UIImage?)
        case attributes2(image:UIImage?,name:String?,detail:String?)
        
        case progress(ProgressType)
        
        
    }
}







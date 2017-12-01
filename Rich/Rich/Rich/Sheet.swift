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
        
    }
    func refreshBody(){
        
    }
    
    func turnToShow(time:State.Repeat){
        
    }
    func turnToHide(){
        
    }

}

 
extension Sheet {
    
    public struct Content:ContentBindable{
        
        var type:ContentType
        
    }
    
    internal enum ContentType{
        
    }
}


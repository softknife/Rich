//
//  Wrapper.swift
//  YogaKitSample
//
//  Created by 黄继平 on 2017/11/26.
//  Copyright © 2017年 facebook. All rights reserved.
//

import UIKit
import YogaKit


public class Background:UIView {
    
    
    
    public init(color:UIColor , layout:InitialLayout) {
        
        super.init(frame: .zero)

        backgroundColor = color
        
        // initial layout
        switch layout {
        case .default(let container):
            
            configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.justifyContent = .center
                layout.alignItems = .center
                layout.width = YGValue(container.frame.size.width)
                layout.height = YGValue(container.frame.size.height)
            })
            
        case .custom(let yoga):
            
            configureLayout(block: yoga)
            
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    var body:UIView?
//
//    func holdBody<T:UIView>(_ body:T) where T : BodyConfigure  {
//        self.body = body
//    }
//    func getBody<T:BodyConfigure>() -> T {
//        return self.body as! T
//    }
}


extension Background{
    
    public enum InitialLayout {
        case `default`(UIView)
        case custom(YGLayoutConfigurationBlock)
    }
    
}




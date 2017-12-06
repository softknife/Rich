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
    
    //    fileprivate var viewType : ViewType
//    var contentView : BodyConfigure?
    
    
    
    
    public init(color:UIColor = .clear , layout:InitialLayout) {
        
        super.init(frame: .zero)
        //        self.viewType = viewType
        
        //        // initial create view
        //        switch viewType {
        //        case .defualt(let color):
        //
        //            view = UIView()
        //            view.backgroundColor = color
        //
        //        case .blur(let blurStyle):
        //
        //            view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        //
        //        }
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
    
//    public enum ViewType {
//        case `defualt`(UIColor)
//        case blur(UIBlurEffectStyle)
//    }
    
    //    class BlurView: UIVisualEffectView {
    //
    //    }
    //
    //    class NormalView: UIView {
    //
    //    }
    
}

extension Background{
    
    //    func addSubview(_ view:UIView){
    //
    //        switch viewType {
    //        case .blur(_):
    //
    //            let blurView = self.view as! UIVisualEffectView
    //            blurView.contentView.addSubview(view)
    //
    //        case .defualt(_):
    //
    //            self.view.addSubview(view)
    //        }
    //    }
    //
    //    func updateLayout()  {
    //        view.yoga.applyLayout(preservingOrigin: true)
    //    }
}




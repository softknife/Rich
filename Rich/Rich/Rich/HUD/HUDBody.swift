//
//  Body.swift
//  YogaKitSample
//
//  Created by 黄继平 on 2017/11/26.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

class HUDBody: UIView , BodyConfigure{
    
    typealias T = HUD
    var content : T.Content
    
    init(content:HUD.Content) {
        self.content = content
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HUDBody {
    
    private func setup()  {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        
        switch content.type {
        case .systemActivity:
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            addSubview(activity)
            activity.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.alignSelf = .stretch
                layout.aspectRatio = 1
            })
            activity.startAnimating()
            
        case let .success(title):
            
            let image = Image(named: "thumb")
            configImage(image,marginTop: 5)
            
            configTitle(title,marginTop: 10,marginBottom: 10)

        case let .failure(title):
            
            let image = Image(named: "thumb")
            configImage(image,marginTop: 5)
        
            configTitle(title,marginTop: 10,marginBottom: 10)
            
        case let .progress(progress):
            
            let progressView = ProgressView(content:progress)
            addSubview(progressView)
            progressView.configureLayout(block: { (layout) in
                layout.isEnabled =  true
                layout.width = 100
                layout.height = 100
            })
            
            
            
        case let .titleThenImage(title, image):
            
            
            configTitle(title,marginTop: 5)
            
            configImage(image,marginTop: 10,marginBottom: 10)


        case let .imageThenName(image, name):
            
            configImage(image,marginTop: 5)

            configTitle(name,marginTop: 10,marginBottom: 10)
            

        }
        
    }
    
    private func configImage(_ image:Image?,marginTop:YGValue = 0,marginBottom:YGValue = 0){
        
        guard let image = image else {
            return
        }
        
        let successView = ImageView(content: image)
        addSubview(successView)
        successView.configureLayout(block: { (layout) in
            layout.isEnabled = true
            layout.marginTop = marginTop
            layout.marginBottom = marginBottom
            
            layout.flexGrow = 1
            layout.maxHeight = 100
            
        })
    }
    
    private func configTitle(_ title:Description? ,marginTop:YGValue = 0 ,marginBottom: YGValue = 0){
        if let title = title {
            let titleLabel = TextLabel(content: title)
            addSubview(titleLabel)
            titleLabel.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.marginTop = marginTop
                layout.marginBottom = marginBottom
            })
            
        }
    }
}





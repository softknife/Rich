//
//  Body.swift
//  YogaKitSample
//
//  Created by 黄继平 on 2017/11/26.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
// import YogaKit

class HUDBody: UIView , BodyVisualEffectConfigure{
    
    typealias T = HUD
    var content : T.Content
    var blurView : VisualEffectView
    

    init(content:HUD.Content) {
        self.content = content
        blurView = VisualEffectView()

        super.init(frame: .zero)
        
        addSubview(blurView)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension HUDBody:YGLayoutDefaultConfiguration {
    
    private func setup()  {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        
        switch content.type {
        case .systemActivity:
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            contentView.addSubview(activity)
            activity.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.alignSelf = .stretch
                layout.aspectRatio = 1
                
            })
            activity.startAnimating()
            
        case let .success(title):
            
            let image = Image(named: "thumb")
            image.margin = UIEdgeInsets(vertical:10)
            configImage(image)
            
            configTitle(title)

        case let .failure(title):
            
            let image = Image(named: "thumb")
            image.margin = UIEdgeInsets(vertical:10)
            configImage(image)
        
            configTitle(title)
            
        case  .progress(let progress):
            

            let progressView = ProgressView(content:progress)
            contentView.addSubview(progressView)
            progressView.configureLayout(block: { (layout) in
                layout.isEnabled =  true
                layout.width = 100
                layout.height = 100
            })
            
            
            
        case let .titleThenImage(title, image):
            
            
            configTitle(title)
            
            configImage(image)


        case let .imageThenName(image, name):
            
            configImage(image)

            configTitle(name)
        case .delay:break


        }
        
    }
    
    private func configImage(_ image:Image?){
        
        guard let image = image else {
            return
        }
        
        let successView = ImageView(content: image)
        contentView.addSubview(successView)
        successView.configureLayout(block: { (layout) in
            layout.isEnabled = true
            
            self.configViewMargin(image.margin, layout: layout)
            
            layout.flexGrow = 1
            layout.maxHeight = 100
            layout.alignSelf = .center
            
        })
    }
    
    private func configTitle(_ title:Description? ){
        if let title = title {
            let titleLabel = TextLabel(content: title)
            contentView.addSubview(titleLabel)
            titleLabel.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.alignSelf = .center
                self.configViewMargin(title.margin, layout: layout)
            })
            
        }
    }
}





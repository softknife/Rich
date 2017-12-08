//
//  AlertBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

class AlertBody: UIView , BodyConfigure{
    
    typealias T = Alert
    var content : T.Content
    
    var blurView : VisualEffectView

    init(color: UIColor = UIColor(white: 1.0, alpha: 0.8) , content:Alert.Content) {
        
        self.content = content
        blurView = VisualEffectView()

        super.init(frame: .zero)
        
        addSubview(blurView)

        self.backgroundColor = color
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AlertBody {
    
    private func setup()  {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        
        switch content.type {
        case let .default(title, subTitle, ops):
            
            // upper contentView
            let contentView = ContentView(title: title, subTitle: subTitle)
            contentView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.justifyContent = .flexStart
                layout.alignItems = .center
            })
            self.contentView.addSubview(contentView)
            
            // operation view
            configOperationView(ops)

        case let .image(title, image, ops):
            
            // upper contentView
            let contentView = ContentView(title: title, image: image)
            contentView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.justifyContent = .flexStart
                layout.alignItems = .center
            })
            self.contentView.addSubview(contentView)
            
            
            // operation view
            configOperationView(ops)
        case .delay:break

        }
    }
    
    private func configOperationView(_ ops:[Operation]){
     
        // seperateLine
        let seperate = SeperateLine()
        self.contentView.addSubview(seperate)
        
        // lower operation View
        let operationView = OperationView(ops: ops)
        operationView.configureLayout(block: { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .stretch
            
        })
        self.contentView.addSubview(operationView)

    }
}




// MARK:- ContentView
extension AlertBody {
    
    class ContentView:UIView , YGLayoutDefaultConfiguration{
        init(title:Description?,subTitle:Description?) {
            super.init(frame: .zero)
            
//            backgroundColor = .green
            
            configTitle(title)

            if let sub = subTitle {
                
                let titleLabel = TextLabel(content: sub)
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    
                    layout.flexGrow = 1
                    layout.maxHeight = 100
                    layout.minHeight = 80
                    
                    self.configViewMargin(sub.margin, layout: layout)

                })

            }
            
        }
        
        init(title:Description?,image:Image?) {
            super.init(frame: .zero)
            
            configTitle(title)
            
            if let image = image {
                
                let imageView = ImageView(content: image)
                addSubview(imageView)
                imageView.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.marginTop = 20
                    layout.marginBottom = 10
                    
                    layout.flexGrow = 1
                    layout.maxHeight = 100
                    layout.minHeight = 80
                })
            }

        }

        private func configTitle(_ title:Description?){
            
            if let title = title {
                let titleLabel = TextLabel(content:title)
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    self.configViewMargin(title.margin, layout: layout)
                })
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
  
    }
}


// MARK:- OperationView
extension AlertBody {
    class OperationView: UIView {
        
        init(ops:[Operation]) {
            super.init(frame: .zero)
            

            for (offset, op) in ops.enumerated() {

                if offset > 0 {
                    
                    let separete = UIView()
                    separete.backgroundColor = UIColor.groupTableViewBackground
                    addSubview(separete)
                    separete.configureLayout(block: { (layout) in
                        layout.isEnabled = true
                        layout.width = 1
                        layout.marginVertical = 5
                        
                    })
                }
                
                let opButton = Button(content: op)
                opButton.click = {button in
                    op.action?()
                }
//                opButton.backgroundColor = .orange
                addSubview(opButton)
                opButton.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.flexGrow = 1

                })
                
            }
            
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
}



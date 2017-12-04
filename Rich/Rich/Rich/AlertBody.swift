//
//  AlertBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

class AlertBody: UIView {
 
    let content : Alert.Content
    
    init(color: UIColor = UIColor(white: 1.0, alpha: 0.8) , content:Alert.Content) {
        
        self.content = content

        super.init(frame: .zero)
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
            addSubview(contentView)
            
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
            addSubview(contentView)
            
            
            // operation view
            configOperationView(ops)
        }
    }
    
    private func configOperationView(_ ops:[Operation]){
     
        // seperateLine
        let seperate = UIView()
        seperate.backgroundColor = UIColor.lightGray
        addSubview(seperate)
        seperate.configureLayout(block: { (layout) in
            layout.isEnabled = true
            layout.height = 0.5
        })
        
        
        // lower operation View
        let operationView = OperationView(ops: ops)
        operationView.configureLayout(block: { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .stretch
            
        })
        addSubview(operationView)

    }
}




// MARK:- ContentView
extension AlertBody {
    
    class ContentView:UIView {
        init(title:Description?,subTitle:Description?) {
            super.init(frame: .zero)
            
//            backgroundColor = .green
            
            configTitle(title)

            if let sub = subTitle {
                
                let titleLabel = UILabel()
                titleLabel.backgroundColor = sub.backgroundColor
                titleLabel.numberOfLines = 0
                titleLabel.text = sub.value
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.marginTop = 20
                    layout.marginBottom = 10
                    
                    layout.flexGrow = 1
                    
                    layout.maxHeight = 100
                    layout.minHeight = 80

                })

            }
            
        }
        
        init(title:Description?,image:Image?) {
            super.init(frame: .zero)
            
            configTitle(title)
            
            if let image = image {
                
                let imageView = UIImageView()
                imageView.image = image.value
                imageView.backgroundColor = image.backgroundColor
                imageView.contentMode = image.contentMode
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
                let titleLabel = UILabel()
                titleLabel.text = title.value
                titleLabel.backgroundColor = title.backgroundColor
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.marginTop = 5
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
            

            for (index ,op) in ops.enumerated() {
                
                if index > 0 {
                    
                    let separete = UIView()
//                    separete.backgroundColor = .lightGray
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


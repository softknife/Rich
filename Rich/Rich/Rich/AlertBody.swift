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
        case let .default(title, subTitle, operation1, operation2):
            
            
            let contentView = ContentView(title: title, subTitle: subTitle)
            contentView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.justifyContent = .flexStart
                layout.alignItems = .center
                

            })
            addSubview(contentView)
            
            
            
            var ops = [String]()
            ops.append(operation1)
            if let op2 = operation2 {
                ops.append(op2)
            }
            let operationView = OperationView(ops: ops)
            operationView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
                layout.flexDirection = .row
                layout.justifyContent = .spaceBetween
                layout.alignItems = .stretch
            })
            
            addSubview(operationView)
            
            
        case let .image(title, image, operation1, operation2):
            
            let contentView = ContentView(title: title, image: image)
            contentView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 200
                layout.justifyContent = .spaceBetween
                layout.alignItems = .center
            })
            addSubview(contentView)
            
            
            
            
            var ops = [String]()
            ops.append(operation1)
            if let op2 = operation2 {
                ops.append(op2)
            }
            let operationView = OperationView(ops: ops)
            operationView.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
                layout.flexDirection = .row
                layout.justifyContent = .spaceBetween
                layout.alignItems = .center
            })

            addSubview(operationView)

        }
    }
}




// MARK:- ContentView
extension AlertBody {
    
    class ContentView:UIView {
        init(title:String?,subTitle:String?) {
            super.init(frame: .zero)
            
            backgroundColor = .green
            
            if let title = title {
                let titleLabel = UILabel()
                titleLabel.backgroundColor = .purple
                titleLabel.text = title
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.marginTop = 5
                })
            }

            if let sub = subTitle {
                
                let titleLabel = UILabel()
                titleLabel.backgroundColor = .yellow
                titleLabel.numberOfLines = 0
                titleLabel.text = sub
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
        
        init(title:String?,image:UIImage?) {
            super.init(frame: .zero)
            
            if let title = title {
                let titleLabel = UILabel()
                titleLabel.text = title
                addSubview(titleLabel)
                titleLabel.configureLayout(block: { (layout) in
                    layout.isEnabled = true
                    layout.marginTop = 5
                })
            }
            
            if let image = image {
                
                let imageView = UIImageView()
                imageView.image = image
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

        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


// MARK:- OperationView
extension AlertBody {
    class OperationView: UIView {
        
        init(ops:[String]) {
            super.init(frame: .zero)
            

            for (index ,op) in ops.enumerated() {
                
                if index > 0 {
                    
                    let separete = UIView()
                    separete.backgroundColor = .lightGray
                    addSubview(separete)
                    separete.configureLayout(block: { (layout) in
                        layout.isEnabled = true
                        layout.width = 1
                        layout.marginVertical = 5
                        
                    })
                }
                
                let opButton = Button(content: op)
                opButton.backgroundColor = .orange
                opButton.titleLabel?.textAlignment = .center
                opButton.setTitle(op, for: .normal)
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


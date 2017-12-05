//
//  SheetBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

class SheetBody: UIView , BodyConfigure{
    
    typealias T = Sheet
    var content : T.Content
    
    init(content:Sheet.Content) {
        self.content = content
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SheetBody {
    
    private func setup(){
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .clear
        
        guard case let Sheet.ContentType.system(items, others) = content.type else {
            return
        }
        
        configItems(items)
        
        guard let otherItems = others else {
            return
        }
        configOthers(otherItems)
        
    }
    
    private func configItems(_ items:[Operation]){
        
        let container = UIView()
        container.layer.cornerRadius = layer.cornerRadius
        container.layer.masksToBounds = true
        container.backgroundColor = .clear
        container.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        addSubview(container)
        
        
        for (offset, item) in items.enumerated() {
            
            if offset > 0 {
                let line = SeperateLine()
                container.addSubview(line)
            }
            
            
            let button = Button(content: item)
            button.click = {btn in
                item.action?()
            }
            container.addSubview(button)
            button.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
            })
            
        }
    }
    
    private func configOthers(_ items:[Sheet.MO]){
        
        for (_, item) in items.enumerated() {
            
            let marginOp = item
            
            if marginOp.margin.top <= 0 {
                let line = SeperateLine()
                addSubview(line)
            }
            
            let button = Button(content: marginOp.operation)
            button.click = {btn in
                marginOp.operation.action?()
            }
            addSubview(button)
            button.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
                
                let margin = marginOp.margin
                if margin.top > 0 { layout.marginTop = YGValue(margin.top) }
                if margin.left > 0 { layout.marginLeft = YGValue(margin.left) }
                if margin.bottom > 0 { layout.marginBottom = YGValue(margin.bottom) }
                if margin.right > 0 { layout.marginRight = YGValue(margin.right) }
        

            })

        }
    }
    
}

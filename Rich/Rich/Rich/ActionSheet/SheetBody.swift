//
//  SheetBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

class SheetBody: UIView {
    
    let content : Sheet.Content
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
        for (index,item) in items.enumerated() {
            if index > 0 {
                let line = SeperateLine()
                addSubview(line)
            }
            
            let button = Button(content: item)
            addSubview(button)
            button.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
            })
            
        }
    }
    
    private func configOthers(_ items:[(CGFloat,Operation)]){
        
        for item in items.enumerated() {
            
            if item.1.0 <= 0 {
                let line = SeperateLine()
                addSubview(line)
            }
            
            let button = Button(content: item.1.1)
            
            addSubview(button)
            button.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 50
                layout.marginTop = YGValue(item.1.0)
            })

        }
    }
    
}

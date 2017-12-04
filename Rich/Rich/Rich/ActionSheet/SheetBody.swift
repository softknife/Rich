//
//  SheetBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

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
        
    }
    
    private func configOthers(_ items:[(CGFloat,Operation)]){
        
    }
    
}

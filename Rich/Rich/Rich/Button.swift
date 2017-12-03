//
//  Button.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/2.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

internal class Button : UIButton {
    
    var click : ((Button)->())?
    
    
    internal init(content:String,color:UIColor = .gray,font:UIFont = .systemFont(ofSize: 16) ,backgroundColor:UIColor = .clear) {
        super.init(frame:.zero)

        setTitle(content, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font

        self.backgroundColor = backgroundColor
        
        addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button{
    
    @objc private func buttonClick(){
        guard let callback = click else {
            return
        }
        callback(self)
        
    }
}




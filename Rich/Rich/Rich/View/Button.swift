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
    
    let content : Operation
    internal init(content:Operation) {
        self.content = content
        super.init(frame:.zero)

        setup()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button{
    
    private func setup(){
        
        switch content.value {
        case .image(let image):
            setImage(image, for: .normal)
        case .text(let text):
            setTitle(text, for: .normal)
            setTitleColor(content.textColor, for: .normal)
            titleLabel?.font = content.font
            titleLabel?.textAlignment = .center
        }
        
        if content.cornerRadius > 0 {
            layer.cornerRadius = content.cornerRadius
        }
        
        backgroundColor = content.backgroundColor
        addTarget(self, action: #selector(buttonClick), for: .touchUpInside)

    }
    
    @objc private func buttonClick(){
        click?(self)
    }
}




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
    
    
    internal init(content:Operation) {
        super.init(frame:.zero)

        switch content.value {
        case .image(let image):
            setImage(image, for: .normal)
        case .text(let text):
            setTitle(text, for: .normal)
            setTitleColor(content.textColor, for: .normal)
            titleLabel?.font = content.font
            titleLabel?.textAlignment = .center
        }
        
        backgroundColor = content.backgroundColor
        addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button{
    
    @objc private func buttonClick(){
        click?(self)
    }
}




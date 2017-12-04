//
//  TextLabel.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class TextLabel:UILabel {
    
    let content:Description
    init(content:Description) {
        self.content = content
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextLabel {
    private func setup(){
        
        backgroundColor = content.backgroundColor
        font = content.font
        textColor = content.textColor
        numberOfLines = content.numberOfLines
        text = content.value
    }
}

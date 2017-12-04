//
//  ImageView.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class  ImageView: UIImageView {
    
    let content : Image
    init(content:Image) {
        self.content = content
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageView {
    private func setup(){
       
        image = content.value
        backgroundColor = content.backgroundColor
        contentMode = content.contentMode
    }
}

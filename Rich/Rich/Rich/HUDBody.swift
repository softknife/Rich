//
//  Body.swift
//  YogaKitSample
//
//  Created by 黄继平 on 2017/11/26.
//  Copyright © 2017年 facebook. All rights reserved.
//

import UIKit

class HUDBody: UIView {
    
    init(color: UIColor = UIColor(white: 1.0, alpha: 0.8) , size:CGSize = CGSize(width: 150, height: 150)) {
        super.init(frame: .zero)
        self.backgroundColor = color
        frame.size.width = size.width
        frame.size.height = size.height
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HUDBody {
    
    private func setup()  {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}



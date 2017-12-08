//
//  SeperateLine.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
@import YogaKit

class SeperateLine : UIView {
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 }

extension SeperateLine {
    private func setup(){
        
        backgroundColor = UIColor.groupTableViewBackground
        configureLayout(block: { (layout) in
            layout.isEnabled = true
            layout.height = 0.5
        })

    }
}

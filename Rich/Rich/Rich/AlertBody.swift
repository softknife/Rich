//
//  AlertBody.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class AlertBody: UIView {
 
    init(color: UIColor = UIColor(white: 1.0, alpha: 0.8) ) {
        super.init(frame: .zero)
        self.backgroundColor = color
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AlertBody {
    
    private func setup()  {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}



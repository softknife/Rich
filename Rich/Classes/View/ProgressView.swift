//
//  ProgressView.swift
//  Rich
//
//  Created by 黄继平 on 2017/12/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class  ProgressView: UIView {
    
    let progress : HUD.ProgressType
    
    init(content:HUD.ProgressType) {
        self.progress = content
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        
        switch progress {
        case .default(let pro):
            print(pro.totalUnitCount)
        case .pie(let pro):
            print(pro.totalUnitCount)
        case .textInCircle(let pro):
            print(pro.totalUnitCount)
        }
    }

    
}

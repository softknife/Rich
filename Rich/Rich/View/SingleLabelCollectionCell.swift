//
//  SingleLabelCollectionCell.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

final class SingleLabelCollectionCell: UICollectionViewCell {
    let label: UILabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .flexEnd
        }
        
        label.textAlignment = .center
        label.numberOfLines = 1
        label.yoga.isIncludedInLayout = false
        contentView.addSubview(label)
        
        let border = UIView(frame: .zero)
        border.backgroundColor = .lightGray
        border.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 0.5
            layout.marginHorizontal = 25
        }
        contentView.addSubview(border)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.yoga.applyLayout(preservingOrigin: false)
        label.frame = contentView.bounds
    }
}


//
//  MessageViewController.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
    }
    
}


extension MessageViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if arc4random_uniform(10) % 2 == 0 {
           
            HUD.show( .success(title: ""), inView: view, yoga: nil, animation: .fadedIn)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                HUD.hide()
            }

        }else{
            
            Alert.show(.default(cancel: "取消"), inView: view, yoga: nil, animation: .fadedIn)
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                Alert.hide()
//            }

        }
    }
}


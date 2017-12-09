//
//  MessageViewController.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import Rich

class MessageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
}


extension MessageViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if arc4random_uniform(10) % 2 == 0 {
            
            
            if arc4random_uniform(10) % 2 == 0{
                testActionSheet()

            }else{
                testHUD()
            }
            
        }else{
            testAlert()
        }
        

        
        
        
    }
    
    private func testHUD() {
        
        if arc4random_uniform(10) % 2 == 0 {
            let ad = HUD.show( .success(description: "成功"), inView: view, configure: { hud in
                    hud.background.backgroundColor = .green
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                
                ad.hide()
            }

        }else{
            HUD.show( .systemActivity, inView: view){hud in
                hud.background.backgroundColor = .purple
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                
                HUD.show( .success(description: "成功"), inView: self.view)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    
                    HUD.hide()
                    
                }

            })
        }


    }
    
    private func testAlert(){
        
        
        
        if arc4random_uniform(10) % 2 == 0 {
            
            let desc = ["点什么?测试点什么?试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点",
                        "点什么?测试点什么?试 🛰大大大",
                        "试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点么?测试点什么?试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测",
                        "😁😁😁😁😁😁😁😁"]
            
            let sub = desc[Int(arc4random_uniform(UInt32(desc.count - 1)))]
            
            Alert.show(.delay, inView: view){ alert in
                
                alert.background.backgroundColor = .blue
                
                let content = Alert.Content.default(
                                title:"测试",
                                subTitle:Description(stringLiteral:"\(sub)"),
                                operations:[Operation(stringLiteral:"确定").triggerHideView(),"取消"]
                                                    ).defaultConfiguration()
                
                alert.refreshContent(content)
            }

        }else{
            
            Alert.show(.delay, inView: view){ alert in
                
                let content = Alert.Content.image(
                            title:"测试图片",
                            image:Image(named:"thumb"),
                            operations:[Operation(stringLiteral:"确定").triggerHideView()]
                                                  ).defaultConfiguration()
                
                alert.refreshContent(content)
                
            }

        }

    }
    
    private func testActionSheet()  {
   
        
        let confirm : Rich.Operation = "确定"
        
        let cancel = Operation(value: .text("取消"),style:.danger)
        
        let pufa =   Rich.Operation(value: .text("浦发银行")) {
            print("浦发一行")
        }
        
        let items = [ pufa,
                        Operation(value: .text("建设银行")),
                        Operation(value: .text("招商银行"))
                    ]
        
        
        Sheet.show(
            .system(items: items
                ,others: [confirm,cancel]),inView: view){action in}

    }
}


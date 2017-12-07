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
        
        view.backgroundColor = .white
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
                alert.refreshContent(.default(title:"测试",subTitle:Description(stringLiteral:"\(sub)"),operations:[Operation(stringLiteral:"确定").triggerHide(true),"取消"]))
            }

        }else{
            
            Alert.show(.delay, inView: view){ alert in
                alert.refreshContent(.image(title:"测试图片",image:Image(named:"thumb"),operations:[Operation(stringLiteral:"确定").triggerHide(true)]))
                
            }

        }

    }
    
    private func testActionSheet()  {
   
        
        let confirm = MarginOperation(stringLiteral:"确定").plus { (mo) in
            //mo.margin = UIEdgeInsets(top:10)
            let op = mo.operation
            op.backgroundColor = .green
            op.cornerRadius = 10
            op.textColor = .white
            op.triggerHide(true)
//            op.action = {
//                print("确定")
//                Sheet.hide()
//            }

        }
        
        let cancel = MarginOperation(stringLiteral: "取消").plus { (mo) in
            mo.margin = UIEdgeInsets(top: 5)
            mo.operation.plus{
                $0.action = {
                    print("取消")
                    Sheet.hide()
                }
                $0.textColor = .gray
                $0.backgroundColor = UIColor(white: 1, alpha: 0.7)
                $0.cornerRadius = 10
            }
            
        }
        
        
        Sheet.show(
            .system(items:
                [
                    Operation(value: .text("浦发银行"), textColor: .black, backgroundColor: .white, action: {
                        print("浦发银行")
                    }),
                    Operation(value: .text("建设银行"), textColor: .blue, backgroundColor: .orange, action: {
                        print("建设银行")
                    }),
                    Operation(value: .text("招商银行"), textColor: .blue, backgroundColor: .purple, action: {
                        print("招商银行")
                    })],others: [confirm,cancel]),inView: view)

    }
}


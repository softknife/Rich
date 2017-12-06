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
        
        
        testActionSheet()
        
//        if arc4random_uniform(10) % 2 == 0 {
//
//            HUD.show( .success(description: "成功"), inView: view)
//        HUD.show( .systemActivity, inView: view)

//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                HUD.hide()
//            }
//
//        }else{
        
//        Alert.show(.image(title:"测试图片",image:Image(named:"thumb"),operations:["确定"]), inView: view)
        
//            Alert.show(.default(title:"测试",subTitle:"测试点什么?测试点什么?试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点么?测试点什么?试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点测试点什么?测试点什么?么?测试点什么?试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点试点什么?测试点什么?测试点测试点什么?测试点什么?什么?测试点测试点什么?测试点什么?",operation1:"确定",operation2:"取消"), inView: view)
            

//        }
        
        
        
    }
    
    func testActionSheet()  {
   
        
        let confirm = MarginOperation(stringLiteral:"确定").plus { (mo) in
            //mo.margin = UIEdgeInsets(top:10)
            let op = mo.operation
            op.backgroundColor = .green
            op.cornerRadius = 10
            op.textColor = .white
            op.action = {
                print("确定")
                Sheet.hide()
            }

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


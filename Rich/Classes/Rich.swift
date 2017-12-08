//
//  Gloria.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import YogaKit

internal class Rich {
    
    typealias Node =  BaseConfigure & DistinguishAction & CommonAction
    
    internal static let shared = Rich()
    
    internal let queue = DispatchQueue.global()
    
    private var nodes = [Node]()
    
    private init(){
        runloop()
    }
    
    private var timer:Timer?
}


extension Rich{
    
    internal static func getNodes()->[Node]{
        return Rich.shared.nodes
    }
    
    internal static func add(_ node:Node){
        Rich.shared.nodes.append(node)
        
        guard let _ = Rich.shared.timer else {
            Rich.shared.runloop()
            return
        }
    }
    
    internal static func remove(_ node:Node){
       Rich.shared.nodes = Rich.shared.nodes.filter{ $0 !== node }
    }
    
    
    internal static func containNode(type:RichType)->Bool{
        return !(getNodes(type: type).isEmpty)
    }
    
    internal static func  getNodes(type:RichType) -> [Node]{
        return Rich.shared.nodes.filter{$0.richType == type}
    }
    
    internal static func activeNodeType()->RichType?{
        return activeNode()?.richType
    }
    
    internal static func activeNode()->Node?{
        return Rich.shared.nodes.filter{($0.state == .awake(time:.first)) || ($0.state == .awake(time:.turn2))}.first
    }
    
    internal static func nextWillShow(from base:Node) ->Node?{
        
        var copyNodes = [Node]()
        
        for node in Rich.getNodes().enumerated() {
            if node.1 !== base {
                copyNodes.append(node.1)
            }else{
                break
            }
        }
        
        if copyNodes.isEmpty {
            copyNodes = Rich.shared.nodes.filter{$0 !== base}
        }

        return copyNodes.last
    }
}



 extension Rich {
    
    
    private func runloop(){
        
        DispatchQueue.global().async {
            
            
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: .removeInvalidNode, userInfo: nil, repeats: true)
                
//                Timer(timeInterval: 2, target: self, selector: .removeInvalidNode, userInfo: nil, repeats: true)
//            timer.fire()
//            RunLoop.current.add(timer, forMode: .commonModes)
//            RunLoop.current.run()
            CFRunLoopRun()
            
        }
        
        /*
         Manually removing all known input sources and timers from the run loop is not a guarantee that the run loop will exit. OS X can install and remove additional input sources as needed to process requests targeted at the receiver’s thread. Those sources could therefore prevent the run loop from exiting.
         
         If you want the run loop to terminate, you shouldn't use this method. Instead, use one of the other run methods and also check other arbitrary conditions of your own, in a loop.
 
        Event Loop 在很多系统和框架里都有实现，比如 Node.js 的事件处理，比如 Windows 程序的消息循环，再比如 OSX/iOS 里的 RunLoop。实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。
         */
        
    }
    
    @objc fileprivate func removeInvalidNode(){
        
        print("RunLoop something")
        
        nodes = nodes.filter{ $0.containerView != nil }
        
        if nodes.isEmpty {
            self.timer?.invalidate()
            self.timer = nil
            CFRunLoopStop(RunLoop.current.getCFRunLoop())
        }


        
        
    }

}

extension Selector {
    static let removeInvalidNode = #selector(Rich.removeInvalidNode)
}




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
        return Rich.shared.nodes.filter{$0.type == type}
    }
    
    internal static func activeNodeType()->RichType?{
        return activeNode()?.type
    }
    
    internal static func activeNode()->Node?{
        return Rich.shared.nodes.filter{($0.state == .awake(time:.first)) || ($0.state == .awake(time:.again))}.first
    }
    
    internal static func nextWillShow(from base:Node) ->Node?{
        let index = Rich.shared.nodes.index { (node) -> Bool in
            return node === base
        }
        
        guard let idx = index else  {
            return nil
        }
        
        let previous =  idx.advanced(by: -1)
        if previous < 0 {
            return nil
        }
        
        return Rich.shared.nodes[previous]
    }
    
    private func runloop(){
        
         DispatchQueue.global().async {
            
            let timer = Timer(timeInterval: 2, target: self, selector: .removeInvalidNode, userInfo: nil, repeats: true)
            timer.fire()
            
//            RunLoop.current.add(timer, forMode: .commonModes)
//
//            RunLoop.current.run()
            self.timer = timer
            
        }
        
        /*
         Manually removing all known input sources and timers from the run loop is not a guarantee that the run loop will exit. OS X can install and remove additional input sources as needed to process requests targeted at the receiver’s thread. Those sources could therefore prevent the run loop from exiting.
         
         If you want the run loop to terminate, you shouldn't use this method. Instead, use one of the other run methods and also check other arbitrary conditions of your own, in a loop.
         */
        
    }
    
    @objc fileprivate func removeInvalidNode(){
        
        print("RunLoop something")
        
//        if nodes.isEmpty {
//            timer?.invalidate()
//            timer = nil
//        }
//
//        while let timer =  self.timer, timer.isValid && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
//            nodes = nodes.filter{ $0.containerView != nil }
//        }
      
    }
}

extension Selector {
    static let removeInvalidNode = #selector(Rich.removeInvalidNode)
}



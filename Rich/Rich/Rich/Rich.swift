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
    
    internal var nodes = [Node]()
    
    private init(){
        runloop()
    }
    
    
}


extension Rich{
    
    internal func remove(_ node:Node){
        nodes = nodes.filter{ $0 !== node }
    }
    
    internal func containNode(type:RichType)->Bool{
        return !(nodes(type: type).isEmpty)
    }
    
    internal func nodes(type:RichType) -> [Node]{
        return nodes.filter{$0.type == type}
    }
    
    internal func activeNodeType()->RichType?{
        return activeNode()?.type
    }
    
    internal func activeNode()->Node?{
        return nodes.filter{($0.state == .awake(time:.first)) || ($0.state == .awake(time:.again))}.first
    }
    
    internal func nextWillShow(from base:Node) ->Node?{
        let index = nodes.index { (node) -> Bool in
            return node === base
        }
        
        guard let idx = index else  {
            return nil
        }
        
        let previous =  idx.advanced(by: -1)
        if previous < 0 {
            return nil
        }
        
        return nodes[previous]
    }
    
    private func runloop(){
        
        DispatchQueue.global().async {
            
            let timer = Timer(timeInterval: 2, target: self, selector: .removeInvalidNode, userInfo: nil, repeats: true)
            timer.fire()
            
            RunLoop.current.add(timer, forMode: .commonModes)
            RunLoop.current.run()
            
        }
        
    }
    
    @objc fileprivate func removeInvalidNode(){
        
        print("RunLoop something")
        
        for (i,node) in nodes.enumerated() {
            if node.containerView == nil {
                nodes.remove(at: i)
            }
        }
    }
}

extension Selector {
    static let removeInvalidNode = #selector(Rich.removeInvalidNode)
}



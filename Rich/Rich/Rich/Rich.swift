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
    
    
}


extension Rich{
    
    internal static func getNodes()->[Node]{
        return Rich.shared.nodes
    }
    
    internal static func add(_ node:Node){
        Rich.shared.nodes.append(node)
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
            
            RunLoop.current.add(timer, forMode: .commonModes)
            RunLoop.current.run()
            
        }
        
    }
    
    @objc fileprivate func removeInvalidNode(){
        
        print("RunLoop something")
        
        nodes = nodes.filter{ $0.containerView != nil }
      

    }
}

extension Selector {
    static let removeInvalidNode = #selector(Rich.removeInvalidNode)
}



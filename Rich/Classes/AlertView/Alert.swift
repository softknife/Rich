//
//  Alert.swift
//  Gloria
//
//  Created by 黄继平 on 2017/11/28.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
// import YogaKit

public final class Alert:Skeleton{
    
    var richType : RichType = .alert
    var state:State = .initial{
        didSet{
            changeViewLayoutAccordingState()
        }
    }

    weak var containerView:UIView?
    public var background : Background
    public var animation:Animation = .fadedIn
    
    var content:Content = .delay
    
    
    required public init(container:UIView){
        
        self.containerView = container
        
        self.background = Background(color: UIColor(.transparentGray), layout: .default(container))
        
        

    }
    
}

/// DistinguishAciton
extension Alert{
    
    func configBody(){
        
        guard let container = containerView else {
            Rich.remove(self)
            return
        }
        
        // configura default action to decide to hide current view or not
        switch content.type {
        case let .default(_,_, ops):
            setDefaultHideViewAction(ops)
        case let .image(_, _, ops):
            setDefaultHideViewAction(ops)
        case .delay:break
        }

        
        // yoga layout configuration
        let body = AlertBody( content: content)
        
        body.prepareRender(){ layout in
            layout.isEnabled = true
            layout.width = YGValue(container.frame.width - 60)
            layout.justifyContent = .center
            layout.alignItems = .stretch
        }
        
        background.addSubview(body)
        background.body = body
        
    }
    

    
    
    func turnToShow(time:State.AwakeStyle){
        
        containerView?.addSubview(background)
        background.yoga.applyLayout(preservingOrigin: true)
    }
    
    func turnToHide(finished:((Bool)->())?){
        
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
        }) { (finish) in
            self.background.removeFromSuperview()
            finished?(finish)
        }

    }

}


extension Alert {
    public struct Content:ContentBindable{
        var type:ContentType
        
        public static var delay : Content {return Content(type: .delay)}

        public static func `default`(title:Description? = nil ,subTitle:Description? = nil,operations:[Operation])->Content{
            return Content(type: .default(title:title,subTitle:subTitle,operations:operations))
        }
        
        public static func image(title:Description? = nil,image:Image? = nil,operations:[Operation])  ->Content{
            return Content(type: .image(title: title, image: image, operations:operations))
        }
    }
    
    
    enum ContentType{
        case delay
        case `default`(title:Description?,subTitle:Description?,operations:[Operation])
        case image(title:Description?,image:Image?,operations:[Operation])

    }
}

extension Alert.Content {
    
    /// in this method , we will give some default properties value to the content of Alert Node
    ///
    /// - Returns: Content
    @discardableResult
    public func defaultAppearance() ->Alert.Content{
        
        switch type {
        case let .default(title, subTitle, operations):
            configDefaultProperty(title, subTitle: subTitle, image: nil, ops: operations)
            
        case let .image(title, _, operations):
            configDefaultProperty(title, subTitle: nil, image: nil, ops: operations)
            
        case .delay: break
        }
        
        return self
    }
    
    private func configDefaultProperty(_ title: Description?,subTitle:Description?,image:Image?,ops:[Operation]?){
        
        title?.backgroundColor = .clear
        title?.textColor = .gray
        title?.font = .systemFont(ofSize: 16)
        title?.margin = UIEdgeInsets(top: 10)
        
        subTitle?.backgroundColor = .clear
        subTitle?.textColor = .gray
        subTitle?.font = .systemFont(ofSize: 17)
        subTitle?.margin = UIEdgeInsets(all:10)
        
        image?.margin = UIEdgeInsets(vertical: 10)
        
        guard let ops = ops else{   return }
        for op in ops {
            op.backgroundColor = .clear
            
            switch op.style {
            case .normal:
                op.textColor = .gray
            case .danger:
                op.textColor = .red
            }
        }

    }
}


/////////////////////////////////////////////////////////////////////////////////////
// Public API
/////////////////////////////////////////////////////////////////////////////////////
extension Alert {
 
    /// This method help you show up one AlertView
    ///
    /// - Parameters:
    ///   - container: we will put the new alertView on the container you provided
    ///   - configure: in this configure block , you can custom three main feature :
    ///       1. animation:  animation style .
    ///       2. background: include backgroundcolor or whole background, even yogalayout.
    ///       3. content:  the content appearance and something that will show.
    /// - Returns: the created new alertView
    @discardableResult
    public static func show(on container:UIView ,configure: ((Alert)->())?  = nil)->Alert{
        let alert =  Alert(container:container)
        if let config = configure {config(alert)}
        alert.prepare()
        return alert
    }
    
    
    /// instance method to call hide and remove
    public func hide() {
        makeHidden()
    }
    
    /// class method to call hide and remove
    public static func hide(type:Hidden = .removeDirectly){
        
        let activeNode = Rich.getNodes(type: .alert)

        guard !activeNode.isEmpty else {
            return
        }
        
        let frontNodes = activeNode.filter{$0 !== activeNode.last!}
        
        frontNodes.forEach({ (node) in
            node.makeHidden(type:type , showNext: false)
        })
        
        guard let last = activeNode.last else {
            return
        }
        last.makeHidden(type: type, showNext: true)

    }


}

extension Alert {
    
    @discardableResult
    public func refreshContent(_ content:Content) ->Alert{
        self.content = content
        return self
    }

}


//
//  FrameBufferUpdater.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import Foundation

class FrameBufferUpdater {
    
    static var sharedInstance: FrameBufferUpdater?
    
    let server: RFBFramebufferedConnection
    var active = false {
        didSet {
            self.updateIfNeeded()
        }
    }
    var subscribedViews: [RFBRectView] = []
    
    private func updateIfNeeded() {
        if self.active {
            self.server.requestScreenUpdate(true)
        }
    }
    
    init(server: RFBFramebufferedConnection) {
        self.server = server
        server.didUpdatedFrame = { [weak self] (_) in
            self?.updateIfNeeded()
        }
        server.didUpdatedRect = { [weak self] (rect) in
            self?.filterOutFreedViews() //have to do it here because extensions does not support deinit
            dispatch_async(dispatch_get_main_queue()) {
                for view in self?.subscribedViews ?? [] {
                    view.setNeedsDisplayInOuterRect(rect)
                }
            }
        }
    }
    
    func subscribeView(view: RFBRectView) {
        subscribedViews.append(view)
        self.active = !subscribedViews.isEmpty
    }
    
    func unsubscribeView(view: RFBRectView) {
        if let index = subscribedViews.indexOf(view) {
            subscribedViews.removeAtIndex(index)
            self.active = !subscribedViews.isEmpty
        }
    }
    
    func filterOutFreedViews() {
        self.subscribedViews.flatMap { (view) in
            return view.window == nil ? view : nil
        }.forEach { (view) -> () in
            self.unsubscribeView(view)
        }
    }
}

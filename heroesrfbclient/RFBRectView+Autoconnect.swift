//
//  RFBRectView+AutoFramebuffer.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import Foundation
import UIKit

extension RFBRectView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.framebuffer = AppState.sharedInstance.server?.framebuffer
        FrameBufferUpdater.sharedInstance?.subscribeView(self)
        
        self.installTapRecognizers()
        self.tapEventHandler = { (point) in
            AppState.sharedInstance.server?.sendMouseEvent(1, atPoint: point)
            AppState.sharedInstance.server?.sendMouseEvent(0, atPoint: point)
        }
    }
    
}

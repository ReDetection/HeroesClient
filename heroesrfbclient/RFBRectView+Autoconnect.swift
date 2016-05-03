//
//  RFBRectView+AutoFramebuffer.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import Foundation

extension RFBRectView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.framebuffer = AppState.sharedInstance.server?.framebuffer
        FrameBufferUpdater.sharedInstance?.subscribeView(self)
    }
    
}

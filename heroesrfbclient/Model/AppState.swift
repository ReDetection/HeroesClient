//
//  AppState.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 02/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import Foundation

class AppState {

    static let sharedInstance = AppState()
    
    var server: RFBFramebufferedConnection? {
        didSet {
            if let server = server {
                FrameBufferUpdater.sharedInstance = FrameBufferUpdater(server: server)
            }
        }
    }
    
}

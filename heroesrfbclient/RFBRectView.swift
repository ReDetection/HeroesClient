//
//  RFBRectView.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import UIKit

class RFBRectView: UIView {
    
    var framebuffer: RFBFrameBuffer?
    @IBInspectable var frameRect: CGRect = CGRectZero

    
    override func drawRect(rect: CGRect) {
        if let framebuffer = self.framebuffer {
            
            let ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);

            if frameRect.height > 0 && frameRect.width > 0 {
                CGContextTranslateCTM(ctx, -frameRect.origin.x, -frameRect.origin.y)
                framebuffer.drawRect(frameRect, context: ctx)
                
            } else {
                framebuffer.drawFullInRect(CGRectMake(0, 0, framebuffer.size.width, framebuffer.size.height), context: ctx)
            }
            
            CGContextRestoreGState(ctx);
        }
    }
    
    func setNeedsDisplayInOuterRect(outerRect: CGRect) {
        if frameRect.height > 0 && frameRect.width > 0 {
            var drawRect = CGRectZero
            drawRect.origin.x = max(outerRect.origin.x - frameRect.origin.x, 0)
            drawRect.origin.y = max(outerRect.origin.y - frameRect.origin.y, 0)
            drawRect.size.height = min(outerRect.size.height, frameRect.size.height - drawRect.origin.y )
            drawRect.size.width = min(outerRect.size.width, frameRect.size.width - drawRect.origin.x)
            if drawRect.size.width > 0 && drawRect.size.height > 0 {
                self.setNeedsDisplayInRect(drawRect)
            }
        } else {
            self.setNeedsDisplayInRect(outerRect)
        }
    }

}

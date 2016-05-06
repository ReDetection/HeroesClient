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
    @IBOutlet weak var parentController: UIViewController?
    var scaleX: CGFloat {
        return self.bounds.size.width / frameRect.size.width
    }
    var scaleY: CGFloat {
        return self.bounds.size.height / frameRect.size.height
    }
    
    override func drawRect(rect: CGRect) {
        if let framebuffer = self.framebuffer {
            
            let ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);

            if frameRect.height > 0 && frameRect.width > 0 {
                CGContextScaleCTM(ctx, self.scaleX, self.scaleY)
                framebuffer.drawRect(frameRect, fromPoint: CGPointZero, context: ctx);
                
            } else {
                framebuffer.drawFullInRect(CGRectMake(0, 0, framebuffer.size.width, framebuffer.size.height), context: ctx)
            }
            
            CGContextRestoreGState(ctx);
        }
    }
    
    func setNeedsDisplayInOuterRect(outerRect: CGRect) {
        if frameRect.height > 0 && frameRect.width > 0 {
            let drawRect = outerRect.rectInsideRect(frameRect).scale(scaleX, scaleY)
            if drawRect.size.width > 0 && drawRect.size.height > 0 {
                self.setNeedsDisplayInRect(drawRect)
            }
        } else {
            self.setNeedsDisplayInRect(outerRect)
        }
    }

}

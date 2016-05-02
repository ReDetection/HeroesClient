//
//  FirstViewController.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 02/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var a: RFBFramebufferedConnection!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let server = RFBServerData()

        a = RFBFramebufferedConnection(serverData: server)
        a.didUpdatedFrame = { [ weak a] in
            a?.requestScreenUpdate(true)
        }
        a.didUpdatedRect = { [weak self, weak a] (rect) in
            if let view = self?.view as? RFBView, framebuffer = a?.framebuffer {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.framebuffer = framebuffer
                    view.setNeedsDisplayInRect(rect)
                })
            }
        }
        a.didErrorOccurred = { [weak self] (error) in
            dispatch_async(dispatch_get_main_queue()) {
                print ("\(error)")
                let alert = UIAlertController(title: "\(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
        a.connect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class RFBView: UIView {
    
    var framebuffer: RFBFrameBuffer?
    
    override func drawRect(rect: CGRect) {
        if let framebuffer = self.framebuffer {
            
            let ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            
            framebuffer.drawFullInRect(CGRectMake(0, 0, framebuffer.size.width, framebuffer.size.height), context: ctx)
            
            CGContextRestoreGState(ctx);
        }

    }
    
}

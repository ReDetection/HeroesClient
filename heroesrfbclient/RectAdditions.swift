//
//  RectAdditions.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    
    public func rectInsideRect(innerRect: CGRect) -> CGRect {
        var result = CGRectZero
        result.origin.x = max(self.origin.x - innerRect.origin.x, 0)
        result.origin.y = max(self.origin.y - innerRect.origin.y, 0)
        result.size.height = min(self.size.height, innerRect.size.height - result.origin.y )
        result.size.width = min(self.size.width, innerRect.size.width - result.origin.x)
        return result
    }
    
    public func scale(cx: CGFloat, _ cy: CGFloat) -> CGRect {
        var result = self
        result.origin.x *= cx
        result.origin.y *= cy
        result.size.height *= cy
        result.size.width *= cx
        return result
    }
    
}

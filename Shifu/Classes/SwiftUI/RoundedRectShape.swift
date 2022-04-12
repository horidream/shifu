//
//  RoundedCornerRectPath.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/4/8.
//

import SwiftUI

public struct RoundedRectShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    public init(corners: UIRectCorner, radius: CGFloat){
        self.corners = corners
        self.radius = radius
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(radius))
        
        return Path(path.cgPath)
    }
}




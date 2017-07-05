//
//  RoundedCornersView.swift
//  CustomCollectionViewLayoutTest
//
//  Created by Baoli.Zhai on 04/07/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import UIKit


class RoudedCornersView:UIView{
    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}

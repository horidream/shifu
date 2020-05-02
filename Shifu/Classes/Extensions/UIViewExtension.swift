//
//  UIViewExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/3/28.
//

import UIKit

@available(iOS 9.0, *)
public extension UIView{
    
    @discardableResult func quickAlign(_ type:UInt = 5, _ offsetX:CGFloat = 0, _ offsetY:CGFloat = 0, _ parent:UIView? = nil)->Self{
        if let parent = parent ?? self.superview{
            self.translatesAutoresizingMaskIntoConstraints = false
            switch type {
            case 1:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ])
            case 2:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ])
            case 3:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ])
            case 4:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)])
            case 5:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)
                ])
            case 6:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)
                ])
            case 7:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)])
            case 8:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)
                ])
            case 9:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)
                ])
            case 0:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -offsetY)
                ])
                
            default:()
                
            }
        }
        return self
    }
    
    
    
    @discardableResult func add(to superView: UIView?)->Self{
        superView?.addSubview(self)
        return self
    }
}

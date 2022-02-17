//
//  UIViewExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/3/28.
//

import UIKit
import WebKit
import CoreServices

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
    
    
    func blink(duration:TimeInterval = 2, count: Int = 3, delay:TimeInterval = 0 ){
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)], animations: {
            let step = count * 2
            let relativePiece:Double = 1 / Double(step)
            for i in (0..<step){
                UIView.addKeyframe(withRelativeStartTime: Double(i) * relativePiece, relativeDuration:  relativePiece) {
                    self.alpha = i % 2 == 1 ? 1 : 0
                }
            }
        })
    }
    
}

public enum SnapshotTarget{
    case album, clipboard(SnapshotType), none
}
public enum SnapshotType{
    case png, jpg
}

public extension WKWebView{
    func snapshot(config: WKSnapshotConfiguration? = nil, target: SnapshotTarget = .clipboard(.jpg)){
        self.takeSnapshot(with: config) { (image, error) in
            if let image = image{
                switch target{
                case .album:
                    image.writeToAlbum()
                case .clipboard(let type):
                    if type == .jpg{
                        UIPasteboard.general.setData(image.pngData() ?? Data(), forPasteboardType: kUTTypeJPEG as String)
                    }else{
                        UIPasteboard.general.setData(image.jpegData(compressionQuality: 0.5) ?? Data(), forPasteboardType: kUTTypePNG as String)
                    }
                default:()
                }
            }
        }
    }
    
}

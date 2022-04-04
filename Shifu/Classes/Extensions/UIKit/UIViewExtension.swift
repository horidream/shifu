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
    /// The margin of top, right, bottom, left,  same as css.
    @discardableResult func quickMargin(_ top: CGFloat? = nil, _ right: CGFloat? = nil, _ bottom: CGFloat? = nil, _ left: CGFloat? = nil, reference:UIView? = nil)->Self{
        if let parent = reference ?? self.superview{
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                top == nil ? nil : self.topAnchor.constraint(equalTo: parent.topAnchor, constant: top!),
                right == nil ? nil : self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -right!),
                bottom == nil ? nil : self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottom!),
                left == nil ? nil : self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: left!),
            ].compactMap{
                $0?.priority = .defaultHigh
                return $0
            })
        }
        return self
    }
    
    /// width, height
    @discardableResult func quickSize(_ width: CGFloat? = nil, _ height: CGFloat? = nil)->Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            width == nil ? nil : self.widthAnchor.constraint(equalToConstant: width!),
            height == nil ?  nil : self.heightAnchor.constraint(equalToConstant: height!)
        ].compactMap{ $0 })
        return self
    }
    
    /// position the view with as digital input
    @discardableResult func quickAlign(_ type:UInt = 5, _ offsetX:CGFloat = 0, _ offsetY:CGFloat = 0, _ reference:UIView? = nil)->Self{
        if let parent = reference ?? self.superview{
            self.translatesAutoresizingMaskIntoConstraints = false
            switch type {
            case 1:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 2:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 3:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 4:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 5:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 6:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 7:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 8:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 9:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 0:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: offsetX),
                    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -offsetX),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: offsetY),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
                
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

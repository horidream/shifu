//
//  UIImageEx.swift
//  Shifu
//
//  Created by Baoli Zhai on 21/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//


public extension UIImage{
    
    func getPixelColor(at pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }  
    
    var hasAlphaChannel:Bool {
        get{
            let alpha = self.cgImage?.alphaInfo;
            return (alpha == .first ||
                alpha == .last ||
                alpha == .premultipliedLast ||
                alpha == .premultipliedFirst);
        }
        
    }
    
    func resizedImage(scaleX:CGFloat, scaleY:CGFloat, smoothing:Bool = false) -> UIImage?{
        let w = self.size.width * scaleX
        let h = self.size.height * scaleY
        return resizedImage(width: w, height: h)
    }
    
    func resizedImage(width:CGFloat, height:CGFloat, smoothing:Bool = false) -> UIImage?{
        
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, hasAlphaChannel, 0)
        if(!smoothing){
            let context = UIGraphicsGetCurrentContext()
            context!.interpolationQuality = .none
        }
        self.draw(in: CGRect(origin: CGPoint(x:0, y:0), size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
        
    }
    
    
    func resizedImage(scale: CGFloat, smoothing:Bool = false) -> UIImage?{
        return resizedImage(scaleX: scale, scaleY: scale, smoothing:smoothing)
    }
}

//
//  UIImageEx.swift
//  Shifu
//
//  Created by Baoli Zhai on 21/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//
import UIKit
import AVFoundation

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
    
    func resizedImage(scaleX:CGFloat, scaleY:CGFloat, smoothing:Bool = false, forceAlphaChanel: Bool = false) -> UIImage?{
        let w = self.size.width * scaleX
        let h = self.size.height * scaleY
        return resizedImage(width: w, height: h, smoothing: smoothing, forceAlphaChanel: forceAlphaChanel )
    }
    
    func resizedImage(width:CGFloat, height:CGFloat, smoothing:Bool = false, forceAlphaChanel: Bool = false) -> UIImage?{
        
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
    
    
    func resizedImage(maxSize:CGFloat, smoothing:Bool = false) -> UIImage?{
        
        let size = self.size
        let currentMaxSize = max(size.width, size.height)
        if(currentMaxSize > maxSize){
            return resizedImage(scale: maxSize/currentMaxSize)
        }else{
            return self
        }
        
        
    }
    
    
    func resizedImage(scale: CGFloat, smoothing:Bool = false, forceAlphaChanel: Bool = false) -> UIImage?{
        return resizedImage(scaleX: scale, scaleY: scale, smoothing:smoothing, forceAlphaChanel: forceAlphaChanel)
    }
    
    func colorized(with color: UIColor = .white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)
        
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        
        return colored
    }
    
    func stroked(_ color: UIColor = .white, width: CGFloat = 1, quality: CGFloat = 4) -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        // Colorize the stroke image to reflect border color
        let strokeImage = colorized(with: color)
        
        guard let strokeCGImage = strokeImage.cgImage else { return self }
        
        /// Rendering quality of the stroke
        let step = 360 / min(max(quality, 1), 10)
        let thickness = abs(width)
        let oldRect = CGRect(x: thickness, y: thickness, width: size.width, height: size.height).integral
        let newSize = CGSize(width: size.width + 2 * thickness, height: size.height + 2 * thickness)
        let translationVector = CGPoint(x: thickness, y: 0)
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        defer {
            UIGraphicsEndImageContext()
        }
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.interpolationQuality = .high
        for angle: CGFloat in stride(from: 0, to: 360, by: step) {
            let vector = translationVector.rotated(around: .zero, byDegrees: angle)
            let transform = CGAffineTransform(translationX: vector.x, y: vector.y)
            
            context.concatenate(transform)
            
            context.draw(strokeCGImage, in: oldRect)
            
            let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
            context.concatenate(resetTransform)
        }
        if(width > 0){
            context.setBlendMode(.xor)
        }
        context.draw(cgImage, in: oldRect)
        
        guard let stroked = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        
        return stroked
    }
    
    func invertAlpha() -> UIImage? {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let (width, height) = (Int(self.size.width), Int(self.size.height))
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let byteOffsetToAlpha = 3 // [r][g][b][a]
        if let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                   space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue),
           let cgImage = self.cgImage {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(CGRect(origin: CGPoint.zero, size: self.size))
            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size))
            if let memory: UnsafeMutableRawPointer = context.data {
                for y in 0..<height {
                    let pointer = memory.advanced(by: bytesPerRow * y)
                    let buffer = pointer.bindMemory(to: UInt8.self, capacity: bytesPerRow)
                    for x in 0..<width {
                        let rowOffset = x * bytesPerPixel + byteOffsetToAlpha
                        buffer[rowOffset] = 0xff - buffer[rowOffset]
                    }
                }
                if let cgImage =  context.makeImage() {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    func writeToAlbum(){
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    @available(iOS 15.0, *)
    func attributedString(_ attributes: [NSAttributedString.Key : Any]? = nil)-> AttributedString{
        let attachment = NSTextAttachment()
        attachment.image = self
        let string = NSMutableAttributedString(attachment: attachment)
        if let attributes = attributes {
            string.addAttributes(attributes, range: NSMakeRange(0, string.string.count))
        }
        
        return string.nt
    }
}

public extension UIImage{
    convenience init?(base64String:String){
        var str = base64String
        if let range = base64String.range(of: "^data.*;base64,", options: .regularExpression){
            str.removeSubrange(range)
            
        }
        if let data = Data(base64Encoded: str){
            self.init(data:data)
        }else{
            return nil
        }
    }
}

public extension UISlider {
    var currentThumbImageView: UIImageView? {
        guard let image = self.currentThumbImage else { return nil }
        return self.subviews.compactMap({ $0 as? UIImageView }).first(where: { $0.image == image })
    }
}


public extension Array where Element: UIImage {
    func vGroup(scale: CGFloat = 1.0)->UIImage{
        return self.stitchImages(isVertical: true, scale: scale)
    }
    func hGroup(scale: CGFloat = 1.0)->UIImage{
        return self.stitchImages(isVertical: false, scale: scale)
    }
    func stitchImages(isVertical: Bool, scale imageGroupScale:CGFloat = 1.0, maxStitchedImageSize:CGFloat = Shifu.maxStitchedImageSize) -> UIImage {
        let arr = self.compactMap{ $0.size == .zero ? nil : $0}
        guard arr.count > 0 else { return UIImage() }
        guard arr.count != 1 else { return arr[0] }
        
        let firstSize = arr[0].size
        
        var sizes:[CGSize] = arr.compactMap { img in
            let scale = isVertical ? firstSize.width / img.size.width : firstSize.height / img.size.height;
            return img.size.scale(scale * imageGroupScale)
        }
        
        var totalSize = sizes.dropFirst().reduce(sizes.first!) { cum, current in
            let w = isVertical ? 0 : current.width
            let h = isVertical ? current.height : 0
            return cum.extends(w, h);
        }
        
        let maxSize = Swift.max(totalSize.width, totalSize.height)
        if(maxSize > maxStitchedImageSize){
            let downScale = maxStitchedImageSize / maxSize
            totalSize = totalSize.scale(downScale)
            sizes = sizes.map{size in size.scale(downScale)}
        }
        
        let renderer = UIGraphicsImageRenderer(size: totalSize)
        
        var currentPivot = CGPoint.zero
        return renderer.image { (context) in
            for (index, image) in self.enumerated() {
                let size = sizes[index];
                let rect = CGRect(origin: currentPivot, size: size)
                image.draw(in: rect)
                
                
                let shift:CGPoint = CGPoint(isVertical ? 0 : size.width, isVertical ? size.height : 0)
                
                currentPivot += shift
            }
        }
    }
}


extension CGImage {
    var alphaInverted: CGImage {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let (width, height) = (Int(self.width), Int(self.height))
        let size = CGSize(width: width, height: height)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let byteOffsetToAlpha = 3 // [r][g][b][a]
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                   space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue)!
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        context.draw(self, in: CGRect(origin: CGPoint.zero, size: size))
        if let memory: UnsafeMutableRawPointer = context.data {
            for y in 0..<height {
                let pointer = memory.advanced(by: bytesPerRow * y)
                let buffer = pointer.bindMemory(to: UInt8.self, capacity: bytesPerRow)
                for x in 0..<width {
                    let rowOffset = x * bytesPerPixel + byteOffsetToAlpha
                    buffer[rowOffset] = 0xff - buffer[rowOffset]
                }
            }
            if let cgImage =  context.makeImage() {
                return cgImage
            }
        }
        return UIImage().cgImage!
    }
}

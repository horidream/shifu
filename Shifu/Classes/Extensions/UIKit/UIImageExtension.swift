//
//  UIImageEx.swift
//  Shifu
//
//  Created by Baoli Zhai on 21/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//
import UIKit
import AVFoundation
import Vision
import CoreImage

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

public extension UIImage{
    func toMetadata(identifier: AVMetadataIdentifier = .commonIdentifierArtwork, quality:CGFloat = 1.0)->AVMetadataItem{
        let item = AVMutableMetadataItem()
        if (quality > 1.0){
            item.value = self.pngData() as (NSCopying & NSObjectProtocol)?
            item.dataType = kCMMetadataBaseDataType_PNG as String
        }else {
            item.value = self.jpegData(compressionQuality: quality ) as (NSCopying & NSObjectProtocol)?
            item.dataType = kCMMetadataBaseDataType_JPEG as String
        }
        item.identifier = identifier
        item.extendedLanguageTag = "und"
        return item
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


public class FontAwesome{
    static func image(_ code:String, size:CGFloat, color:UIColor)-> UIImage{
        
        if let fontName = fontName(for: code){
            return code.image(fontName, fontSize: size, fontColor: color) ?? UIImage()
            
        }
        return UIImage()
    }
    
    public static func fontName(for code:String)->String?{
        UIFont.useFontAwesome()
        return ["FontAwesome6Free-Regular", "FontAwesome6Free-Solid", "FontAwesome6Brands-Regular"].first { name in
            code.canBeRenderedBy(name)
        }
    }
}

public class Icons{
    public static func uiImage(_ name: Icons.Name, size: CGFloat = 40, color: UIColor = .black)->UIImage{
        if name.isFontAwesome {
            return FontAwesome.image(name.value, size: size, color: color)
        } else {
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: size))
            return UIImage(systemName: name.value, withConfiguration: config)?.withTintColor(color) ?? UIImage()
        }
    }
    
    public static func uiImageWithOutline(_ name: Icons.Name, size: CGFloat = 40, color: UIColor = .black, width: CGFloat = 1, fill: UIColor = .clear)->UIImage{
        let noFill = fill.hexValue32 == UIColor.clear.hexValue32
        let w =  noFill ?  width : -abs(width)
        if name.isFontAwesome {
            return name.value.attributedString().fontAwesome(size).with(.color(fill), .outline(color, width: w * UIScreen.main.scale)).image()
        } else {
            let c:UIColor = noFill ? .white : fill
            return Self.uiImage(name, size: size, color: c).attributedString().image().stroked(color, width: width)
        }
    }
}





//
//  UIImage+Editing.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/27.
//

import AVFoundation
import Vision
import CoreImage
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

#if canImport(UIKit)
public typealias UnifiedImage = UIImage
#else
public typealias UnifiedImage = NSImage
#endif

public extension UnifiedImage {
    func resizedImage(scaleX:CGFloat, scaleY:CGFloat, smoothing:Bool = false) -> UIImage?{
        let w = self.size.width * scaleX
        let h = self.size.height * scaleY
        return resizedImage(width: w, height: h, smoothing: smoothing)
    }
    
    func withBackground(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, !hasAlphaChannel, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        color.setFill()
        context.fill([CGRect(origin: .zero, size: size)])
        self.draw(at: .zero)
        defer{
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
    func withGradientBackground(_ colors: [UIColor], positions: [CGFloat]? = nil, start:CGPoint = .zero, end: CGPoint? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, !hasAlphaChannel, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        let cc = colors.count
        let locations = positions ?? colors.dropFirst(1).reduce([0]) { partialResult, _ in
            partialResult + [partialResult.count.cgFloat / cc.cgFloat]
        }
        let colors = colors.map(\.cgColor) as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: locations)!
        context.drawLinearGradient(gradient, start: start, end: end ?? CGPoint(x: size.width, y: size.height), options: [])
        self.draw(at: .zero)
        defer{
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }

    func resizedImage(width:CGFloat, height:CGFloat, smoothing:Bool = false) -> UIImage?{
        
        let size = CGSize(width: width, height: height)
        guard size != self.size else { return self }
        UIGraphicsBeginImageContextWithOptions(size, !hasAlphaChannel, 0)
        if(!smoothing){
            let context = UIGraphicsGetCurrentContext()
            context!.interpolationQuality = .none
        }
        self.draw(in: CGRect(origin: CGPoint(x:0, y:0), size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
        
    }
    
    func padding(_ rest:CGFloat...)->UIImage{
        var top:CGFloat = 10, left:CGFloat = 10, right:CGFloat = 10, bottom:CGFloat = 10
        let rest = rest ?? []
        switch rest.count {
        case 1:
            top = rest.get(0, 10)!
            left = top
            right = top
            bottom = top
        case 2:
            top = rest.get(0, 10)!
            left = rest.get(1, 10)!
            right = left
            bottom = top
        case 3:
            top = rest.get(0, 10)!
            left = rest.get(1, 10)!
            right = left
            bottom = rest.get(2, 10)!
        case 4...:
            top = rest.get(0, 10)!
            right = rest.get(1, 10)!
            bottom = rest.get(2, 10)!
            left = rest.get(3, 10)!
            
        default: ()
        }
        guard !(top == 0 && bottom == 0 && left == 0 && right == 0) else { return self }
        let size = CGSize(width: self.size.width + top + bottom , height: self.size.height + left + right)
        UIGraphicsBeginImageContextWithOptions(size, !hasAlphaChannel, 0)
        self.draw(at: CGPoint(left, top))
        defer{
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
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
    
    
    func resizedImage(scale: CGFloat, smoothing:Bool = false) -> UIImage?{
        return resizedImage(scaleX: scale, scaleY: scale, smoothing:smoothing)
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
    
    /// width: minus value will render original image inside
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
    
    func personSnapshot(quality: VNGeneratePersonSegmentationRequest.QualityLevel = .balanced, background: UIImage? = nil)->UIImage? {
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = quality
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        guard let original = CIImage(image: self) else { return nil }
        let task = VNImageRequestHandler(ciImage: original)
        try? task.perform([request])
        
        if let result = request.results?.first{
            let buffer = result.pixelBuffer
            let mask = CIImage(cvImageBuffer: buffer)
            let maskX = original.extent.width / mask.extent.width
            let maskY = original.extent.height / mask.extent.height
            let resizedMask = mask.transformed(by: CGAffineTransform(scaleX: maskX, y: maskY))
            let filter = CIFilter(name: "CIBlendWithMask", parameters: [
                kCIInputImageKey: original,
                kCIInputMaskImageKey: resizedMask])
            if let background, let bg = CIImage(image: background){
                
                let scaleX = original.extent.width / bg.extent.width
                let scaleY = original.extent.height / bg.extent.height
                let scale = max(scaleX, scaleY)
                let resizedBg = bg.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
                filter?.setValue(resizedBg, forKey: kCIInputBackgroundImageKey)
            }
            if let maskedImage = filter?.outputImage{
                let context = CIContext()
                guard let image = context.createCGImage(maskedImage, from: maskedImage.extent) else { return nil }
                
                return UIImage(cgImage: image)
            }
            
        }
        return nil
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

    /// Crops the insets of transparency around the image.
    ///
    /// - Parameters:
    ///   - maximumAlphaChannel: The maximum alpha channel value to consider  _transparent_ and thus crop. Any alpha value
    ///         strictly greater than `maximumAlphaChannel` will be considered opaque.
    public func trimmed(maximumAlphaChannel: UInt8 = 0) -> UnifiedImage {
        guard size.height > 1 && size.width > 1
            else { return self }

        #if canImport(UIKit)
        guard let cgImage = cgImage?.trimmingTransparentPixels(maximumAlphaChannel: maximumAlphaChannel)
            else { return self }

        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        #else
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)?
            .trimmingTransparentPixels(maximumAlphaChannel: maximumAlphaChannel)
            else { return self }

        let scale = recommendedLayerContentsScale(0)
        let scaledSize = CGSize(width: CGFloat(cgImage.width) / scale,
                                contentHeight: CGFloat(cgImage.contentHeight) / scale)
        let image = NSImage(cgImage: cgImage, size: scaledSize)
        image.isTemplate = isTemplate
        return image
        #endif
    }

}

extension CGImage {

    /// Crops the insets of transparency around the image.
    ///
    /// - Parameters:
    ///   - maximumAlphaChannel: The maximum alpha channel value to consider  _transparent_ and thus crop. Any alpha value
    ///         strictly greater than `maximumAlphaChannel` will be considered opaque.
    func trimmingTransparentPixels(maximumAlphaChannel: UInt8 = 0) -> CGImage? {
        return _CGImageTransparencyTrimmer(image: self, maximumAlphaChannel: maximumAlphaChannel)?.trim()
    }
    
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

private struct _CGImageTransparencyTrimmer {

    let image: CGImage
    let maximumAlphaChannel: UInt8
    let cgContext: CGContext
    let zeroByteBlock: UnsafeMutableRawPointer
    let pixelRowRange: Range<Int>
    let pixelColumnRange: Range<Int>

    init?(image: CGImage, maximumAlphaChannel: UInt8) {
        guard let cgContext = CGContext(data: nil,
                                        width: image.width,
                                        height: image.height,
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: CGColorSpaceCreateDeviceGray(),
                                        bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue),
            cgContext.data != nil
            else { return nil }

        cgContext.draw(image,
                       in: CGRect(origin: .zero,
                                  size: CGSize(width: image.width,
                                               height: image.height)))

        guard let zeroByteBlock = calloc(image.width, MemoryLayout<UInt8>.size)
            else { return nil }

        self.image = image
        self.maximumAlphaChannel = maximumAlphaChannel
        self.cgContext = cgContext
        self.zeroByteBlock = zeroByteBlock

        pixelRowRange = 0..<image.height
        pixelColumnRange = 0..<image.width
    }

    func trim() -> CGImage? {
        guard let topInset = firstOpaquePixelRow(in: pixelRowRange),
            let bottomOpaqueRow = firstOpaquePixelRow(in: pixelRowRange.reversed()),
            let leftInset = firstOpaquePixelColumn(in: pixelColumnRange),
            let rightOpaqueColumn = firstOpaquePixelColumn(in: pixelColumnRange.reversed())
            else { return nil }

        let bottomInset = (image.height - 1) - bottomOpaqueRow
        let rightInset = (image.width - 1) - rightOpaqueColumn

        guard !(topInset == 0 && bottomInset == 0 && leftInset == 0 && rightInset == 0)
            else { return image }

        return image.cropping(to: CGRect(origin: CGPoint(x: leftInset, y: topInset),
                                         size: CGSize(width: image.width - (leftInset + rightInset),
                                                      height: image.height - (topInset + bottomInset))))
    }

    @inlinable
    func isPixelOpaque(column: Int, row: Int) -> Bool {
        // Sanity check: It is safe to get the data pointer in iOS 4.0+ and macOS 10.6+ only.
        assert(cgContext.data != nil)
        return cgContext.data!.load(fromByteOffset: (row * cgContext.bytesPerRow) + column, as: UInt8.self)
            > maximumAlphaChannel
    }

    @inlinable
    func isPixelRowTransparent(_ row: Int) -> Bool {
        assert(cgContext.data != nil)
        // `memcmp` will efficiently check if the entire pixel row has zero alpha values
        return memcmp(cgContext.data! + (row * cgContext.bytesPerRow), zeroByteBlock, image.width) == 0
            // When the entire row is NOT zeroed, we proceed to check each pixel's alpha
            // value individually until we locate the first "opaque" pixel (very ~not~ efficient).
            || !pixelColumnRange.contains(where: { isPixelOpaque(column: $0, row: row) })
    }

    @inlinable
    func firstOpaquePixelRow<T: Sequence>(in rowRange: T) -> Int? where T.Element == Int {
        return rowRange.first(where: { !isPixelRowTransparent($0) })
    }

    @inlinable
    func firstOpaquePixelColumn<T: Sequence>(in columnRange: T) -> Int? where T.Element == Int {
        return columnRange.first(where: { column in
            pixelRowRange.contains(where: { isPixelOpaque(column: column, row: $0) })
        })
    }

}

//
//  qrcode.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/2/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

import UIKit




public class QRCode {
    public static func make(_ str:String, width:CGFloat = 0, height:CGFloat = 0) -> UIImage?
    {
        let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let filter:CIFilter = CIFilter(name: "CIQRCodeGenerator")!
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        if let qrcodeImage:CIImage = filter.outputImage
        {
            let img = UIImage(ciImage: qrcodeImage)
            if(width > 0 && height > 0){
                return img.resizedImage(scaleX: width/img.size.width, scaleY: height/img.size.height)
            }else{
                return img
            }
            
        }else{
            return nil
        }
    }
}

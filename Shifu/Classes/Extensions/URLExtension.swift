//
//  URLExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import Foundation
import AVFoundation
import MediaPlayer


extension URL{
    var filename:String{
        get{
            return self.deletingPathExtension().lastPathComponent
        }
    }
    var artwork:MPMediaItemArtwork?{
        let playerItem = AVPlayerItem(url: self) //this will be your audio source
        
        let metadataList = playerItem.asset.metadata
        if let artwork = (metadataList.filter { (item) -> Bool in
            return item.commonKey == AVMetadataKey.commonKeyArtwork
            }.first), let data = artwork.dataValue{
            if let image =  UIImage(data: data){
                if #available(iOS 10.0, *) {
                    return MPMediaItemArtwork(boundsSize: CGSize(width:100, height:100), requestHandler: { (size) -> UIImage in
                        image.resizedImage(width: size.width, height: size.height)!
                    })
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}

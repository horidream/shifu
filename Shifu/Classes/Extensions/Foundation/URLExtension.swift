//
//  URLExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import Foundation
import AVFoundation
import MediaPlayer


public extension URL{
    var filename:String{
        get{
            return self.deletingPathExtension().lastPathComponent
        }
    }
    
    var isDirectory:Bool{
        return self.path.isDirectory
    }
    
    var closestDirectoryName:String{
        let comps = self.pathComponents
        return (isDirectory ? comps.get(-1) : comps.get(-2))!
    }
    
    var artwork:MPMediaItemArtwork?{
        let playerItem = AVPlayerItem(url: self) //this will be your audio source
        
        let metadataList = playerItem.asset.metadata
        if let artwork = (metadataList.filter { (item) -> Bool in
            return item.commonKey == AVMetadataKey.commonKeyArtwork
        }.first), let data = artwork.dataValue{
            if let image =  UIImage(data: data){
                return MPMediaItemArtwork(boundsSize: CGSize(width:image.size.width, height:image.size.height), requestHandler: { (size) -> UIImage in
                    image.resizedImage(width: size.width, height: size.height)!
                })

            }
        }
        return nil
    }
    
    var content:String? {
        return try? String(contentsOf: self)
    }
}

public extension MPMediaItemArtwork {
    var originalImage:UIImage? {
        return image(at: self.bounds.size)
    }
}

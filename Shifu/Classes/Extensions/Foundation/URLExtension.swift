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
    
    var nextAvailableURL:URL{
        guard self.isFileURL && fm.fileExists(atPath: self.path) else { return self }
        let folder = self.deletingLastPathComponent()
        
        let fn = self.filename
        var basename = fn
        var count = 1
        let ex = self.pathExtension
        let patternFound = fn.findall(pattern:  "^(.*\\D)(\\d+)?$")[0]
        if let (_, b, c) = patternFound.spread3(){
            basename = b
            count = Int(c) ?? 1000
        }
        var neoFile = folder.appendingPathComponent("\(basename)\(count).\(ex)")
        while(fm.fileExists(atPath: neoFile.path)){
            count += 1
            neoFile = folder.appendingPathComponent("\(basename)\(count).\(ex)")
        }
        return neoFile
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
    
    var typeIdentifier: String?{
        let resouceValues = try? self.resourceValues(forKeys: [.typeIdentifierKey])
        return resouceValues?.typeIdentifier
    }
}

public extension MPMediaItemArtwork {
    var originalImage:UIImage? {
        return image(at: self.bounds.size)
    }
}

//
//  PinterestLayout.swift
//  TestExpandableTableView
//
//  Created by Baoli Zhai on 03/07/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//

import UIKit

public protocol PinterestLayoutDelegate {
    func collectionView(collectionView:UICollectionView, heightForItemAtIndexPath indexPath:IndexPath)->CGFloat
}

public class PinterestLayout:UICollectionViewLayout{
    public var delegate:PinterestLayoutDelegate!
    public var numberOfColumns:Int = 1
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight:CGFloat = 0
    private var width:CGFloat{
        return collectionView!.bounds.width
    }
    
    override public var collectionViewContentSize: CGSize{
        return CGSize(width: width, height: contentHeight)
    }
    
    override public func prepare() {
        if cache.isEmpty{
            let columnWidth = width/CGFloat(numberOfColumns)
            var xOffsets = [CGFloat]()
            for i in 0..<numberOfColumns{
                xOffsets.append(CGFloat(i) * columnWidth)
            }
            var yOffsets = [CGFloat](repeating:0, count:numberOfColumns)
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0){
                let indexPath = IndexPath(item: item, section: 0)
                let height = delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame = frame
                cache.append(attr)
                contentHeight = max(contentHeight, frame.maxY)
                let addmore:Bool = contentHeight == frame.maxY
                yOffsets[column] += height
                if(addmore){
                    column = column >= (numberOfColumns-1) ? 0 : column+1
                }else{
                    print("...")
                }
                
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter({ (attr) -> Bool in
            attr.frame.intersects(rect)
        })
    }
}

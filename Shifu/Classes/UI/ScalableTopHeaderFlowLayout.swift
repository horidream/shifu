//
//  ScalableTopHeaderFlowLayout.swift
//
//  Created by Baoli Zhai on 05/07/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//

import UIKit

class ScalableTopHeaderFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttrs = super.layoutAttributesForElements(in: rect)
        let offset = self.collectionView!.contentOffset
        if(offset.y < 0)
        {
            if let attr = layoutAttrs?.first(where: { $0.representedElementKind == UICollectionElementKindSectionHeader})
            {
                var frame = attr.frame
                frame.size.height = max(0, headerReferenceSize.height + fabs(offset.y))
                frame.origin.y += offset.y
                attr.frame = frame
            }
        }
        return layoutAttrs
    }
}

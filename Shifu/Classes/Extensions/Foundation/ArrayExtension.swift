//
//  ArrayExtension.swift
//  aSong
//
//  Created by Baoli Zhai on 2019/4/19.
//  Copyright © 2019 Baoli Zhai. All rights reserved.
//

import Foundation


extension Array {
    public func get( _ index: Int, _ defaultValue:Element? = nil) -> Element? {
        var index = index;
        if index < 0{
            index = self.count + index;
        }
        return index < count && index >= 0 ? self[index] : defaultValue
    }
    
    public func spread2() -> (Element,Element)? {
        if(self.count > 1){
            return (self[0],self[1])
        }else{
            return nil
        }
    }
    
    public func spread3() -> (Element,Element,Element)? {
        if(self.count > 2){
            return (self[0],self[1],self[2])
        }else{
            return nil
        }
    }
    
    public func spread4() -> (Element,Element,Element,Element)? {
        if(self.count > 3){
            return (self[0],self[1],self[2],self[3])
        }else{
            return nil
        }
    }
    
    public func spread5() -> (Element,Element,Element,Element,Element)? {
        if(self.count > 4){
            return (self[0],self[1],self[2],self[3],self[4])
        }else{
            return nil
        }
    }

}

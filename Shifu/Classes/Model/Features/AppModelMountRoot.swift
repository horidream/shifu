//
//  File.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Foundation
import SwiftUI
import Combine

public protocol AppModelMountRoot {
  associatedtype Root
  
}

@available(iOS 13.0, *)
public extension AppModelMountRoot where Self:AppModelBase, Root:View, Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher{
  private var root: Root? {
    get{
      ext["\(type(of:self))::\(#function)"] as? Root
    }
    set{
      objectWillChange.send()
      ext["\(type(of:self))::\(#function)"] = newValue
    }
  }
  
  private var g:GeometryProxy? {
    get{
      ext["\(type(of:self))::\(#function)"] as? GeometryProxy
    }
    set{
      objectWillChange.send()
      ext["\(type(of:self))::\(#function)"] = newValue
    }
  }
  
  private func mount(_ root: Root, geometryProxy g:GeometryProxy){
    self.root = root
    self.g = g
  }
  
  
  func view(@ViewBuilder builder: @escaping()->Root)->some View{
    
    GeometryReader{ proxy in
      builder()
        .perform{ this in
          self.mount(this, geometryProxy: proxy)
        }
    }
    .environmentObject(self)
  }
  
  var vw:CGFloat{
    return g?.size.width ?? 0
  }
  var vh:CGFloat{
    return g?.size.height ?? 0
  }
  
}



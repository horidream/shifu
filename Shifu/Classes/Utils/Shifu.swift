//
//  File.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/8.
//

import UIKit

let clg = Shifu.clg(prefix: "Hori -")
class EqutableWrapper: Equatable, Identifiable{
  static func == (lhs: EqutableWrapper, rhs: EqutableWrapper) -> Bool {
    return lhs.id == rhs.id
  }
  
  
  static var globalID: UInt = 0;
  let id: UInt = {
    globalID += 1
    return globalID;
  }()
  
  var payload: Any? = nil
  
}

private class EmptyClass{
  
}
public class Shifu{
  
  public static let name = "Shifu"
  public static let bundle = Bundle(for: EmptyClass.self)
  public static var maxStitchedImageSize:CGFloat = 1000
  public struct ui{
    public static func blurView(frame:CGRect, style:UIBlurEffect.Style = .light) -> UIVisualEffectView{
      let blur = UIBlurEffect(style: style)
      let ev = UIVisualEffectView(effect: blur)
      ev.frame = frame
      return ev
    }
  }
  
  public static let namespace:String = "com.horidream.lib.shifu"
  public static var locale:Locale = .current
  
  @discardableResult public class func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) -> DispatchWorkItem {
    let q = queue ?? DispatchQueue.main
    let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    let workItem = DispatchWorkItem() { closure() }
    q.asyncAfter(deadline: t, execute: workItem)
    return workItem
  }
  
  public static func clg(prefix:String) -> ((Any...)->Void){
    
    func _clg(_ args:Any...){
      print(args.reduce(prefix, { partialResult, item in
        return "\(partialResult) \(item)"
      }))
    }
    return _clg
  }
  
  public static func escape(_ str:String)->String{
    return str.normalized
  }
  
  public static var keyWindow: UIWindow?{
    guard let scene = UIApplication.shared.connectedScenes.first,
          let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
          let window = windowSceneDelegate.window else{
            return nil
          }
    return window
  }
  
}

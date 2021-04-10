//
//  Tween.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/8.
//

import AVFoundation

fileprivate let propertyMap = [
    "scale" : "transform.scale",
    "scaleX": "transform.scale.x",
    "scaleY": "transform.scale.y",
    "rotation": "transform.rotation",
    "rotationX": "transform.rotation.x",
    "rotationY": "transform.rotation.y",
    "rotationZ": "transform.rotation.z",
    "x": "transform.translation.x",
    "y":"transform.translation.y",
    "z": "transform.translation.z",
    "position": "transform.translation",
    "alpha":"opacity"
]

fileprivate let easeMap:[String: CAMediaTimingFunction] = [
    "easeIn": CAMediaTimingFunction(name:.easeIn),
    "easeout": CAMediaTimingFunction(name:.easeOut),
    "easeInOut": CAMediaTimingFunction(name:.easeInEaseOut),
    "backIn": CAMediaTimingFunction(controlPoints: 0.5, -1, 0, 1),
    "backOut": CAMediaTimingFunction(controlPoints: 0.1, 1, 0.3, 1.3),
    "backInOut": CAMediaTimingFunction(controlPoints: 0.2, -0.6, 0, 1.4),
]

func getEase( _ dic: inout Dictionary<String, Any> )->CAMediaTimingFunction{
    let easeValue = dic.removeValue(forKey: "ease")
    let timingFunction =  easeValue as? CAMediaTimingFunction
    let easeName = easeValue as? String
    let ease = timingFunction ?? easeMap[easeName ?? "easeIn"]
    return ease ?? CAMediaTimingFunction(name:.easeIn);
}

func getDelay( _ dic: inout Dictionary<String, Any> )->Double{
    let delayValue = String(describing:dic.removeValue(forKey: "delay") ?? 0)
    return Double(delayValue) ?? 0.0
}


public class Tween{
    public static func from(_ target: CALayer, _ duration:TimeInterval , _ propertyies: Dictionary<String, Any>, to: Dictionary<String, Any> = [:]){
        var dic = propertyies
        let ease = getEase(&dic)
        let delay = getDelay(&dic)
        for key in dic.keys{
            let anime = CABasicAnimation(keyPath: propertyMap[key] ?? key)
            anime.fromValue = propertyies[key]
            if to[key] != nil{
                anime.toValue = to[key]
            }
            anime.duration = duration
            anime.timingFunction = ease
            if delay != 0 {
                anime.beginTime = target.convertTime(CACurrentMediaTime(), from: nil)
 + delay
            }
            anime.fillMode = .backwards
            target.add(anime, forKey: key)
        }
    }
    
    
    public static func staggerFrom(_ targets: [CALayer?], _ duration:TimeInterval , _ propertyies: Dictionary<String, Any>, _ step: TimeInterval = 0.08){
        var dic = propertyies
        dic["delay"] = getDelay(&dic) - step
        for target in targets.compactMap({ layer in return layer}){
            dic["delay"] = getDelay(&dic) + step;
            from(target, duration, dic)
        }
    }
}

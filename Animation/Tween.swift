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
    "position": "transform.translation"
]

fileprivate let easeMap:[String: CAMediaTimingFunction] = [
    "easeIn": CAMediaTimingFunction(name:.easeIn),
    "easeout": CAMediaTimingFunction(name:.easeOut),
    "easeInOut": CAMediaTimingFunction(name:.easeInEaseOut),
    "backIn": CAMediaTimingFunction(controlPoints: 0.5, -1, 0, 1),
    "backOut": CAMediaTimingFunction(controlPoints: 0.1, 1, 0.3, 1.3),
    "backInOut": CAMediaTimingFunction(controlPoints: 0.2, -0.6, 0, 1.4),
]

public class Tween{
    public static func from(_ target: CALayer, _ duration:TimeInterval , _ propertyies: Dictionary<String, Any>){
        var dic = propertyies
        let easeValue = dic.removeValue(forKey: "ease")
        let timingFunction =  easeValue as? CAMediaTimingFunction
        let easeName = easeValue as? String
        let ease = timingFunction ?? easeMap[easeName ?? "easeIn"]
        for key in dic.keys{
            let anime = CABasicAnimation(keyPath: propertyMap[key] ?? key)
            anime.fromValue = propertyies[key]
            anime.duration = duration
            anime.timingFunction = ease
            target.add(anime, forKey: key)
        }
    }
}

//
//  Tween.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/8.
//

import AVFoundation

fileprivate let map = [
    "scale" : "transform.scale",
    "scaleX": "transform.scale.x",
    "scaleY": "transform.scale.y",
    "rotation": "transform.rotation"
]

public class Tween{
    public static func from(_ target: CALayer, _ duration:TimeInterval , _ propertyies: Dictionary<String, Any>){
        var dic = propertyies
        let ease = dic.removeValue(forKey: "ease")  as? CAMediaTimingFunction ?? CAMediaTimingFunction(name: .easeIn)
        for key in dic.keys{
            let anime = CABasicAnimation(keyPath: map[key] ?? key)
            anime.fromValue = propertyies[key]
            anime.duration = duration
            anime.timingFunction = ease
            target.add(anime, forKey: key)
        }
    }
}

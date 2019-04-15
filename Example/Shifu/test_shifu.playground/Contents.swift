//: Playground - noun: a place where people can play

import UIKit
import Shifu
import RxSwift
import RxCocoa


enum Settings:Int{
    case abmark, bookmark
    var description:String{
        return String(String(reflecting: self).split(separator: ".").last ?? "")
    }
}
var d:[Settings: Int] = [.abmark: 11, .bookmark:12]

print(d.keys.sorted{ $0.rawValue < $1.rawValue}.map{ [$0.description: d[$0]!]})







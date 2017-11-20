//: Playground - noun: a place where people can play

import UIKit
import Shifu

var s = "file:///var/mobile/Containers/Data/Application/F1C402B0-FBE4-402E-8C4D-730826B60D90/Documents/Documents/Inbox/Chapter%2001%20-%20The%20Boy%20Who%20Lived.mp3"

let s1 = "file:///var/mobile/Containers/Data/Application/F1C402B0-FBE4-402E-8C4D-730826B60D90/Documents"

let s2 = s.removeSubrange(s.range(of: s1)!)
print(s)




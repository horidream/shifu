//
//  Bridge.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/4/26.
//

#if os(iOS) || os(watchOS)

import UIKit


#elseif os(OSX)

import Cocoa
public typealias UIFont=NSFont
public typealias UIColor=NSColor
public typealias UIViewController=NSViewController
public typealias UIView=NSView

#endif

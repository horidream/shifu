//
//  ShifuWebViewAction.swift
//  Shifu
//
//  Created by Baoli Zhai on 2024/6/29.
//

import Foundation
import WebKit

public enum ShifuWebViewAction{
    case snapshot(WKSnapshotConfiguration? = nil, SnapshotTarget = .clipboard(.jpg))
}

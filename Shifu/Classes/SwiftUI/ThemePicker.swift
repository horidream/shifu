//
//  ThemePicker.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/2.
//

import SwiftUI

public struct ThemePicker: View {
    @StateObject var colorManager = ColorSchemeMananger()
    public init () {}
    public var body: some View {
        Picker("", selection: $colorManager.colorScheme){
            Text("Light").tag(ColorSchemeMananger.ColorScheme.light)
            Text("Dark").tag(ColorSchemeMananger.ColorScheme.dark)
            Text("System").tag(ColorSchemeMananger.ColorScheme.unspecified)
        }
        .pickerStyle(.segmented)
        .onAppear(){
            colorManager.applyColorScheme()
        }
    }
}



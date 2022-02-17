//
//  ReactiveExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/17.
//

import SwiftUI

public extension Binding {
    func safe<T>(default: T) -> Binding<T> where Value == Optional<T> {
        .init {
            self.wrappedValue ?? `default`
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }
}

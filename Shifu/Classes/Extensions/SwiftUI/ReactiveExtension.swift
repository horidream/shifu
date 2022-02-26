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

@available(iOS 13.0, *)
public prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

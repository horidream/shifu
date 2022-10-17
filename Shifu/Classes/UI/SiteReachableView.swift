//
//  SiteReachableView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/17.
//

import SwiftUI

public struct SiteReachableView<Content: View, FallbackContent: View>: View {
    @StateObject var siteReachable:SiteRechableChecking
    let viewBuilder:()-> Content
    let fallbackViewBuilder: ()->FallbackContent
    public init(sites: [String], @ViewBuilder viewBuilder: @escaping () -> Content, @ViewBuilder fallbackViewBuilder: @escaping () -> FallbackContent) {
        _siteReachable = StateObject(wrappedValue:  SiteRechableChecking(sites: sites))
        self.viewBuilder = viewBuilder
        self.fallbackViewBuilder = fallbackViewBuilder
    }
    public var body: some View {
        Group{
            if siteReachable.isAvailable {
                viewBuilder()
            } else {
                fallbackViewBuilder()
            }
        }.onAppear{
            siteReachable.check()
        }
    }
}


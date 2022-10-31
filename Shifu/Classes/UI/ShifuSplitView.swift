//
//  SwiftUIView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/30.
//

import SwiftUI

public struct ShifuSplitView<Value: Hashable, Master: View, Detail: View>: View {
    public class Config: UIWrapperConfig {
        @Published public var navigationTitle: Text?
        @Published public var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode?
        @Published public var navigationBarHidden: (Bool?, Bool?)?
    }
    var master: (Value)->Master
    var detail: (Value?)->Detail
    @Binding var data: Array<Value>
    @State var selected: Value?
    @ObservedObject var config = Config()
    public init(data: Binding<Array<Value>>, @ViewBuilder master: @escaping (Value) -> Master, @ViewBuilder detail: @escaping (Value?) -> Detail, config customizeConfig: ((Config)->Void)? = nil){
        _data = data
        self.master = master
        self.detail = detail
        customizeConfig?(self.config)
    }
    
    public var body: some View {
        if #available(iOS 16, *) {
            if config.forceLegacy {
                LegacySplitView
            } else {
                NavigationSplitView{
                    List($data, id: \.self, selection: $selected) { $i in
                        master(i)
                    }
                    .if(config.navigationTitle != nil) {
                        $0.navigationTitle(config.navigationTitle ?? Text(""))
                    }
                    .if(config.navigationBarTitleDisplayMode != nil){
                        $0.navigationBarTitleDisplayMode(config.navigationBarTitleDisplayMode ?? .inline)
                    }
                    .if(config.navigationBarHidden?.0 != nil){
                        $0.navigationBarHidden(config.navigationBarHidden?.0 ?? false)
                    }
                } detail: {
                    detail(selected)
                        .if(config.navigationBarHidden?.1 != nil){
                            $0.navigationBarHidden(config.navigationBarHidden?.1 ?? false)
                        }
                }
                .navigationSplitViewStyle(.balanced)
            }
        } else {
            LegacySplitView
        }

    }
    
    var LegacySplitView: some View {
        return NavigationView{
            List($data, id: \.self, selection: $selected) { $i in
                NavigationLink{
                    detail(selected)
                } label: {
                    master(i)
                }
            }
            .if(config.navigationTitle != nil) {
                $0.navigationTitle(config.navigationTitle ?? Text(""))
            }
            .if(config.navigationBarTitleDisplayMode != nil){
                $0.navigationBarTitleDisplayMode(config.navigationBarTitleDisplayMode ?? .inline)
            }
            .if(config.navigationBarHidden?.0 != nil){
                $0.navigationBarHidden(config.navigationBarHidden?.0 ?? false)
            }
            detail(selected)
                .if(config.navigationBarHidden?.1 != nil){
                    $0.navigationBarHidden(config.navigationBarHidden?.1 ?? false)
                }
        }
    }
}



struct SplitViewController: UIViewControllerRepresentable {
    var viewControllers: [UIViewController]
    @Environment(\.splitViewPreferredDisplayMode) var preferredDisplayMode: UISplitViewController.DisplayMode
    
    func makeUIViewController(context: Context) -> UISplitViewController {
        return UISplitViewController()
    }
    
    func updateUIViewController(_ splitController: UISplitViewController, context: Context) {
        splitController.preferredDisplayMode = preferredDisplayMode
        splitController.viewControllers = viewControllers
    }
}

struct PreferredDisplayModeKey : EnvironmentKey {
    static var defaultValue: UISplitViewController.DisplayMode = .automatic
}

extension EnvironmentValues {
    var splitViewPreferredDisplayMode: UISplitViewController.DisplayMode {
        get { self[PreferredDisplayModeKey.self] }
        set { self[PreferredDisplayModeKey.self] = newValue }
    }
}

extension View {
    /// Sets the preferred display mode for SplitView within the environment of self.
    func splitViewPreferredDisplayMode(_ mode: UISplitViewController.DisplayMode) -> some View {
        self.environment(\.splitViewPreferredDisplayMode, mode)
    }
}

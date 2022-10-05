//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import UniformTypeIdentifiers
import CoreServices
import Combine

struct Sandbox: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ThemedColor(light: .black, dark: .white) var foregroundColor
    @ThemedColor(light: .white, dark: .black) var backgroundColor
    @State var item = with(PreviewItem()){
        $0.previewItemURL = "\(Shifu.bundle.bundleIdentifier!)@web/icon.png".url
    }
    var body: some View {
        Preview(item: $item)
            .overlay{
                Color.white.opacity(0.03)
            }
            .onTapGesture {
                clg("tapping")
                item = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/example.md".url)
            }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        let item = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/example.md".url)
//        let p = Person(firstName: "Baoli", lastName: "Zhai", age: 40)
//        if let data = try? JSONEncoder().encode(item){
//            clg(String(data: data, encoding: .utf8))
//        }
        clg(item.stringify()?.parse(to: PreviewItem.self))
    }
}

import QuickLook

class PreviewItem: NSObject, QLPreviewItem, Codable{
    var previewItemURL: URL?
    var typeIdentifier: String?
    var previewItemTitle:String?
    init(_ previewItemURL: URL? = nil, typeIdentifier: String? = nil, previewItemTitle: String? = nil) {
        self.previewItemURL = previewItemURL
        self.typeIdentifier = typeIdentifier ?? previewItemURL?.typeIdentifier
        self.previewItemTitle = previewItemTitle
    }
    enum CodingKeys: String, CodingKey {
        case previewItemURL, typeIdentifier, previewItemTitle
    }
}

struct Preview: UIViewControllerRepresentable {
    @Binding var item: PreviewItem
    func makeUIViewController(context: Context) -> UINavigationController {
        let previewVC = QLPreviewController()
        previewVC.delegate = context.coordinator
        previewVC.dataSource = context.coordinator
        return UINavigationController(rootViewController: previewVC)
    }
    
    func updateUIViewController(_ navi: UINavigationController, context: Context) {
        context.coordinator.item = item
        if let previewVC = navi.children.first as? QLPreviewController{
            previewVC.reloadData()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject,
                       QLPreviewControllerDataSource,
                       QLPreviewControllerDelegate,
                       UIPopoverPresentationControllerDelegate{
        var item: PreviewItem?
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return item ?? PreviewItem()
        }
        
        
    }
}




// 不需要写 encode(with:) 和 init(coder:) 的协议方法
// 因为协议扩展 extension Codable 中提供了默认实现
class Person: NSObject, Codable {
    var firstName: String
    var lastName: String
    var age: Int
    
    // 如果定义一个实例Person，打印结果将是这里定义的描述字符串
    override var description: String {
        return "\(self.firstName) \(self.lastName) \(age)"
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}



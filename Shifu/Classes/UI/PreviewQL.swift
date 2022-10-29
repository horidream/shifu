//
//  PreviewQL.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/16.
//

import Foundation
import SwiftUI
import Combine
import Shifu
import UniformTypeIdentifiers
import QuickLook

public struct PreviewQL: UIViewControllerRepresentable {
    @Binding var item:PreviewItem?
    let config: Preview.Config
    
    public init(item: Binding<PreviewItem?>, config: Preview.Config = .init()) {
        _item = item
        self.config = config
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let navi =  UINavigationController(rootViewController: with(QLPreviewController()){
            $0.dataSource = context.coordinator
            $0.delegate = context.coordinator
        })
        navi.delegate = context.coordinator
        context.coordinator.item.sink { item in
            if self.item != item {
                self.item = item
            }
        }.retainSingleton()
        return navi
    }
    
    public func updateUIViewController(_ navi: UINavigationController, context: Context) {
        guard context.coordinator.item.value != item else {  return }
        context.coordinator.item.value = item
        delay(0){
            (navi.topViewController as? QLPreviewController)?.reloadData()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(item: item, config: config)
    }
    
    public class Coordinator: NSObject,
                              QLPreviewControllerDataSource,
                              QLPreviewControllerDelegate, UINavigationControllerDelegate{
        var item: CurrentValueSubject<PreviewItem?, Never>
        var config: Preview.Config
        init(item: PreviewItem?, config: Preview.Config) {
            self.item = CurrentValueSubject<PreviewItem?, Never>(item)
            self.config = config
        }
        
        public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//            navigationController.setNavigationBarHidden(true, animated: true)
        }
        public func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
            return .createCopy
        }
        
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return item.value ?? PreviewItem(previewItemTitle: localized("No Content"))
        }
        
        public func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
            guard item.value != nil else { return }
            if let data = try? Data(contentsOf: modifiedContentsURL), let type = item.value?.typeIdentifier ?? modifiedContentsURL.typeIdentifier,
               let uttype = UTType(type)
            {
                item.value = data.previewItem(for: uttype)
                if config.shouldAutoUpdatePasteboard {
                    pb.setData(data,  forPasteboardType: type)
                }
            }
        }
        
        
    }
}


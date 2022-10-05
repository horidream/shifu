//
//  Preview.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/5.
//

import Foundation
import SwiftUI
import Combine
import Shifu
import QuickLook

public class PreviewItem: NSObject, QLPreviewItem, Codable{
    public let previewItemURL: URL?
    public let typeIdentifier: String?
    public var previewItemTitle:String? {
        return _previewItemTitle
    }
    private let _previewItemTitle: String?
    public init(_ previewItemURL: URL? = nil, typeIdentifier: String? = nil, previewItemTitle: String? = "Preview") {
        self.previewItemURL = previewItemURL
        self.typeIdentifier = typeIdentifier ?? previewItemURL?.typeIdentifier
        self._previewItemTitle = previewItemTitle
    }
    enum CodingKeys: String, CodingKey {
        case previewItemURL, typeIdentifier, _previewItemTitle
    }
}

public struct Preview: UIViewControllerRepresentable {
    @Binding var item: PreviewItem
    public init(item: Binding<PreviewItem>) {
        _item = item
    }
    public func makeUIViewController(context: Context) -> UINavigationController {
        return UINavigationController()
    }
    
    public func updateUIViewController(_ navi: UINavigationController, context: Context) {
        guard item != context.coordinator.item else { return }
        context.coordinator.item = item
        if let identifier = item.typeIdentifier, let type = UTType(identifier), type.conforms(to: .text){
            let textVC = TextEditor(text: item.previewItemURL?.content ?? "")
            textVC.delegate = context.coordinator
            navi.viewControllers = [textVC]
        } else {
            let previewVC = QLPreviewController()
            previewVC.delegate = context.coordinator
            previewVC.dataSource = context.coordinator
            navi.viewControllers = [previewVC]
        }

    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public class Coordinator: NSObject,
                              QLPreviewControllerDataSource,
                              QLPreviewControllerDelegate,
                              UITextViewDelegate,
                              UIPopoverPresentationControllerDelegate {
        var item: PreviewItem?
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        public func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
            return .createCopy
            return .createCopy
        }
        
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return item ?? PreviewItem()
        }
        
        public func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
            if let data = try? Data(contentsOf: modifiedContentsURL), let type = item?.typeIdentifier ?? modifiedContentsURL.typeIdentifier
            {
                item = PreviewItem(modifiedContentsURL)
                UIPasteboard.general.setData(data,  forPasteboardType: type)
            }
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            textView.associatedViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icons.image(.check, size: 25), closure: { btn in
                textView.endEditing(true)
            })
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {

            if let data = textView.text.data(using: .utf8) {
                let type = UTType.plainText
                item = PreviewItem(data.previewURL(for: type))
                UIPasteboard.general.setData(data,  forPasteboardType: type.identifier)
            }
            textView.associatedViewController?.navigationItem.rightBarButtonItem = nil
        }
    }
}

extension UITextView {
    var associatedViewController: UIViewController? {
        return self.layer.value(forKey: "associatedViewController") as? UIViewController
    }
}

class TextEditor: UIViewController{
    var text: String
    let textView = UITextView(frame: .zero)
    var delegate: UITextViewDelegate? {
        get {
            return textView.delegate
        }
        set {
            textView.delegate = newValue
        }
    }
    
    override func loadView() {
        super.loadView()
        textView.text = text
        textView.layer.setValue(self, forKey: "associatedViewController")
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.quickMargin(0)
    }
    
    deinit{
        textView.layer.setValue(nil, forKey: "associatedViewController")
    }
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.title = "Preview"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

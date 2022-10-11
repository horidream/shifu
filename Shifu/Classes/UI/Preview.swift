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
    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? PreviewItem {
            return previewItemURL == other.previewItemURL
        }
        return false
    }
    public let previewItemURL: URL?
    public let typeIdentifier: String?
    public var previewItemTitle:String? {
        return _previewItemTitle
    }
    public var data: Data? {
        get{
            _data = _data ?? previewItemURL?.data
            return _data
        }
    }
    private var _data:Data?
    private let _previewItemTitle: String?
    public init(_ previewItemURL: URL? = nil, typeIdentifier: String? = nil, previewItemTitle: String? = nil) {
        self.previewItemURL = previewItemURL
        self.typeIdentifier = typeIdentifier ?? previewItemURL?.typeIdentifier
        self._previewItemTitle = previewItemTitle ??
        (previewItemURL == nil ? localized("No Content") : localized("Preview"))
    }
    enum CodingKeys: String, CodingKey {
        case previewItemURL, typeIdentifier, _previewItemTitle = "previewItemTitle"
    }
}

public struct Preview: UIViewControllerRepresentable {
    public class Config {
        public var shouldAutoUpdatePasteboard:Bool = true
        public init() { }
    }
    @Binding var item: PreviewItem?
    @State var pinned:Bool = false
    var config: Config
    public init(item: Binding<PreviewItem?>, config: Config = Config()) {
        _item = item
        self.config = config
    }
    public func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.item
            .sink { item in
                self.item = item
            }
            .retain(overwrite: true)
        return UINavigationController()
    }
    
    public func updateUIViewController(_ navi: UINavigationController, context: Context) {
        if item != context.coordinator.item.value, !pinned {
            context.coordinator.item.value = item
            if let identifier = item?.typeIdentifier, let type = UTType(identifier), type.conforms(to: .text),
               let text = item?.previewItemURL?.content
            {
                if let preview = navi.viewControllers.first as? QLPreviewController {
                    preview.reloadData()
                }
                let textVC = TextEditor(text: text)
                textVC.title = item?.previewItemTitle
                textVC.delegate = context.coordinator
                navi.viewControllers = [textVC]
            } else {
                let previewVC = QLPreviewController()
                previewVC.delegate = context.coordinator
                previewVC.dataSource = context.coordinator
                navi.viewControllers = [previewVC]
            }
            
            if let layer = navi.topViewController?.view.layer{
                Tween.from(layer , 0.3, ["scale": 0.92, "alpha": 0], to:["scale": 1, "alpha": 1])
            }
        }

        if item?.data != nil {
            navi.viewControllers.first?.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: Icons.image(.trash_fa, size: 20), closure: { btn in
                item = nil
                if config.shouldAutoUpdatePasteboard {
                    pb.items = []
                }
            }), UIBarButtonItem(image: Icons.image(pinned ? .pinFill : .pin, size: 16), closure: { btn in
                pinned.toggle()
            })]
        } else {
            navi.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.image(.plus_fa, size: 20), closure: { btn in
                item = PreviewItem("".data(using: .utf8)?.previewURL(for: .plainText), previewItemTitle: localized("New Text"))
            })
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(config: config)
    }
    
    public class Coordinator: NSObject,
                              QLPreviewControllerDataSource,
                              QLPreviewControllerDelegate,
                              UITextViewDelegate,
                              UIPopoverPresentationControllerDelegate {
        
        var item: CurrentValueSubject<PreviewItem?, Never>
        var editingItem:PreviewItem?
        var config: Config
        
        init(item: PreviewItem? = nil, config: Config) {
            self.item = CurrentValueSubject<PreviewItem?, Never>(item)
            self.config = config
        }
        
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            item.value?.previewItemURL != nil ? 1 : 0
        }
        
        public func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
            return .createCopy
        }
        
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return item.value ?? PreviewItem(previewItemTitle: localized("No Content"))
        }
        
        public func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
            guard item.value != nil else { return }
            if let data = try? Data(contentsOf: modifiedContentsURL), let type = item.value?.typeIdentifier ?? modifiedContentsURL.typeIdentifier
            {
                item.value = PreviewItem(modifiedContentsURL)
                controller.reloadData()
                if config.shouldAutoUpdatePasteboard {
                    pb.setData(data,  forPasteboardType: type)
                }
            }
        }
//        public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//            textView.is
//        }
        public func textViewDidBeginEditing(_ textView: UITextView) {
            (textView.associatedViewController as? TextEditor)?.setPlaceHolderVisible(false)
            textView.associatedViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icons.image(.check, size: 20), closure: { btn in
                textView.endEditing(true)
            })
            editingItem = item.value
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            // if the editing item has been changed , we should not update the preview item. 
            guard item.value == editingItem else { return }
            if let data = textView.text.data(using: .utf8) {
                let type = UTType.plainText
                item.value = PreviewItem(data.previewURL(for: type))
                if config.shouldAutoUpdatePasteboard {
                    pb.setData(data,  forPasteboardType: type.identifier)
                }
            }
            textView.associatedViewController?.navigationItem.title = localized("Preview")
            textView.associatedViewController?.navigationItem.rightBarButtonItem = nil
            (textView.associatedViewController as? TextEditor)?.setPlaceHolderVisible(textView.text.trimmingCharacters(in: .whitespaces).count == 0)
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
    let placeHolder = UILabel(frame: .zero)
    var delegate: UITextViewDelegate? {
        get {
            return textView.delegate
        }
        set {
            textView.delegate = newValue
        }
    }
    
    var isTextTooLong:Bool {
        text.count > 2048
    }
    override func loadView() {
        super.loadView()
        textView.text = text.substr(0, 2048)
        textView.layer.setValue(self, forKey: "associatedViewController")
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = !isTextTooLong
        textView.quickMargin(8)
        
        placeHolder.text = localized("Touch to start editing")
        view.addSubview(placeHolder)
        placeHolder.font = UIFont.systemFont(ofSize: 18)
        placeHolder.textColor = .lightGray
        placeHolder.alpha = text.trimmingCharacters(in: .whitespaces).count == 0 ? 1 : 0
        placeHolder.quickAlign(1, 8, 12)
        
    }
    
    func setPlaceHolderVisible(_ visible: Bool){
        placeHolder.alpha = visible ? 1 : 0
    }
    
    deinit{
        textView.layer.setValue(nil, forKey: "associatedViewController")
    }
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.title = localized("Preview")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

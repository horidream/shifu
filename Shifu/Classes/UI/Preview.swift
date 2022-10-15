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
        if super.isEqual(object) {
            return true
        }
        if let other = object as? PreviewItem {
            return previewItemURL == other.previewItemURL
        }
        return false
    }
    
    
    
    public let previewItemURL: URL?
    public let typeIdentifier: String?
    public var isLocked: Bool = false
    public var previewItemTitle:String? {
        get {
            if let _previewItemTitle {
                return _previewItemTitle + (isLocked ? localized("(locked)"): "")
            }
            return nil
        }
        set {
            _previewItemTitle = newValue
        }
    }
    public var data: Data? {
        get{
            _data = _data ?? previewItemURL?.data
            return _data
        }
    }
    private var _data:Data?
    private var _previewItemTitle: String?
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
        public var onCreateNew:((UINavigationController)->Void)?
        public init() { }
    }
    @Binding var item: PreviewItem?
    @State var innernalPinned: Bool
    @Binding var pinned:Bool
    let isControlledInteranally: Bool
    //    @State var refresher: PassthroughSubject<Void, Never>
    var calculatedPinned: Bool {
        get {
            isControlledInteranally ? innernalPinned : pinned
        }
    }
    func setCalculatedPinned(_ value: Bool, context: Context) {
        if isControlledInteranally {
            innernalPinned = value
        } else {
            pinned = value
        }
        item?.isLocked = value
        context.coordinator.currentVC?.title =  context.coordinator.item.value?.previewItemTitle
    }
    var config: Config
    public init(item: Binding<PreviewItem?>, pinned: Binding<Bool>? = nil, config: Config = Config()) {
        _item = item
        _pinned = pinned ?? .constant(false)
        _innernalPinned = State(initialValue: false)
        //        _refresher = State(initialValue: PassthroughSubject<Void, Never>())
        isControlledInteranally = pinned == nil
        self.config = config
        
    }
    public func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.item.removeDuplicates()
            .sink { item in
//                self.item = item
            }
            .retain(overwrite: true)
        let navi = UINavigationController()
        return navi
    }
    
    public func updateUIViewController(_ navi: UINavigationController, context: Context) {
        if !calculatedPinned{
            context.coordinator.item.value = item
        }
        if let identifier = item?.typeIdentifier, let type = UTType(identifier), type.conforms(to: .text),
           let text = item?.previewItemURL?.content
        {
            if let preview = navi.topViewController as? QLPreviewController {
                preview.reloadData()
            }
            let textVC = TextEditor(text: text)
            textVC.title = context.coordinator.item.value?.previewItemTitle
            textVC.delegate = context.coordinator
            navi.viewControllers = [textVC]
            context.coordinator.currentVC = textVC
        } else {
            let previewVC = QLPreviewController()
            previewVC.delegate = context.coordinator
            previewVC.dataSource = context.coordinator
            navi.viewControllers = [previewVC]
            context.coordinator.currentVC = previewVC
            if let layer = navi.topViewController?.view.layer{
                Tween.from(layer , 0.3, ["scale": 0.95, "alpha": 0], to:["scale": 1, "alpha": 1])
            }
        }
        
        if item?.data != nil {
            let shouldPinned = calculatedPinned
            context.coordinator.currentVC?.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: Icons.image(.trash_fa, size: 20), closure: { btn in
                setCalculatedPinned(false, context: context)
                item = nil
                if config.shouldAutoUpdatePasteboard {
                    pb.items = []
                }
            }), UIBarButtonItem(image: Icons.image( calculatedPinned ? .pinFill : .pin, size: 16), closure: { btn in
                setCalculatedPinned(!calculatedPinned, context: context)
            })]
            
        } else {
            if let top = navi.topViewController {
                top.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.image(.plus_fa, size: 20), closure: { btn in
                    if let callback = self.config.onCreateNew {
                        callback(navi)
                    }else {
                        item = PreviewItem("".data(using: .utf8)?.previewURL(for: .plainText), previewItemTitle: localized("New Text"))
                    }
                })
            }
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
        weak var currentVC: UIViewController?
        
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
            if let data = try? Data(contentsOf: modifiedContentsURL), let type = item.value?.typeIdentifier ?? modifiedContentsURL.typeIdentifier,
               let uttype = UTType(type)
            {
                item.value = data.previewItem(for: uttype)
                controller.reloadData()
                if config.shouldAutoUpdatePasteboard {
                    pb.setData(data,  forPasteboardType: type)
                }
            }
        }
        
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

//
//  PreviewText.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/16.
//

import Foundation
import SwiftUI
import Combine
import Shifu
import UniformTypeIdentifiers

public struct PreviewText: UIViewControllerRepresentable {
    
    @Binding var item:PreviewItem?
    let config: Preview.Config
    public init(item: Binding<PreviewItem?>, config: Preview.Config = .init()) {
        _item = item
        self.config = config
    }
    public func makeUIViewController(context: Context) -> UINavigationController {
        let navi = UINavigationController(rootViewController: with(TextEditorVC(text: item?.previewItemURL?.content ?? "")){
            $0.delegate = context.coordinator
            $0.title = item?.previewItemTitle
        })
        navi.delegate = context.coordinator
        return navi
    }
    
    public func updateUIViewController(_ navi: UINavigationController, context: Context) {
        guard context.coordinator.item.value != item else {
            navi.topViewController?.title = item?.previewItemTitle
            return
        }
        (navi.topViewController as? TextEditorVC)?.title = item?.previewItemTitle ?? ""
        (navi.topViewController as? TextEditorVC)?.text = item?.previewItemURL?.content ?? ""
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(item: item, config: config)
    }
    
    public class Coordinator: NSObject,
                              UITextViewDelegate, UINavigationControllerDelegate{
        var item: CurrentValueSubject<PreviewItem?, Never>
        var editingItem: PreviewItem?
        var config: Preview.Config
        var cancelling: Bool = false
        init(item: PreviewItem?, config: Preview.Config) {
            self.item = CurrentValueSubject<PreviewItem?, Never>(item)
            self.config = config
        }
       
        public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//            navigationController.setNavigationBarHidden(true, animated: false)
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            (textView.associatedViewController as? TextEditorVC)?.setPlaceHolderVisible(false)
            cancelling = false
            textView.associatedViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icons.image(.check, size: 20), closure: { btn in
                textView.endEditing(true)
            })
            textView.associatedViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.image(.xmark_fa, size: 20), closure: { btn in
                self.cancelling = true
                textView.endEditing(true)
            })
            editingItem = item.value
        }
        

        
        public func textViewDidEndEditing(_ textView: UITextView) {
            // if the editing item has been changed , we should not update the preview item.
            textView.associatedViewController?.navigationItem.rightBarButtonItem = nil
            textView.associatedViewController?.navigationItem.leftBarButtonItem = nil
            guard item.value == editingItem else { return }
            guard !cancelling else {
                textView.text = editingItem?.data?.utf8String ?? ""
                return
            }
            if let data = textView.text.data(using: .utf8) {
                let type = UTType.plainText
                item.value = PreviewItem(data.previewURL(for: type))
                if config.shouldAutoUpdatePasteboard {
                    pb.setData(data,  forPasteboardType: type.identifier)
                }
            }
            textView.associatedViewController?.navigationItem.title = localized("Preview")
            textView.associatedViewController?.navigationItem.rightBarButtonItem = nil
            textView.associatedViewController?.navigationItem.leftBarButtonItem = nil
            (textView.associatedViewController as? TextEditorVC)?.setPlaceHolderVisible(textView.text.trimmingCharacters(in: .whitespaces).count == 0)
        }
        
    }
}


public extension UITextView {
    var associatedViewController: UIViewController? {
        return self.layer.value(forKey: "associatedViewController") as? UIViewController
    }
}

class TextEditorVC: UIViewController{
    var text: String {
        didSet{
            textView.text = text.substr(0, 2048)
        }
    }
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


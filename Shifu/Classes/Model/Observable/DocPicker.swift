//
//  ObservableDocPicker.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/3.
//

import SwiftUI
import Combine
import Shifu
import UniformTypeIdentifiers

public class DocPicker: UIDocumentPickerViewController, UIDocumentPickerDelegate, ObservableObject{
    @Published public var selectedURL: URL?
    convenience init(){
        self.init(forOpeningContentTypes: [UTType.audio, UTType.movie])
        self.delegate = self
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var myurl = urls.first
        _ = myurl?.startAccessingSecurityScopedResource()
        myurl?.resolveSymlinksInPath()
        selectedURL = myurl
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        clg("canceled")
    }
}

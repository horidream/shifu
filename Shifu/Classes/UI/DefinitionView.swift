//
//  DefinitionView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2023/6/25.
//

import SwiftUI

public struct DefinitionView: UIViewControllerRepresentable {
    let word: String
    
    public init(word: String) {
        self.word = word
    }
    
    public func makeUIViewController(context: Context) -> UIReferenceLibraryViewController {
        let vc = UIReferenceLibraryViewController(term: word)
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: Context) {
        // no op
    }
}

//
//  UTTypeExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/9/15.
//

import Foundation
import UniformTypeIdentifiers


public extension UTType{
    static let doc: UTType = .init("com.microsoft.word.doc")!
    static let docx: UTType = .init("org.openxmlformats.wordprocessingml.document")!
    static let excel: UTType = .init("com.microsoft.excel.xls")!
    static let xlsx: UTType = .init("org.openxmlformats.spreadsheetml.sheet")!
}

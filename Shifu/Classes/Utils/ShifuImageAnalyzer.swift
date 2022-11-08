//
//  ShifuImageAnalyzer.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/11/8.
//

import VisionKit

public class ShifuImageAnalyzer {
    public enum ImageAnalyzerError: Error {
        case notSupported, emptyImage, wrong(Error)
    }

    public static var isSupported: Bool {
        if #available(iOS 16, *) {
            return ImageAnalyzer.isSupported
        } else {
            return false
        }
    }

    public static var supportedLanguages: [String] {
        if #available(iOS 16, *) {
            return ImageAnalyzer.supportedTextRecognitionLanguages
        } else {
            return []
        }
    }

    public static func scan(_ image: UIImage?, locales: [String]? = nil, callback: @escaping (String?, ImageAnalyzerError?) -> Void) {

        guard let image else {
            callback(nil, .emptyImage)
            return
        }
        guard isSupported else {
            callback(nil, .notSupported)
            return
        }
        Task {
            if #available(iOS 16, *) {
                do {
                    let analyzer = ImageAnalyzer()
                    var config = ImageAnalyzer.Configuration([.text])
                    if let locales {
                        config.locales = locales
                    }
                    let analysis = try await analyzer.analyze(image, configuration: config)
                    callback(analysis.transcript, nil)

                } catch {
                    callback(nil, .wrong(error))
                }
            } else {
                callback(nil, .notSupported)
            }

        }
    }
}

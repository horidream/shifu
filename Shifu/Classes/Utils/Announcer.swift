//
//  Announcer.swift
//  Shifu
//
//  Created by Baoli Zhai on 2/23/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

import AVFoundation
import Combine

public enum AnnouncerError:Error{
    case announcerError(String)
}

@available(iOS 13.0, *)
public class Announcer: NSObject{
    
    let synthesizer = AVSpeechSynthesizer()
    let language:String
    var output: AVAudioFile?
    let rate:Float = 0.38
    public var currentUtterance:AVSpeechUtterance?
    public let isPlaying: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
        
    public init(_ language:String = "en-US"){
        self.language = language
        super.init()
        synthesizer.delegate = self
    }
    
    public func say(string:String){
        let utterance = AVSpeechUtterance(string: string.toSpeechString())
        utterance.rate = rate
        utterance.voice = preferredLanguage
        currentUtterance = utterance
        synthesizer.speak(utterance)
    }
    
    private var preferredLanguage:AVSpeechSynthesisVoice?{
        if(self.language == "zh-Hans"){
            return AVSpeechSynthesisVoice(language: "zh-Hant")
        }else{
            return AVSpeechSynthesisVoice(language: self.language)
        }
    }
    
    public func stop(){
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @discardableResult public func write(string:String, url:URL)->Future<URL, Error>{
        
        let utterance = AVSpeechUtterance(string: string.toSpeechString())
        let tempURL = FileManager.url.temp.appendingPathComponent("temp.caf")
        utterance.voice = preferredLanguage
        utterance.rate = rate
        currentUtterance = utterance
        self.output = nil
        return Future<URL, Error> { (promise) in
            self.synthesizer.write(utterance) { (buffer) in
                guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
                    promise(.failure(AnnouncerError.announcerError("unknown buffer type: \(buffer)")))
                    return
                }
                if pcmBuffer.frameLength == 0 {
                    try? FileManager.default.removeItem(atPath: url.path)
                    let asset = AVAsset(url: tempURL)
                    if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
                        exporter.outputFileType = AVFileType.m4a
                        exporter.outputURL = url
                        exporter.shouldOptimizeForNetworkUse = true
                        exporter.exportAsynchronously(completionHandler: {
                            switch exporter.status {
                            case  AVAssetExportSession.Status.failed:
                                promise(.failure(AnnouncerError.announcerError("convert failed")))
                                
                            case AVAssetExportSession.Status.cancelled:
                                promise(.failure(AnnouncerError.announcerError("convert canceld")))
                            default:
                                promise(.success(url))
                            }
                        })
                    } else {
                        promise(.failure(AnnouncerError.announcerError("cannot create AVAssetExportSession for asset \(asset)")))
                    }
                } else {
                    // append buffer to file
                    if self.output == nil {
                        do{
                            self.output = try AVAudioFile(
                                forWriting: tempURL,
                                settings: pcmBuffer.format.settings,
                                commonFormat: .pcmFormatInt16,
                                interleaved: false)
                        }catch{
                            promise(.failure(error))
                        }
                    }
                    do{
                        try self.output?.write(from: pcmBuffer)
                    }catch{
                        promise(.failure(error))
                    }
                    
                }
            }
        }
    }
}

public extension String{
    func toSpeechString()->Self{
        return self.replacingOccurrences(of: "\n", with: ":")
    }
}

@available(iOS 13.0, *)
extension Announcer: AVSpeechSynthesizerDelegate{
    
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying.send(false)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlaying.send(false)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPlaying.send(false)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlaying.send(true)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isPlaying.send(true)
    }
}



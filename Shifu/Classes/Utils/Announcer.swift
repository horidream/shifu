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
  static var shared = Announcer()
  public static func say(_ string:String, wait:Bool = false,  locale:Locale = .current){
    if(!wait){
      shared.stop()
    }
    shared.say(string: string, language: locale.languageCode)
  }
  
  let synthesizer = AVSpeechSynthesizer()
  var language:String{
    didSet{
      self.preferredLanguage = AVSpeechSynthesisVoice(language: language)
    }
  }
  var output: AVAudioFile?
  let rate:Float = 0.5
  var preferredLanguage:AVSpeechSynthesisVoice?
  public var currentUtterance:AVSpeechUtterance?
  private let _isPlaying: PassthroughSubject<Bool, Never> = PassthroughSubject()
  public var isPlaying:AnyPublisher<Bool,Never>{
    return _isPlaying.eraseToAnyPublisher()
  }
  
  public init(_ language:String = "en-US"){
    self.language = language
    super.init()
    synthesizer.delegate = self
  }
  
  public func say(string:String, language:String? = nil){
    _isPlaying.send(true)
    DispatchQueue.global(qos: .userInteractive).async {
      let utterance = AVSpeechUtterance(string: string.toSpeechString())
      utterance.rate = self.rate
      utterance.voice = language == nil ? self.preferredLanguage :
      AVSpeechSynthesisVoice(language: language)
      self.currentUtterance = utterance
      self.synthesizer.speak(utterance)
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
    _isPlaying.send(false)
  }
  
  public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    _isPlaying.send(false)
  }
  
  public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    _isPlaying.send(false)
  }
  
  public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    _isPlaying.send(true)
  }
  
  public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
    _isPlaying.send(true)
  }
}



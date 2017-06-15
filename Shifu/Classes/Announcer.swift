//
//  Announcer.swift
//  Shifu
//
//  Created by Baoli Zhai on 2/23/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

import AVFoundation


public class Announcer{
    
    let synthesizer = AVSpeechSynthesizer()
    let language:String
    
    
    public init(_ language:String = "en-US"){
        self.language = language
    }
    
    public func say(string:String){
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        synthesizer.speak(utterance)
        
    }
}

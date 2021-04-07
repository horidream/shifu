//
//  HomeView.swift
//  Shifu_Example
//
//  Created by Baoli Zhai on 2021/4/6.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import Combine
import Shifu
struct Person:Codable{
    let name:String
    private enum CodingKeys : String, CodingKey {
        case name = "title"
    }
}
struct HomeView: View {
    @State var name:String = "Hello"
    var body: some View {
        Text(name)
            .onAppear(){
//                print(try? JSONEncoder().encode(Person(title: "abc")))
                ShortCut.load("https://jsonplaceholder.typicode.com/todos/1") { (data) in
                    print("loaded")
                    print(data?.md5)
                }.retain("abc")
            }
    }
}



//
//  ViewController.swift
//  Shifu
//
//  Created by horidream on 03/08/2017.
//  Copyright (c) 2017 horidream. All rights reserved.
//

import UIKit
import FMDB
import Shifu

struct Person{
    var name:String
    var age: Int
   init(name :String, age: Int){
        self.name = name
        self.age = age
    }
    init(_ rst: FMResultSet){
//        self.name = rst.string(forColumn: "name")!
//        self.age =  Int(rst.int(forColumn: "age"))
    self.init(name: rst.string(forColumn: "name")!, age: Int(rst.int(forColumn: "age")))
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        super.viewDidLoad()
        print(#function)
        _ = SQLLiteManager(name: "my.db")
        
        
    }
    
    
    
}


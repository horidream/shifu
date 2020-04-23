//
//  ViewController.swift
//  Shifu
//
//  Created by horidream on 03/08/2017.
//  Copyright (c) 2017 horidream. All rights reserved.
//

import UIKit
import Shifu
import FMDB

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
        let ls = ShifuSQLite(filename: "my.db", overwritten: false)
        ls.clear(tableName: "Test")
        ls.create(tableName: "Test", schema: "name TEXT, age INTEGER")
        ls.exe("insert into Test (name, age) values(?, ?)", args: ["Baoli", 40])
        print(ls.queryInt("select count(*) from test where name=\"Baoli\""))
        let peoples = ls.querySequence("select * from Test") {
            rst->Person in
            
            return Person(rst)
        }
        
        for (n, c) in peoples.enumerated(){
            print("\(n): '\(c)'")
        }
        
    }
    
    
    
}


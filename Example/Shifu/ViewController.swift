//
//  ViewController.swift
//  Shifu
//
//  Created by horidream on 03/08/2017.
//  Copyright (c) 2017 horidream. All rights reserved.
//

import UIKit
import Shifu

struct Person{
    var name:String
    var age: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = .black
        super.viewDidLoad()
        print(#function)
        let ls = ShifuSQLite(filename: "my.db", overwritten: false)
        ls.exe("drop table if exists Test")
        ls.create(tableName: "Test", schema: "name TEXT, age INTEGER")
        ls.exe("insert into Test (name, age) values(?, ?)", args: ["Baoli", 40])
        let peoples = ls.querySquence("select * from Test") {
            rst->Person in
            let name = rst.string(forColumn: "name")!
            let age = rst.int(forColumn: "age")
            return Person(name: name, age: Int(age))
        }

        print(Array(peoples))
    }



}


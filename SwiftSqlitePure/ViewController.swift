//
//  ViewController.swift
//  SwiftSqlitePure
//
//  Created by Marcelo on 1/23/18.
//  Copyright © 2018 Marcelo Sampaio. All rights reserved.
//

import UIKit
import SQLite3


class ViewController: UIViewController {

    var db : OpaquePointer?
    var statement: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // db file path
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("sample.db")
        // open db
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("🆘 error openning database 🆘")
            return
        }
        
        print("👍 fileUrl: \(fileUrl.path)")
        
        
        // create table sql statment ///////////////////////////////////////////////////////////////
        var sql = "create table if not exists sampleTable (id integer primary key autoincrement, description text, level integer)"
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error creating table 🆘")
            return
        }
        print("👍 created table OK")
        
        // insert rows to the table /////////////////////////////////////////////////////
        sql = "insert into sampleTable (description, level) values ('portaria', 24)"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error inserting row to the table 🆘")
            return
        }
        print("👍 insert table OK")
        
        // read database content ///////////////////////////////////////////////////////////
        sql = "select id, description, level from sampleTable"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            var description = String()
            var level = String()
            
            if let cString = sqlite3_column_text(statement, 1) {
                description = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 2) {
                level = String(cString: cString)
            }
            
            print("👉 id: \(id)  description: \(description)  level: \(level) 👈")
            
            
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
            return
        }
        
        
        
        
        
        
        
        statement = nil
        
        
        // close data base ///////////////////////////////
        if sqlite3_close(db) != SQLITE_OK {
            print("🆘 error closing database 🆘")
            return
        }
        
        db = nil
        
        print("🔥 THE END 🔥")
        
    }



}


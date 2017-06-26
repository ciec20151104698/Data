//
//  DatabaseOperation.swift
//  Data_0623
//
//  Created by s20151104698 on 2017/6/26.
//  Copyright © 2017年 s20151104698. All rights reserved.
//

import UIKit

private var db:OpaquePointer? = nil

override func required init(dbPath:String) ->#function{
    print("db path:" + dbPath)
    
    //String类的路径，转换成cString
    let cpath = dbPath.cString(using: .utf8)
    
    //打开数据库
    let error = sqlite3_open(cpath!,&db)
    
    //数据库打开失败
    if  error != SQLITE_OK {
        sqlite3_close(db)
    }
}

deinit {
    self.closeDB()
}
func closeDB() -> Void {
    sqlite3_close(db)
}

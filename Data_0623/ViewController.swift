//
//  ViewController.swift
//  Data_0623
//
//  Created by s20151104698 on 2017/6/23.
//  Copyright © 2017年 s20151104698. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //var db:SQLiteDB!
    
    private var db:OpaquePointer? = nil
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    func createTable() -> Bool{
        super.viewDidLoad()
        let sql = "CREATE TABLE IF NOT EXISTS UserTable(uid INTEGER PRIMARY KEY ,username varchar(30), password varchar(30))"
        
        //执行sql语句
        let excuResult = sqlite3_exec(db, sql.cString(using: .utf8), nil, nil, nil)
        //判断是否执行成功
        if excuResult != SQLITE_OK {
            print("OKOKOKOKOKOKOK")
            return false
        }
        return true
    }
    /*override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = SQLiteDB.shared
        // 如果表还不存在则创建表
        db.execute(sql:"create table if not exists Rookie_user(uid integer primary key,username varchar(30),password varchar(30))")
        // 如果有数据则加载
        initUser()
    }*/
    // 从SQLite加载数据
    /*func  initUser(){
        let data = db.query(sql: "select * from Rookie_user")
        if data.count > 0 {
            // 获取最后一行数据显示
            let user = data[data.count - 1]
            
            userName.text = user["username"] as? String
            passWord.text = user["password"] as? String
        }
    }*/
    /*func saveUser() {
        let uname = self.userName.text!
        let mobile = self.passWord.text!
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into Rookie_user(username,password) values('\(uname)','\(mobile)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        //let result = db.execute(sql: sql)
        
        
        let result =
        print(result)
    }*/
    
    func addUser(user:Person) -> Bool {
        
        //sql语句
        let sql = "INSERT INTO UserTable(username,password) VALUES(?,?);";
        
        //sql语句转换成cString类型
        let cSql = sql.cString(using: .utf8)
        
        //sqlite3_stmt指针
        var stmt:OpaquePointer? = nil
        
        //编译
        let prepare_result = sqlite3_prepare_v2(self.db, cSql!, -1, &stmt, nil)
        
        //判断如果失败，获取失败信息
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
            return false
        }
        
        //绑定参数
        //第二个参数，索引从1开始
        //最后一个参数为函数指针
        sqlite3_bind_text(stmt, 1, user.name!.cString(using: .utf8), -1, nil)
        sqlite3_bind_text(stmt, 2, user.password!.cString(using: .utf8), -1, nil)
        
        //step执行
        let step_result = sqlite3_step(stmt)
        
        //判断执行结果
        if step_result != SQLITE_OK && step_result != SQLITE_DONE {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to execute SQL:\(sql)"
                print(msg)
            }
            return false
        }
        
        //finalize
        sqlite3_finalize(stmt)
        
        return true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveClicked(_ sender: UIButton) {
        addUser()
    }
    

}


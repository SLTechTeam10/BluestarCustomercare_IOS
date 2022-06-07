//
//  DBManager.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 28/04/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

let DBName:String = "bluestarDB"
var pathToDatabase: String!
var database: FMDatabase!

struct DBManage {
    
    enum DBError: Error {
        case fileNotWritten
        case fileDoesNotExist
    }
    
    let name:String
//    
//    var sourcePath:String? {
//        //print(Bundle.main.path(forResource: name, ofType: "db"))
//        guard let path = Bundle.main.path(forResource: name, ofType: "db") else { return .none }
//        pathToDatabase = path
//        return path
//    }
    
    var destPath:String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //pathToDatabase = (dir as NSString).appendingPathComponent("\(name).db")
        return (dir as NSString).appendingPathComponent("\(name).db")
    }
    
    

    init?(name:String) {
        
        self.name = name
        
        let fileManager = FileManager.default
        
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }
        
        if !fileManager.fileExists(atPath: destination) {
            
            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("[DBManager] Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    var sourcePath:String?{
        let path = Bundle.main.path(forResource: name, ofType: "db")
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("\(name).db")
        if(!FileManager.default.fileExists(atPath: (logsPath?.path)!)){
            do {
                print("come here")
                try FileManager.default.copyItem(atPath: path!, toPath: logsPath!.path)
                pathToDatabase = logsPath?.path
            }
            catch let error as NSError {
                print("Unable to create Database \(error.debugDescription)")
        }
        }
        return logsPath?.path
}
    
    func getValuesInDatabaseFile() -> NSDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
    
    func getMutableDatabaseFile() -> NSMutableDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
}



class DBManager: NSObject {
    
    static let shareInstance : DBManager = DBManager()
    
    fileprivate override init() {} //This prevents others from using the default '()' initializer for this class.
    
    func startDBManager() {
        if let Database = DBManage(name: DBName) {
            print("[DBManager] DBManager started")
            print("[DataBase] \(Database.getValuesInDatabaseFile())")
        }
        else{
            print("[DBManager]Cannot Start DBManager ")
        }
    }
    func getPath() -> String?{
        //let source = sourcePath
        if let srcPath = DBManage(name: DBName) {
            let mainPath = srcPath.sourcePath
            return mainPath
        }
        return nil
    }
}

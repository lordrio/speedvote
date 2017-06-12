//
//  SpeedVoteSQL.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/6/17.
//
//

import PerfectLib
import PerfectHTTP
import MySQL

let testHost = "43.255.154.110"
let testUser = "speedvote"
// PLEASE change to whatever your actual password is before running these tests
let testPassword = "12345"
let testSchema = "speedvote"

let dataMysql = MySQL()

public func SelectSQL(_ table:String, limit:Int = 1, whereStr:String? = nil) -> [[String?]]?
{
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return nil
    }
    
    defer
    {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    var query = "select * from \(table)"
    if whereStr != nil
    {
        query += " where \(whereStr!)";
    }
    
    query += " limit \(limit)"
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) &&
        dataMysql.query(statement: query)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return nil
    }
    
    //store complete result set
    let results = dataMysql.storeResults()

    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next()
    {
        resultArray.append(row)
    }
    
    return resultArray
}

public func CreateInsert(_ table:String, val:[String:Any]) -> String
{
    var columns = ""
    var values = ""
    for item in val
    {
        columns += "\(item.key),"
        if item.value is String
        {
            values += "'\(item.value)',"
        }
        else
        {
            values += "\(item.value),"
        }
    }
    
    let query = "insert into \(table)(\(columns)) values(\(values))".replacingOccurrences(of: ",)", with: ")")
    debugPrint(query)
    return query
}

public func CreateUpdate(_ table:String, val:[String:Any], whereStr:String? = nil) -> String
{
    var values = ""
    var whereClause = ""
    for item in val
    {
        values += "\(item.key)= '\(item.value)',"
    }
    
    values.remove(at: values.index(before: values.endIndex))
    
    if whereStr != nil
    {
        whereClause = "where \(whereStr!)";
    }
    
    let query = "UPDATE \(table) SET \(values) \(whereClause)".replacingOccurrences(of: ",)", with: ")")
    debugPrint(query)
    return query
}

public func InsertSQL(_ table:String, val:[String:Any])  -> [[String?]]?
{
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return nil
    }
    
    defer
    {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    var columns = ""
    var values = ""
    for item in val
    {
        columns += "\(item.key),"
        if item.value is String
        {
            values += "'\(item.value)',"
        }
        else
        {
            values += "\(item.value),"
        }
    }
    
    let query = "insert into \(table)(\(columns)) values(\(values))".replacingOccurrences(of: ",)", with: ")")
    debugPrint(query)
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) &&
        dataMysql.query(statement: query)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return nil
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next()
    {
        resultArray.append(row)
    }
    
    return resultArray
}

public func UpdateSQL(_ table:String, val:[String:Any], whereStr:String? = nil)  -> [[String?]]?
{
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return nil
    }
    
    defer
    {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    var values = ""
    var whereClause = ""
    for item in val
    {
        values += "\(item.key)= '\(item.value)',"
    }
    
    values.remove(at: values.index(before: values.endIndex))
    
    if whereStr != nil
    {
        whereClause = "where \(whereStr!)";
    }
    
    let query = "UPDATE \(table) SET \(values) \(whereClause)".replacingOccurrences(of: ",)", with: ")")
    Log.info(message: query)
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) &&
        dataMysql.query(statement: query)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return nil
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next()
    {
        resultArray.append(row)
    }
    
    return resultArray
}

public func CustomQuery(_ customStr:String) -> [[String?]]?
{
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return nil
    }
    
    defer
    {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) &&
        dataMysql.query(statement: customStr)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return nil
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next()
    {
        resultArray.append(row)
    }
    
    return resultArray
}

public func Transaction(_ startFunc:(_ sqlStore:MySQL) throws -> Bool) -> Bool
{
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return false
    }
    
    defer
    {
        debugPrint("close")
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    guard dataMysql.selectDatabase(named: testSchema)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        return false
    }
    
    // done selecting
    do
    {
        let ret = try startFunc(dataMysql)
        return ret
    }
    catch
    {
        fatalError("\(error)")
    }
    
    return true
}

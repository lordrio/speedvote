//
//  SpeedVoteSQL.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/6/17.
//
//

/*
 ===Database speedvote
 
 == Table structure for table Choices
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |event_id|bigint(20)|No|
 |title|varchar(45)|Yes|NULL
 |desc|text|Yes|NULL
 |time|date|No|
 |gps|varchar(45)|Yes|NULL
 == Dumping data for table Choices
 
 == Table structure for table Comments
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |event_id|bigint(20)|No|
 |user_id|bigint(20)|No|
 |comment|text|Yes|NULL
 |datetime|date|No|
 == Dumping data for table Comments
 
 == Table structure for table Events
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |title|varchar(45)|Yes|NULL
 |desc|text|Yes|NULL
 |user_id|bigint(20)|No|
 |choice_id|bigint(20)|No|
 |status|int(11)|No|
 == Dumping data for table Events
 
 == Table structure for table Users
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |name|varchar(45)|Yes|NULL
 == Dumping data for table Users
 
 == Table structure for table Voters
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |event_id|bigint(20)|No|
 |user_id|bigint(20)|No|
 |choice_id|bigint(20)|No|
 == Dumping data for table Voters
 
*/
import PerfectLib
import PerfectHTTP
import MySQL

let testHost = "43.255.154.110"
let testUser = "speedvote"
// PLEASE change to whatever your actual password is before running these tests
let testPassword = "12345"
let testSchema = "speedvote"

let dataMysql = MySQL()

public func SelectSQL(_ table:String, limit:Int = 1, whereStr:String? = nil)
{
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword )
        else
    {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    defer
    {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    let query = "select * from " + table + " limit " + String(limit)
    if whereStr != nil
    {
        query += " " + whereStr!;
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) &&
        dataMysql.query(statement: query)
        else
    {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next()
    {
        resultArray.append(row)
        
    }
}

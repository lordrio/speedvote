//
//  UserData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class UserData : BaseData
{
    /*
     == Table structure for table Users
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |name|varchar(45)|Yes|NULL
     == Dumping data for table Users
     */
    override var _tableName:String { get{ return "Users" } }
    
    public var id:UInt64 = 0;
    
    public var name:String = "";
    public var uuid:String = "";
    
    // experiment
    public var id$:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    public var name$:DataVar<String> = DataVar<String>("name", "")
    public var uuid$:DataVar<String> = DataVar<String>("uuid", "")
    
    override func jsonEncodedString() throws -> String {
        do
        {
            return try [id$, name$, uuid$].jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
    
    public func LoadUser(_ ident: UInt64)
    {
        let res = GrabOne(propertyNames(), whereStr: "id = \"\(ident)\"")
        
        if res.isEmpty
        {
            return
        }
        
        let r = res as [String:String]
        
        // fill in the data
        id = UInt64(r["id"]!)!
        name = String(r["name"]!)!
        uuid = String(r["uuid"]!)!
    }
    
    func CreateEmptyUserWithUUID(_ Uuid:String)
    {
        _ = Transaction { (sql) in
            guard sql.query(statement: "start transaction")
            else
            {
                return false
            }
            let query = CreateInsert(_tableName, val: ["name":"無名", "uuid":Uuid])
            guard sql.query(statement: query)
            else
            {
                return false
            }
            
            guard sql.query(statement: "commit")
                else
            {
                return false
            }
            
            return true
        }
    }
    
    public func FetchUser(_ userUUID: String)
    {
        //let res = GrabOne(propertyNames(), whereStr: "uuid = \"\(userUUID)\"")
        
        if GrabWithDataVar([id$, name$, uuid$], whereStr: "uuid = \"\(userUUID)\"")
        {
            //CreateEmptyUserWithUUID(userUUID)
            return
        }
    }
    
    public func UpdateName(Name:String)
    {
        _ =  Transaction { (sql) in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateUpdate(_tableName, val: ["name":Name], whereStr: "uuid = \"\(uuid)\"" )
            guard sql.query(statement: query)
                else
            {
                return false
            }
            
            guard sql.query(statement: "commit")
                else
            {
                return false
            }
            
            return true
        }
        name = Name
    }
}

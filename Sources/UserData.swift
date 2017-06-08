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
    
    public var name:String? = nil;
    public var uuid:String? = nil;
    
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
    
    public func FetchUser(_ userUUID: String)
    {
        var res = GrabOne(propertyNames(), whereStr: "uuid = \"\(userUUID)\"")
        
        if res.isEmpty
        {
            _ = InsertSQL(_tableName, val: ["name":"無名", "uuid":userUUID])
            
            // insert not returning result, fetch again to get id
            res = GrabOne(propertyNames(), whereStr: "uuid = \"\(userUUID)\"")
            
            if res.isEmpty
            {
                return
            }
        }
        
        let r = res as [String:String]
        
        // fill in the data
        id = UInt64(r["id"]!)!
        name = String(r["name"]!)!
        uuid = String(r["uuid"]!)!
    }
    
    public func UpdateName(Name:String)
    {
        _ = UpdateSQL(_tableName, val: ["name":Name], whereStr: "uuid = \"\(uuid!)\"" )
        name = Name
    }
}

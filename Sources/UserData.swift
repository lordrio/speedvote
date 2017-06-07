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
    private let tableName = "Users"
    
    public var id:UInt64 = 0;
    
    public var user_name:String? = nil;
    public var uuid:String? = nil;
    
    public func LoadUser(_ ident: UInt64)
    {
        var res = SelectSQL(tableName, limit: 1, whereStr: "id = \"\(ident)\"")
        
        // fill in the data
        id = UInt64((res?[0][0])!)!
        user_name = String((res?[0][1])!)!
        uuid = String((res?[0][2])!)!
    }
    
    public func FetchUser(_ userUUID: String)
    {
        var res = SelectSQL(tableName, limit: 1, whereStr: "uuid = \"\(userUUID)\"")
        
        if res == nil || res?.count == 0
        {
            _ = InsertSQL(tableName, val: ["name":"無名", "uuid":userUUID])
            
            // insert not returning result, fetch again to get id
            res = SelectSQL(tableName, limit: 1, whereStr: "uuid = \"\(userUUID)\"")
        }
        
        // fill in the data
        id = UInt64((res?[0][0])!)!
        user_name = String((res?[0][1])!)!
        uuid = String((res?[0][2])!)!
    }
    
    public func UpdateName(Name:String)
    {
        _ = UpdateSQL(tableName, val: ["name":Name], whereStr: "uuid = \"\(uuid!)\"" )
        user_name = Name
    }
    
    public func ToJSON() -> String
    {
        let ret = ["id": id, "user_name":user_name!, "uuid":uuid!] as [String : Any];
        return super.ToJSON(ret)
    }
}

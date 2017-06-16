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
    
    public var id:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    public var name:DataVar<String> = DataVar<String>("name", "")
    public var uuid:DataVar<String> = DataVar<String>("uuid", "")
    
    override func jsonEncodedString() throws -> String {
        do
        {
            return try ["data" : ConvertToJsonDic([id, name, uuid])].jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
}

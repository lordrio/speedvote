//
//  CommentData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class CommentData : BaseData
{
    override var _tableName:String { get{ return "Comments" } }
    /*== Table structure for table Comments
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |user_id|bigint(20)|No|
     |comment|text|Yes|NULL
     |datetime|date|No|
     == Dumping data for table Comments*/
    public var id:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    public var event_id:DataVar<UInt64> = DataVar<UInt64>("event_id", 0)
    public var user_id:DataVar<UInt64> = DataVar<UInt64>("user_id", 0)
    
    public var user_name:DataVar<String> = DataVar<String>("user_name", "")
    public var comment:DataVar<String> = DataVar<String>("comment", "")
    public var datetime:DateDataVar<Date> = DateDataVar<Date>("datetime", Date())
    
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ConvertToJsonDic([id, event_id, user_id, user_name, comment, datetime]).jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
}

//
//  VoterData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class VoterData : BaseData
{
    override var _tableName:String { get{ return "Voters" } }
    /*
     == Table structure for table Voters
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |user_id|bigint(20)|No|
     |choice_id|bigint(20)|No|
     == Dumping data for table Voters*/
    public var id:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    public var event_id:DataVar<UInt64> = DataVar<UInt64>("event_id", 0)
    public var user_id:DataVar<UInt64> = DataVar<UInt64>("user_id", 0)
    public var choice_id:DataVar<UInt64> = DataVar<UInt64>("choice_id", 0)
    
    public var user_name:DataVar<String> = DataVar<String>("user_name", "")
    
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ConvertToJsonDic([id, event_id, user_id, user_name, choice_id]).jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
}

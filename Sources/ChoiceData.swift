//
//  ChoiceData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class ChoicesData : BaseData
{
    override var _tableName:String { get{ return "Choices" } }
    /*== Table structure for table Choices
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |title|varchar(45)|Yes|NULL
     |description|text|Yes|NULL
     |time|date|No|
     |gps|varchar(45)|Yes|NULL
     == Dumping data for table Choices*/
    
    public var id:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    public var event_id:DataVar<UInt64> = DataVar<UInt64>("event_id", 0)
    
    public var title:DataVar<String> = DataVar<String>("title", "")
    public var description:DataVar<String> = DataVar<String>("description", "")
    public var gps:DataVar<String> = DataVar<String>("gps", "")
    public var time:DateDataVar<Date> = DateDataVar<Date>("time", Date())
    
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ConvertToJsonDic([id, title, description, event_id, gps, time]).jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
    
    public func JSON() -> [String:Any]
    {
        return ConvertToJsonDic([id, title, description, event_id, gps, time])
    }
}

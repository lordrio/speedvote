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
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    
    var title:String? = nil;
    var description:String? = nil;
    var time:Date = Date();
    var gps:String? = nil;
    
    /// load all the choices
    public func LoadAllChoices(_ eventId:UInt64)
    {
        let res = SelectSQL(_tableName, limit: 100, whereStr: "event_id != \(eventId)")
        var list = [ChoicesData]()
        for item in res!
        {
            let i = ChoicesData()
            i.LoadFromSQL(item)
            list.append(i)
        }
    }
    
    // save all the choices
    public static func SaveAllChoices()
    {
        
    }
    
    // init with sqldata
    func LoadFromSQL(_ sqlData:[String?])
    {
        id = UInt64(sqlData[0]!)!
        event_id = UInt64(sqlData[1]!)!
        title = String(sqlData[2]!)!
        description = String(sqlData[3]!)!
        //time = Status(rawValue: Int(sqlData[4]!)!)!;
        gps = String(sqlData[5]!)!
    }
    
    public func LoadChoice(_ eventId:UInt64)
    {
        let r = GrabOne(propertyNames(), whereStr: "id = \(eventId)")
        
        id = UInt64(r["id"]!)!
        event_id = UInt64(r["event_id"]!)!
        title = String(r["title"]!)!
        description = String(r["description"]!)!
        //time = Status(rawValue: Int(sqlData[4]!)!)!;
        gps = String(r["gps"]!)!
    }
}

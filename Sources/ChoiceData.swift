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
    public func LoadAllChoices(_ eventId:UInt64) -> [ChoicesData]
    {
        let res = SelectSQL(_tableName, limit: 100, whereStr: "event_id == \(eventId)")
        var list = [ChoicesData]()
        for item in res!
        {
            let i = ChoicesData()
            i.LoadFromSQL(item)
            list.append(i)
        }
        
        return list
    }
    
    // save all the choices
    public static func SaveAllChoices(_ list:[ChoicesData], eventId:UInt64)
    {
        _ = Transaction { (sql) -> Bool in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            
            let tableName = ChoicesData()._tableName
            
            let del_query = "DETELE FROM \(tableName) WHERE event_id == \(eventId)"
            guard sql.query(statement: del_query)
                else
            {
                return false
            }
            
            for i in list
            {
                let data = ["title": i.title!,
                            "description": i.description!,
                            "event_id": eventId,
                            "time": i.time,
                            "gps": i.gps!] as [String : Any]
                let query = CreateInsert(tableName, val: data)
                guard sql.query(statement: query)
                    else
                {
                    return false
                }
            }
            
            guard sql.query(statement: "commit")
                else
            {
                return false
            }
            
            return true
        }
    }
    
    public func SaveChoice()
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
    
//    public func LoadFromJson(_ json:String)
//    {
//        if let decoded = try? json.jsonDecode() as? [String:Any] {
//            for (key, value) in decoded!
//            {
//                if let value as? JSONConvertibleNull
//                {
//                    print("The key \"\(key)\" had a null value")
//                }
//            }
//        }
//    }
}

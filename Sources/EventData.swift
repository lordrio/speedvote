//
//  EventData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/6/17.
//
//
import Foundation
import PerfectLib

enum Status : Int
{
    case NotStarted = 0,
    Started,
    Finished,
    Remove
}

/*== Table structure for table Events
 
 |------
 |Column|Type|Null|Default
 |------
 |//**id**//|bigint(20)|No|
 |title|varchar(45)|Yes|NULL
 |desc|text|Yes|NULL
 |user_id|bigint(20)|No|
 |choice_id|bigint(20)|No|
 |status|int(11)|No|
 == Dumping data for table Events*/

class EventData : BaseData
{
    override var _tableName:String { get{ return "Events" } }
    
    // experimental
    public var id:DataVar<UInt64> = DataVar<UInt64>("id", 0)
    
    public var title:DataVar<String> = DataVar<String>("title", "")
    public var description:DataVar<String> = DataVar<String>("description", "")
    public var user_id:DataVar<UInt64> = DataVar<UInt64>("user_id", 0)
    public var user_name:DataVar<String> = DataVar<String>("user_name", "")
    public var status:EnumDataVar<Status> = EnumDataVar<Status>("status", Status.NotStarted)
    
    // TODO: add on later
    public var invited_user:[UInt64]? = nil
    public var endDate:Date = Date() // end date
    public var invite_reference:String = ""
    
    /// Returns the JSON encoded String for any JSONConvertible type.
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ConvertToJsonDic([id, title, description, user_id, status, user_name]).jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
    
    public func JSON() -> [String:Any]
    {
        return ConvertToJsonDic([id, title, description, user_id, status, user_name])
    }
}

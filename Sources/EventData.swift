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
    
    public var id:UInt64 = 0;
    
    public var title:String = ""
    public var description:String = ""
    public var user_id:UInt64 = 0
    public var user_name:String? = ""
    //var choice_id:UInt64 = 0
    public var status = Status.NotStarted
    
    // TODO: add on later
    public var invited_user:[UInt64]? = nil
    public var endDate:Date = Date() // end date
    public var invite_reference:String = ""
    
    /// Returns the JSON encoded String for any JSONConvertible type.
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ["id": id, "title":title, "desc":description, "user_id":user_id, "status":status.rawValue].jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }
    
    public func LoadEvent(_ event_id:UInt64)
    {
        let r = GrabOne(propertyNames(), whereStr: "id = \(event_id)")
        
        user_id = UInt64(r["user_id"]!)!
        id = UInt64(r["id"]!)!
        title = String(r["title"]!)!
        status = Status(rawValue: Int(r["status"]!)!)!
        description = String(r["description"]!)!
        
        let user = UserData()
        user.LoadUser(user_id)
        user_name = user.name
    }

    /// Create an event
    public func CreateEvent(_ UserId:UInt64)
    {
        let data = ["title": title,
                    "description":description,
                    "user_id":UserId,
                    "status":status.rawValue] as [String : Any]
        _ = InsertSQL(_tableName, val: data)
    }
    
    /// Get all the event : TODO filter it to user
    public func GetAllEvents(_ Uuid:String = "") -> [EventData]
    {
        let res = SelectSQL(_tableName, limit: 100, whereStr: "Status != \(Status.Finished.rawValue)")
        var list = [EventData]()
        for item in res!
        {
            let i = EventData()
            i.LoadFromSQL(item)
            list.append(i)
        }
        
        return list
    }
    
    // init with sqldata
    func LoadFromSQL(_ sqlData:[String?])
    {
        id = UInt64(sqlData[0]!)!
        title = String(sqlData[1]!)!
        description = String(sqlData[2]!)!
        user_id = UInt64(sqlData[3]!)!
        status = Status(rawValue: Int(sqlData[5]!)!)!;
        
        let user = UserData()
        user.LoadUser(user_id)
        user_name = user.name
    }
}

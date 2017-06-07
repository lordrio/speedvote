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
    private static let tableName = "Events"
    
    public var id:UInt64 = 0;
    
    public var title:String = ""
    public var desc:String = ""
    public var user_id:UInt64 = 0
    public var user_name:String? = ""
    //var choice_id:UInt64 = 0
    public var status = Status.NotStarted
    
    // TODO: add on later
    var invited_user:[UInt64]? = nil
    var endDate:Date = Date() // end date
    
    /// Returns the JSON encoded String for any JSONConvertible type.
    public override func jsonEncodedString() throws -> String {
        do
        {
            return try ["id": id, "title":title, "desc":desc, "user_id":user_id, "status":status.rawValue].jsonEncodedString()
        }
        catch
        {
            fatalError("\(error)")
        }
    }

    /// Create an event
    public func CreateEvent(_ UserId:UInt64)
    {
        let data = ["title": title,
                    "description":desc,
                    "user_id":UserId,
                    "status":status.rawValue] as [String : Any]
        _ = InsertSQL(EventData.tableName, val: data)
    }
    
    /// Get all the event : TODO filter it to user
    public static func GetAllEvents(_ Uuid:String = "") -> [EventData]
    {
        let res = SelectSQL(tableName, limit: 999999)
        var list = [EventData]()
        for item in res!
        {
            let i = EventData(item)
            list.append(i)
        }
        
        return list
    }
    
    // empty init
    public override init()
    {
    }
    
    // init with sqldata
    public init(_ sqlData:[String?])
    {
        id = UInt64(sqlData[0]!)!
        title = String(sqlData[1]!)!
        desc = String(sqlData[2]!)!
        user_id = UInt64(sqlData[3]!)!
        status = Status(rawValue: Int(sqlData[5]!)!)!;
        
        let user = UserData()
        user.LoadUser(user_id)
        user_name = user.user_name
    }
}

//
//  EventController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation
import PerfectLib

class EventController: BaseController
{
    var event = EventData()
    var listOfEvent = [EventData]()
    
    public func LoadEvent(_ event_id:UInt64)
    {
        let result = GrabWithDataVar([event.user_id, event.id, event.title, event.description, event.status, event.title], whereStr: "id = \(event_id)", base: event)
        
        if result
        {
            let user = UserController()
            user.LoadUser(event.user_id.GetValue() as! UInt64)
            event.user_name.Parse([ "user_name" : user.userData.name.Value as! String])
        }
    }
    
    /// Create an event
    public func CreateEvent(_ eventData:EventData)
    {
        let data = ["title": eventData.title.Value,
                    "description":eventData.description.Value,
                    "user_id":eventData.user_id.Value,
                    "status":(eventData.status.Value as! Status).rawValue] as [String : Any]
        _ = Transaction({ (sql) -> Bool in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(event._tableName, val: data)
            guard sql.query(statement: query)
                else
            {
                return false
            }
            
            guard sql.query(statement: "commit")
                else
            {
                return false
            }
            
            return true
        })
    }
    
    public func GetAllEvents(_ user_id:UInt64 = 0) -> [EventData]
    {
        let res = GrabWithDataVar([event.user_id.Key, event.id.Key, event.title.Key, event.description.Key, event.status.Key, event.title.Key], whereStr: "status != \(Status.Finished.rawValue) AND user_id = \(user_id)", base: EventData()) as [EventData]
        
        let user = UserController()
        for i in res
        {
            user.LoadUser(i.user_id.Value as! UInt64)
            i.user_name.Value = user.userData.name.Value
        }
        
        return res
    }

}

//
//  EventController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation
import PerfectLib
import PerfectHTTP

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
    
    public func CreateHandler() throws -> RequestHandler
    {
        return {
            request, response in
            
            if let json = try? request.postBodyString?.jsonDecode() as? [String: String] {
                debugPrint(String(describing: json))
            }
            
            var responder = ["error": "unknown error"] as [String:Any]
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    debugPrint(json)
                    if let uuid = json["token"] {
                        let user = UserController()
                        user.LoadUser(uuid)
                        if user.IsUserValid()
                        {
                            let event = EventData()
                            if let item = json["title"]
                            {
                                event.title.Value = item
                            }
                            
                            if let item = json["description"]
                            {
                                event.description.Value = item
                            }
                            
                            event.user_id.Value = user.userData.id.Value as! UInt64
                            
                            event.status.Value = Status.NotStarted
                            
                            self.CreateEvent(event)
                            
                            responder = ["msg": "event created"]
                        }
                    }
                }
                
            } catch {
                responder = ["error": "failed to create for event"]
            }
            
            response.setHeader(.contentType, value: "application/json")
            let _ = try? response.setBody(json: responder)
            response.completed()
        }
    }
    
    public func GetAllHandler() throws -> RequestHandler
    {
        return {
            request, response in
            
            if let json = try? request.postBodyString?.jsonDecode() as? [String: String] {
                debugPrint(String(describing: json))
            }
            
            var responder = ["error": "unknown error"] as [String:Any]
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    debugPrint(json)
                    if let uuid = json["token"] {
                        let user = UserController()
                        user.LoadUser(uuid)
                        if user.IsUserValid()
                        {
                            let events = self.GetAllEvents(user.userData.id.GetValue() as! UInt64)
                            responder = ["data" : events]
                        }
                    }
                }
                
            } catch {
                responder = ["error": "failed to get event"]
            }
            
            response.setHeader(.contentType, value: "application/json")
            let _ = try? response.setBody(json: responder)
            response.completed()
        }
    }
    
    public func GetHandler() throws -> RequestHandler
    {
        return {
            request, response in
            
            if let json = try? request.postBodyString?.jsonDecode() as? [String: String] {
                debugPrint(String(describing: json))
            }
            
            var responder = ["error": "unknown error"] as [String:Any]
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    debugPrint(json)
                    
                    self.LoadEvent(UInt64(json["event_id"]!)!)
                    responder = ["data" : self.event.JSON()]
                }
                
            } catch {
                responder = ["error": "failed to get event"]
            }
            
            response.setHeader(.contentType, value: "application/json")
            let _ = try? response.setBody(json: responder)
            response.completed()
        }
    }
}

//
//  ChoiceController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation
import PerfectHTTP

class ChoiceController: BaseController
{
    public func LoadChoice(_ id:UInt64) -> ChoicesData
    {
        let choice = ChoicesData()
        
        _ = GrabWithDataVar([choice.id, choice.event_id, choice.title, choice.description, choice.gps, choice.time], whereStr: "id = \(id)", base: choice)
        
        return choice
    }
    
    public func LoadAllChoices(_ event_id:UInt64 = 0) -> [ChoicesData]
    {
        let choice = ChoicesData()
        let res = GrabWithDataVar([choice.id.Key, choice.event_id.Key, choice.title.Key, choice.description.Key, choice.gps.Key, choice.time.Key], whereStr: "event_id = \(event_id)", base: choice) as [ChoicesData]
        
        return res
    }
    
    public func CreateChoice(_ choice:ChoicesData)
    {
        let data = ["title": choice.title.Value,
                    "description":choice.description.Value,
                    "event_id":choice.event_id.Value,
                    "gps": choice.gps.Value,
                    "time": choice.time.SQLSafeValue,
            ] as [String : Any]
        _ = Transaction({ (sql) -> Bool in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(choice._tableName, val: data)
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
                            let choice = ChoicesData()
                            if let item = json["title"]
                            {
                                choice.title.Value = item
                            }
                            
                            if let item = json["description"]
                            {
                                choice.description.Value = item
                            }
                            
                            if let item = json["event_id"]
                            {
                                choice.event_id.Value = UInt64(item)!
                            }
                            
                            if let item = json["gps"]
                            {
                                choice.gps.Value = item
                            }
                            
                            if let item = json["time"]
                            {
                                choice.time.Value = item
                            }

                            self.CreateChoice(choice)
                            
                            responder = ["msg": "choice created"]
                        }
                    }
                }
                
            } catch {
                responder = ["error": "failed to create for choice"]
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
                    if let item = json["event_id"]
                    {
                        let choices = self.LoadAllChoices(UInt64(item)!)
                        responder = ["data" : choices]
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
                    
                    let choice = self.LoadChoice(UInt64(json["choice_id"]!)!)
                    responder = ["data" : choice.JSON()]
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

//
//  UserController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation
import PerfectLib
import PerfectHTTP

class UserController : BaseController
{
    public var userData : UserData = UserData()
    public func LoadUser(_ ident: UInt64)
    {
        _ = GrabWithDataVar([userData.id, userData.name, userData.uuid], whereStr: "id = \"\(ident)\"", base: userData)
    }
    
    public func LoadUser(_ uuid: String)
    {
        _ = GrabWithDataVar([userData.id, userData.name, userData.uuid], whereStr: "uuid = \"\(uuid)\"", base: userData)
    }
    
    public func IsUserValid() -> Bool
    {
        return userData.id.Value as! UInt64 > 0
    }
    
    func CreateEmptyUserWithUUID(_ Uuid:String)
    {
        _ = Transaction { (sql) in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(userData._tableName, val: ["name":"無名", "uuid":Uuid])
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
        }
    }
    
    public func FetchUser(_ userUUID: String)
    {
        if !GrabWithDataVar([userData.id, userData.name, userData.uuid], whereStr: "uuid = \"\(userUUID)\"", base: userData)
        {
            CreateEmptyUserWithUUID(userUUID)
            return
        }
    }
    
    public func UpdateName(Name:String)
    {
        _ =  Transaction { (sql) in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateUpdate(userData._tableName, val: ["name":userData.name.GetValue()], whereStr: "uuid = \"\(userData.uuid.GetValue())\"" )
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
        }
        
        userData.name.Parse([ "name" : Name ])
    }
    
    override func Handler() throws -> RequestHandler
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
                        self.FetchUser(uuid)
                        if self.IsUserValid() // just registered
                        {
                            self.FetchUser(uuid)
                        }
                        responder = ["data": self.userData.JSON()]
                    }
                }
                
            } catch {
                responder = ["error": "failed to create for user"]
            }
            
            response.setHeader(.contentType, value: "application/json")
            let _ = try? response.setBody(json: responder)
            response.completed()
        }
    }
}

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
    
    func CreateEmptyUserWithUUID(_ Uuid:String)
    {
        _ = Transaction { (sql) in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(userData._tableName, val: ["name":"無名", "uuid":userData.uuid.GetValue()])
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
    
    override func Handler(data: [String:Any]) throws -> RequestHandler
    {
        return {
            request, response in
            
            /*var responder = "{\"error\": \"failed to create\"}"
            
            if let authHeader = request.header(.authorization) {
                if let token = self.parseToken(fromHeader: authHeader) {
                    
                    do {
                        if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                            let name = json["item"]
                            let dueDuate = json["dueDate"]
                            let date = getDate(fromSQLDateTime: dueDuate ?? "")
                            
                            if let hasName = name {
                                responder = Items().create(name: hasName, dueDate: date, forToken: token)
                            }
                        }
                        
                    } catch {
                        responder = "{\"error\": \"Failed to create\"}"
                    }
                    
                    response.setHeader(.contentType, value: "application/json")
                    response.appendBody(string: responder)
                    response.completed()
                    
                }
            }*/
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: "{\"error\": \"failed to create for user\"}")
            response.completed()
        }
    }
}

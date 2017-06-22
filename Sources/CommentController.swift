//
//  CommentController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/22/17.
//
//

import Foundation
import PerfectLib

class CommentController: BaseController
{
    public func LoadComment(_ id:UInt64) -> CommentData
    {
        let comment = CommentData()
        
        let result = GrabWithDataVar([comment.id,
                             comment.event_id,
                             comment.user_id,
                             comment.comment,
                             comment.datetime],
                            whereStr: "id = \(id)",
                            base: comment)
        
        if result
        {
            let user = UserController()
            user.LoadUser(comment.user_id.GetValue() as! UInt64)
            comment.user_name.Parse([ "user_name" : user.userData.name.Value as! String])
        }
        
        return comment
    }
    
    public func LoadAllComment(_ event_id:UInt64 = 0) -> [CommentData]
    {
        let comment = CommentData()
        let res = GrabWithDataVar([comment.id.Key,
                                   comment.event_id.Key,
                                   comment.user_id.Key,
                                   comment.comment.Key,
                                   comment.datetime.Key],
                                  whereStr: "event_id = \(event_id)", base: comment) as [CommentData]
        let user = UserController()
        for i in res
        {
            user.LoadUser(i.user_id.Value as! UInt64)
            i.user_name.Value = user.userData.name.Value
        }
        
        return res
    }
    
    public func CreateComment(_ comment:CommentData)
    {
        let data = [comment.event_id.Key: comment.event_id.Value,
                    comment.user_id.Key:comment.user_id.Value,
                    comment.comment.Key:comment.comment.Value,
                    comment.datetime.Key: comment.datetime.SQLSafeValue,
                    ] as [String : Any]
        _ = Transaction({ (sql) -> Bool in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(comment._tableName, val: data)
            guard sql.query(statement: query)
                else
            {
                Log.info(message: "Failure: \(sql.errorCode()) \(sql.errorMessage())")
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
}

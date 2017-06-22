//
//  VoterController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/22/17.
//
//

import Foundation
import PerfectLib

class VoterController: BaseController
{
    public func LoadVoter(_ id:UInt64) -> VoterData
    {
        let voter = VoterData()
        
        let result = GrabWithDataVar([voter.id,
                                      voter.event_id,
                                      voter.user_id,
                                      voter.choice_id,],
                                     whereStr: "id = \(id)",
            base: voter)
        
        if result
        {
            let user = UserController()
            user.LoadUser(voter.user_id.GetValue() as! UInt64)
            voter.user_name.Parse([ "user_name" : user.userData.name.Value as! String])
        }
        
        return voter
    }
    
    public func LoadAllVoters(_ event_id:UInt64 = 0) -> [VoterData]
    {
        let voter = VoterData()
        let res = GrabWithDataVar([voter.id.Key,
                                   voter.event_id.Key,
                                   voter.user_id.Key,
                                   voter.choice_id.Key],
                                  whereStr: "event_id = \(event_id)", base: voter) as [VoterData]
        let user = UserController()
        for i in res
        {
            user.LoadUser(i.user_id.Value as! UInt64)
            i.user_name.Value = user.userData.name.Value
        }
        
        return res
    }
    
    public func CreateVoter(_ voter:VoterData)
    {
        let data = [voter.event_id.Key: voter.event_id.Value,
                    voter.user_id.Key:voter.user_id.Value,
                    voter.choice_id.Key:voter.choice_id.Value,
                    ] as [String : Any]
        _ = Transaction({ (sql) -> Bool in
            guard sql.query(statement: "start transaction")
                else
            {
                return false
            }
            let query = CreateInsert(voter._tableName, val: data)
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

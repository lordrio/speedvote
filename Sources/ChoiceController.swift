//
//  ChoiceController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation

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
}

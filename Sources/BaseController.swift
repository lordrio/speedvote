//
//  BaseController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation
import PerfectHTTP

class BaseController
{
    func GrabWithDataVar(_ data:[DataVarProtocol], whereStr:String, base:BaseData) -> Bool
    {
        var prop = [String]()
        data.forEach { (d) in
            prop.append(d.GetVariableName())
        }
        
        let result = base.GrabOne(prop, whereStr: whereStr)
        
        if result.isEmpty
        {
            return false
        }
        
        for i in data
        {
            i.Parse(result)
        }
        
        return true
    }
    
    func GrabWithDataVar<T : BaseData>(_ data:[String], whereStr:String, base:BaseData) -> [T]
    {
        let result = base.GrabMultiple(data, whereStr: whereStr)
        
        if result.isEmpty
        {
            return [T]()
        }
        
        var res = [T]()
        
        for i in result
        {
            let d = T() as PropertyNames
            let prop = d.listOfProperty()
            
            for j in prop
            {
                if !(j.self is DataVarProtocol)
                {
                    continue
                }
                
                (j as! DataVarProtocol).Parse(i)
            }
            
            res.append(d as! T)
        }
        
        return res
    }
    
    // handler
    internal func Handler() throws -> RequestHandler
    {
        return {
            request, response in
            let responder = "{\"error\": \"unknown error\"}"
            // Respond with a simple message.
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        }
    }
    
    func parseToken(fromHeader header: String) -> String?
    {
        let bearer = "Bearer "
        if let range = header.range(of: bearer) {
            return header.replacingCharacters(in: range, with: "")
        } else {
            return nil
        }
        
    }
}

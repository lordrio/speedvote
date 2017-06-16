//
//  BaseController.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/16/17.
//
//

import Foundation

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
}

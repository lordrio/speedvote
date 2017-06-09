//
//  BaseData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames
{
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}

class BaseData : JSONConvertible, PropertyNames
{
    var _tableName:String { get{ return "" } }
    /// Returns the JSON encoded String for any JSONConvertible type.
    public func jsonEncodedString() throws -> String {
        return ""
    }
    
    func GrabOneSQLStatement(_ property:[String], whereStr:String) -> (String, [String])
    {
        //var query = ""
        var spl = property
        for (i,data) in spl.enumerated().reversed()
        {
            if data.characters.first! == "_"
            {
                Log.info(message: "removing \(data)")
                spl.remove(at: i)
            }
        }
        
        //Log.info(message: String(describing:spl))
        
        let colname = spl.joined(separator: ",")
        let query = "SELECT \(colname) FROM \(_tableName) WHERE \(whereStr) LIMIT 1"
        
        return (query, spl)
    }
    
    func GrabOne(_ property:[String], whereStr:String) -> [String : String]
    {
        //var query = ""
        let (query, spl) = GrabOneSQLStatement(property, whereStr: whereStr)
        
        //Log.info(message: query)
        let result = CustomQuery(query)
        //Log.info(message: String(describing:result))
        
        var ret = [String:String]()
        if(result == nil || result?.count == 0)
        {
            return ret
        }
        
        let first = result?.first
        
        var cnt = 0;
        for i in spl
        {
            ret[i] = first?[cnt]!
            cnt += 1
        }
        
        return ret
    }
}

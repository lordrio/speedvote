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
    
    func listOfProperty() -> [Any]
    {
        return Mirror(reflecting: self).children.flatMap { $0.value }
    }
}

class BaseData : JSONConvertible, PropertyNames
{
    var _tableName:String { get{ return "" } }
    /// Returns the JSON encoded String for any JSONConvertible type.
    public func jsonEncodedString() throws -> String {
        return ""
    }
    
    required init()
    {
        
    }
    
    func GrabSQLStatement(_ property:[String], whereStr:String, limit:Int = 1) -> (String, [String])
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
        let query = "SELECT \(colname) FROM \(_tableName) WHERE \(whereStr) LIMIT \(limit)"
        
        return (query, spl)
    }
    
    func GrabOne(_ property:[String], whereStr:String) -> [String : String]
    {
        //var query = ""
        let (query, spl) = GrabSQLStatement(property, whereStr: whereStr)
        
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
    
    func GrabMultiple(_ property:[String], whereStr:String) -> [[String : String]]
    {
        //var query = ""
        let (query, spl) = GrabSQLStatement(property, whereStr: whereStr, limit: 100)
        
        //Log.info(message: query)
        let result = CustomQuery(query)
        //Log.info(message: String(describing:result))
        
        var ret = [[String:String]]()
        if(result == nil || result?.count == 0)
        {
            return ret
        }
        
        for first in result!
        {
            var newret = [String:String]()
            var cnt = 0;
            for i in spl
            {
                newret[i] = first[cnt]!
                cnt += 1
            }
            
            ret.append(newret)
        }
        
        return ret
    }
    
    func ConvertToJsonDic(_ stuff:[DataVarProtocol]) -> [String:Any]
    {
        var d = [String:Any]()
        for i in stuff
        {
            d[i.Key] = i.SQLSafeValue
        }
        
        return d
    }
}

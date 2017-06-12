//
//  DataVar.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/12/17.
//
//

import Foundation
import PerfectLib

protocol DataVarProtocol
{
    func Parse(_ json:[String:String])
    func GetValue() -> Any
    func GetVariableName() -> String
}

class DataVar<T : Equatable> : JSONConvertible, DataVarProtocol
{
    public var data:T? = nil
    public var variableName = ""
    
    init(_ varName:String,_ defaultVal:T)
    {
        data = defaultVal
        variableName = varName
    }
    
    
    internal func GetVariableName() -> String
    {
        return variableName
    }

    internal func GetValue() -> Any
    {
        return data!
    }

    /// Returns the JSON encoded String for any JSONConvertible type.
    public func jsonEncodedString() throws -> String
    {
        let v = try! data.jsonEncodedString()
        return "\"\(variableName)\" :"  + v
    }
    
    public func Parse(_ json:[String:String])
    {
        if let val = json[variableName]
        {
            debugPrint(String(describing: val))
            let numberCharacters = NSCharacterSet.decimalDigits.inverted
            if !val.isEmpty && val.rangeOfCharacter(from: numberCharacters) == nil
            {
                data = UInt64(val)
            } else {
                // string contained non-digit characters
                debugPrint("not number")
            }
            data = val as? T
        }
    }
}

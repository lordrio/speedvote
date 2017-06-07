//
//  BaseData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class BaseData :JSONConvertible
{
    /// Returns the JSON encoded String for any JSONConvertible type.
    public func jsonEncodedString() throws -> String {
        return ""
    }
    
    func ToJSON(_ ret:[String:Any]) -> String
    {
        var json = ""
        do
        {
            json = try ret.jsonEncodedString()
        }
        catch
        {
            json = ""
        }
        return json
    }
}

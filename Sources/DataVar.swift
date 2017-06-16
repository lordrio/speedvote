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
    func SetData(_ val:Any)
    var Value:Any { get set }
    var Key:String { get set }
    var SQLSafeValue:Any { get }
}

class DataVar<T> :  DataVarProtocol
{
    internal var SQLSafeValue: Any
    {
        get
        {
            return Value
        }
    }
    
    internal var Value: Any
    {
        get {
            return data!
        }
        set {
            data = newValue as? T
        }
    }
    
    internal var Key: String
        {
        get {
            return variableName
        }
        set {
            variableName = newValue
        }
    }

    internal func SetData(_ val: Any)
    {
    }

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
    
    public func Parse(_ json:[String:String])
    {
        if let val = json[variableName]
        {
            //debugPrint(String(describing: val))
            let numberCharacters = NSCharacterSet.decimalDigits.inverted
            if !val.isEmpty && val.rangeOfCharacter(from: numberCharacters) == nil
            {
                if data is RawRepresentable
                {
                    //debugPrint("isEnum")
                    let raw = Int(val)!
                    SetData(raw)
                }
                else
                {
                    data = UInt64(val)! as? T
                    //debugPrint(String(describing: data))
                }
                
                
            } else {
                // string contained non-digit characters
                //debugPrint("not number")
                if data is Date
                {
                    SetData(val)
                }
                else
                {
                    data = val as? T
                }
            }
        }
    }
}

class EnumDataVar<T : RawRepresentable> : DataVar<T>
{
    func createEnum(rawValue: Int) -> T? {
        return T(rawValue: rawValue as! T.RawValue)
    }

    override func SetData(_ val:Any)
    {
        data = createEnum(rawValue: val as! Int)
        //debugPrint("data is Set " + String(describing: data))
    }
    
    override var SQLSafeValue: Any
        {
        get
        {
            return data?.rawValue ?? 0
        }
    }
}

class DateDataVar<T> : DataVar<T>
{
    override func SetData(_ val:Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        data = dateFormatter.date(from: val as! String) as? T
        debugPrint("data is Set " + String(describing: data))
    }
    
    override var SQLSafeValue: Any
    {
        get
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateFormatter.string(from: (data as! Date))
        }
    }
}

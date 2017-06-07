//
//  ChoiceData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class ChoicesData
{
    /*== Table structure for table Choices
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |title|varchar(45)|Yes|NULL
     |desc|text|Yes|NULL
     |time|date|No|
     |gps|varchar(45)|Yes|NULL
     == Dumping data for table Choices*/
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    
    var title:String? = nil;
    var desc:String? = nil;
    var time:Date = Date();
    var gps:String? = nil;
}

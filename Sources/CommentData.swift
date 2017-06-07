//
//  CommentData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class CommentData
{
    /*== Table structure for table Comments
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |user_id|bigint(20)|No|
     |comment|text|Yes|NULL
     |datetime|date|No|
     == Dumping data for table Comments*/
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    var user_id:UInt64 = 0;
    
    // string
    var user_name:String? = nil;
    var comment:String? = nil;
    var datetime:Date = Date();
}

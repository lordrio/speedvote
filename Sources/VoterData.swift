//
//  VoterData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/7/17.
//
//

import Foundation
import PerfectLib

class VoterData
{
    /*
     == Table structure for table Voters
     
     |------
     |Column|Type|Null|Default
     |------
     |//**id**//|bigint(20)|No|
     |event_id|bigint(20)|No|
     |user_id|bigint(20)|No|
     |choice_id|bigint(20)|No|
     == Dumping data for table Voters*/
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    var user_name:String? = nil;
    var choice_id:UInt64 = 0;
}

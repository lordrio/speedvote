//
//  EventData.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/6/17.
//
//
import Foundation

class EventData
{
    var id:UInt64 = 0;
    
    var title:String? = nil;
    var desc:String? = nil;
    var user_id:UInt64 = 0;
    var user_name:String? = nil;
    var choice_id:UInt64 = 0;
    var status = 0;
}

class UserData
{
    var id:UInt64 = 0;
    
    var user_name:String? = nil;
}

class CommentData
{
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    var user_id:UInt64 = 0;
    
    // string
    var user_name:String? = nil;
    var comment:String? = nil;
    var datetime:Date = Date();
}

class ChoicesData
{
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    
    var title:String? = nil;
    var desc:String? = nil;
    var time:Date = Date();
    var gps:String? = nil;
}

class VoterData
{
    var id:UInt64 = 0;
    
    var event_id:UInt64 = 0;
    var user_name:String? = nil;
    var choice_id:UInt64 = 0;
}

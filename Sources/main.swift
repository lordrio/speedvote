//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MySQLStORM
import PerfectTurnstileMySQL
import PerfectRequestLogger
import TurnstilePerfect
import Foundation

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "application/json")
		response.appendBody(string: "")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}

//// Configuration data for two example servers.
//// This example configuration shows how to launch one or more servers 
//// using a configuration dictionary.
//let confData = [
//	"servers": [
//		[
//			"name":"localhost",
//			"port":8080,
//			"routes":[
//				["method":"get", "uri":"/", "handler":handler],
//				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
//				 "documentRoot":"./webroot",
//				 "allowResponseFilters":true]
//			],
//			"filters":[
//				[
//				"type":"response",
//				"priority":"high",
//				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
//				]
//			]
//		]
//	]
//]

/*
let c = UserController()
c.FetchUser("pipi3")
let x = try? c.userData.jsonEncodedString()
debugPrint(x as Any)
 */

/*
let ctrl = ChoiceController()
for i in 1...5
{
    let j = ChoicesData()
    j.title.Value = "title \(i)"
    j.description.Value = "desc \(i)"
    j.gps.Value = "gps"
    j.event_id.Value = 6 as UInt64? ?? 0;
    j.time.Value = Date()
    ctrl.CreateChoice(j)
}
*/

/*
let ctrl = CommentController()
for i in 1...5
{
    let j = CommentData()
    j.comment.Value = "title \(i)"
    j.user_id.Value = 15 as UInt64? ?? 0;
    j.event_id.Value = 6 as UInt64? ?? 0;
    j.datetime.Value = Date()
    ctrl.CreateComment(j)
}
 */

/*
let ctrl = VoterController()
for i in 1...5
{
    let j = VoterData()
    j.user_id.Value = 15 as UInt64? ?? 0;
    j.event_id.Value = 6 as UInt64? ?? 0;
    j.choice_id.Value = 1 as UInt64? ?? 0;
    ctrl.CreateVoter(j)
}
*/

/*
let list = VoterController().LoadAllVoters(6)
do
{
    let str = try ["data":list].jsonEncodedString()
    Log.info(message: " + " + str)
}
catch
{
    fatalError("\(error)")
}
*/

//#if false
//do {
//	// Launch the servers based on the configuration data.
//	try HTTPServer.launch(configurationData: confData)
//} catch {
//	fatalError("\(error)") // fatal error launching one of the servers
//}
//#endif

if true
{
    StORMdebug = true
    
    let pturnstile = TurnstilePerfectRealm()
    
    
    // Set the connection vatiable
    //connect = SQLiteConnect("./authdb")
    SQLiteConnector.db = "./authdb"
    RequestLogFile.location = "./http_log.txt"
    
    // Set up the Authentication table
    let auth = AuthAccount()
    try? auth.setup()
    
    // Connect the AccessTokenStore
    tokenStore = AccessTokenStore()
    try? tokenStore?.setup()
    
    //let facebook = Facebook(clientID: "CLIENT_ID", clientSecret: "CLIENT_SECRET")
    //let google = Google(clientID: "CLIENT_ID", clientSecret: "CLIENT_SECRET")
    // Create HTTP server.
    let server = HTTPServer()
    
    // Register routes and handlers
    let authWebRoutes = makeWebAuthRoutes()
    let authJSONRoutes = makeJSONAuthRoutes("/api/v1")
    
    // Add the routes to the server.
    server.addRoutes(authWebRoutes)
    server.addRoutes(authJSONRoutes)
    
    // Adding a test route
    var routes = Routes()
    routes.add(method: .get, uri: "/api/v1/test", handler: AuthHandlersJSON.testHandler)
    
    
    
    
    // An example route where authentication will be enforced
    routes.add(method: .get, uri: "/api/v1/check", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    
    
    // An example route where auth will not be enforced
    routes.add(method: .get, uri: "/api/v1/nocheck", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    
    
    
    // Add the routes to the server.
    server.addRoutes(routes)
    
    
    // Setup logging
    let myLogger = RequestLogger()
    
    // add routes to be checked for auth
    var authenticationConfig = AuthenticationConfig()
    authenticationConfig.include("/api/v1/check")
    authenticationConfig.exclude("/api/v1/login")
    authenticationConfig.exclude("/api/v1/register")
    
    let authFilter = AuthFilter(authenticationConfig)
    
    // Note that order matters when the filters are of the same priority level
    server.setRequestFilters([pturnstile.requestFilter])
    server.setResponseFilters([pturnstile.responseFilter])
    
    server.setRequestFilters([(authFilter, .high)])
    
    server.setRequestFilters([(myLogger, .high)])
    server.setResponseFilters([(myLogger, .low)])
    
    server.serverPort = 8080
    
    // Where to serve static files from
    server.documentRoot = "./webroot"
    
    do {
        // Launch the HTTP server.
        try server.start()
    } catch PerfectError.networkError(let err, let msg) {
        print("Network error thrown: \(err) \(msg)")
    }
}

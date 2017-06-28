//
//  Routes.swift
//  PerfectTemplate
//
//  Created by MD FADZLI BIN MD FADZIL on 6/26/17.
//
//

import PerfectLib
import PerfectHTTP

/// Defines and returns the Web Authentication routes
public func SpeedVoteRoutes() -> Routes {
    var routes = Routes()
    
    // An example route where authentication will be enforced
    routes.add(method: .get, uri: "/api/v1/get_auth", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["authDetails"] = "DETAILS: \(String(describing: request.user.authDetails))"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    
    routes.add(method: .get, uri: "/api/v1/user", handler: try! UserController().Handler())
    
    return routes
}

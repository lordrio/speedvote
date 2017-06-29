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
    
    // users
    routes.add(method: .post, uri: "/api/v1/user", handler: try! UserController().Handler())
    
    // events
    routes.add(method: .post, uri: "/api/v1/event", handler: try! EventController().CreateHandler())
    routes.add(method: .post, uri: "/api/v1/event_single", handler: try! EventController().GetHandler())
    routes.add(method: .post, uri: "/api/v1/event_all", handler: try! EventController().GetAllHandler())
    
    // choices
    routes.add(method: .post, uri: "/api/v1/choice", handler: try! ChoiceController().CreateHandler())
    routes.add(method: .post, uri: "/api/v1/choice_single", handler: try! ChoiceController().GetHandler())
    routes.add(method: .post, uri: "/api/v1/choice_all", handler: try! ChoiceController().GetAllHandler())
    
    return routes
}

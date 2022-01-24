//
//  File.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Vapor

struct SchedulesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let schedulesRoute = routes.grouped("schedules")
        schedulesRoute.post("create", use: create)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let shcedulesData = try req.content.decode([ScheduleData].self).map({ record -> Schedule in
            return try Schedule.create(from: record)
        })
        return shcedulesData.create(on: req.db).transform(to: HTTPStatus.created)
    }
}

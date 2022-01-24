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
        schedulesRoute.post("getFor", use: getSchedules)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let shcedulesData = try req.content.decode([ScheduleData].self).map({ record -> Schedule in
            return try Schedule.create(from: record)
        })
        return shcedulesData.create(on: req.db).transform(to: HTTPStatus.created)
    }
    
    func getSchedules(_ req: Request) throws -> EventLoopFuture<[Schedule]> {
        let doctorId = try req.content.decode(DoctorId.self).doctor_id
        
        let schedules = Schedule.query(on: req.db).all().map { schedules in
            schedules.filter { $0.$doctor.id == doctorId }
        }
        
        return schedules
    }
}

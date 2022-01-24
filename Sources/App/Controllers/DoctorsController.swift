//
//  File.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Vapor

struct DoctorsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let doctorsRoute = routes.grouped("doctors")
        doctorsRoute.post("create", use: create)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<Doctor> {
        let doctorData = try req.content.decode(DoctorData.self)
        let doctor = try Doctor.create(from: doctorData)
        return doctor.save(on: req.db).flatMapThrowing { doctor }
    }
}

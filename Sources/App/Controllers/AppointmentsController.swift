//
//  AppointmentsController.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Vapor

struct AppointmentsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let appointmentsRoute = routes.grouped("appointments")
        appointmentsRoute.post("create", use: create)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<Appointment> {
        let appointmentData = try req.content.decode(AppointmentData.self)
        let appointment = try Appointment.create(from: appointmentData)
        return appointment.save(on: req.db).flatMapThrowing { appointment }
    }
}
